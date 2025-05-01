<?php
/**
 * Web Service REST in PHP per il database TPSI_DB
 * 
 * Questo web service fornisce accesso ai dati del database TPSI_DB attraverso una API REST.
 * Gestisce tre entità principali: Studenti e Corsi con operazioni CRUD complete,
 * e Iscrizioni con operazioni di sola lettura.
 * 
 * TABELLA DELLE OPERAZIONI PER RISORSA:
 * =====================================
 * | Risorsa    | CREATE | READ (all) | READ (one) | UPDATE | DELETE |
 * |------------|--------|------------|------------|--------|--------|
 * | Studenti   |   ✓    |     ✓      |     ✓      |   ✓    |   ✓    |
 * | Corsi      |   ✓    |     ✓      |     ✓      |   ✓    |   ✓    |
 * | Iscrizioni |        |     ✓      |     ✓      |        |        |
 * 
 * ENDPOINTS DISPONIBILI:
 * ======================
 * 
 * STUDENTI:
 * ---------
 * - GET /api/studenti - Recupera tutti gli studenti
 * - GET /api/studenti/{id} - Recupera un singolo studente
 * - POST /api/studenti - Crea nuovo studente (nome, cognome, email, data_nascita)
 * - PUT /api/studenti/{id} - Aggiorna uno studente
 * - DELETE /api/studenti/{id} - Elimina uno studente
 * 
 * CORSI:
 * ------
 * - GET /api/corsi - Recupera tutti i corsi
 * - GET /api/corsi/{id} - Recupera un singolo corso
 * - POST /api/corsi - Crea nuovo corso (titolo, descrizione, docente, prezzo)
 * - PUT /api/corsi/{id} - Aggiorna un corso
 * - DELETE /api/corsi/{id} - Elimina un corso
 * 
 * ISCRIZIONI (solo lettura):
 * --------------------------
 * - GET /api/iscrizioni/studente/{id} - Recupera iscrizioni di uno studente
 * - GET /api/iscrizioni/corso/{id} - Recupera studenti iscritti a un corso
 */

// Configurazione Database - Stabilisce connessione al database MySQL
// Parametri: host, username, password, nome_db
$connessione = new mysqli("localhost", "root", "", "tpsi_db");
if ($connessione->connect_error) {
    // Gestione errore di connessione
    rispondi(["errore" => "Errore connessione DB"], 500);
}
// Imposta il set di caratteri a UTF-8 per supportare caratteri speciali
$connessione->set_charset("utf8");

// Headers per CORS e risposta - Permette richieste cross-origin
header("Access-Control-Allow-Origin: *");                    // Consente richieste da qualsiasi origine
header("Access-Control-Allow-Headers: Content-Type");        // Consente header Content-Type
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE"); // Metodi HTTP permessi
// Gestisce le richieste OPTIONS per CORS preflight
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') exit(0);

/*debug
if (isset($_GET['debug'])) {
    echo "<pre>";
    echo "REQUEST_URI: " . $_SERVER['REQUEST_URI'] . "\n";
    echo "URI elaborato: " . $uri . "\n";
    echo "Parti: " . print_r($parti, true) . "\n";
    echo "Risorsa: " . $risorsa . "\n";
    echo "ID: " . $id . "\n";
    echo "</pre>";
    exit;
}
*/

// Parsing URL e routing - Estrae informazioni dall'URL
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
// Ottieni la parte dopo "api.php/"
if (strpos($uri, 'api.php/') !== false) {
    $uri = substr($uri, strpos($uri, 'api.php/') + strlen('api.php/'));
} else {
    $uri = '';
}

$parti = explode('/', trim($uri, '/'));    // Divide l'URI in parti
$risorsa = $parti[0] ?? '';                                  // Prima parte = nome risorsa
$id = $parti[1] ?? null;                                     // Seconda parte = ID o sottocomando
$sottoRisorsa = $parti[2] ?? null;                           // Terza parte = parametro aggiuntivo
$metodo = $_SERVER['REQUEST_METHOD'];                        // Ottiene il metodo HTTP (GET, POST, ecc.)

// Routing alle funzioni di gestione - Indirizza la richiesta al gestore appropriato
switch ($risorsa) {
    case 'studenti': gestisciRisorsa($metodo, $id, 'studenti'); break;  // Gestione studenti
    case 'corsi': gestisciRisorsa($metodo, $id, 'corsi'); break;        // Gestione corsi
    case 'iscrizioni': 
        // Gestione casi speciali per iscrizioni (relazioni)
        if ($id === "studente" || $id === "corso") {
            gestisciIscrizioni($metodo, $id, $sottoRisorsa);  // Query relazionali speciali
        } else {
            rispondi(["errore" => "Operazione non supportata per iscrizioni"], 405);
        }
        break;
    default: rispondi(["errore" => "Risorsa non trovata"], 404);  // Risorsa non valida
}

/**
 * Gestisce operazioni CRUD sulle risorse
 * Implementa GET, POST, PUT, DELETE per le tabelle del database
 * 
 * @param string $metodo Metodo HTTP (GET, POST, PUT, DELETE)
 * @param mixed $id ID risorsa (null per collezioni)
 * @param string $tabella Nome tabella su cui operare
 */
function gestisciRisorsa($metodo, $id, $tabella) {
    global $connessione;
    
    // Mappatura campi per ciascuna tabella con i tipi di dati per bind_param
    // 's' = string, 'i' = integer, 'd' = double/float
    $campiTabella = [
        'studenti' => ['nome' => 's', 'cognome' => 's', 'email' => 's', 'data_nascita' => 's'],
        'corsi' => ['titolo' => 's', 'descrizione' => 's', 'docente' => 's', 'prezzo' => 'd']
    ];
    
    // Campi obbligatori per ogni tabella - usati per validazione input
    $campiObbligatori = [
        'studenti' => ['nome', 'cognome', 'email', 'data_nascita'],
        'corsi' => ['titolo', 'docente', 'prezzo']
    ];
    
    // Singolare per messaggi - utile per personalizzare i messaggi di risposta
    $singolare = rtrim($tabella, 'i');
    
    switch ($metodo) {
        case 'GET':
            if ($id) {
                // READ one - Recupera singola risorsa
                $stmt = $connessione->prepare("SELECT * FROM $tabella WHERE id = ?");
                $stmt->bind_param("i", $id);  // "i" = integer
                $stmt->execute();
                $risultato = $stmt->get_result();
                
                // Verifica se la risorsa esiste
                if ($risultato->num_rows === 0) {
                    rispondi(["errore" => ucfirst($singolare) . " non trovato"], 404);
                }
                
                // Invia risposta con la risorsa richiesta
                rispondi($risultato->fetch_assoc(), 200, $singolare);
            } else {
                // READ all - Recupera tutte le risorse
                $risultato = $connessione->query("SELECT * FROM $tabella");
                rispondi($risultato->fetch_all(MYSQLI_ASSOC), 200, $tabella);
            }
            break;
            
        case 'POST':
            // CREATE - Crea nuova risorsa
            $dati = ottieniDatiRichiesta(); // Legge dati ricevuti
            
            // Verifica campi obbligatori
            foreach ($campiObbligatori[$tabella] as $campo) {
                if (empty($dati[$campo])) {
                    rispondi(["errore" => "Campo obbligatorio mancante: $campo"], 400);
                }
            }
            
            // Costruzione query di inserimento
            $campi = array_keys(array_intersect_key($campiTabella[$tabella], $dati));
            $placeholders = array_fill(0, count($campi), '?');  // Crea '?, ?, ...'
            
            $query = "INSERT INTO $tabella (" . implode(', ', $campi) . ") VALUES (" . implode(', ', $placeholders) . ")";
            $stmt = $connessione->prepare($query);
            
            // Prepara i valori e tipi per bind_param
            $tipi = '';
            $valori = [];
            foreach ($campi as $campo) {
                $tipi .= $campiTabella[$tabella][$campo]; // Aggiunge tipo ('s', 'i', 'd')
                $valori[] = $dati[$campo];               // Aggiunge valore
            }
            
            // Bind e esecuzione - prepara i parametri e esegue la query
            $stmt->bind_param($tipi, ...$valori);
            if (!$stmt->execute()) {
                rispondi(["errore" => "Errore inserimento: " . $stmt->error], 500);
            }
            
            $nuovoId = $stmt->insert_id; // ID della risorsa appena creata
            
            // Leggi risorsa inserita per restituirla nella risposta
            $stmt = $connessione->prepare("SELECT * FROM $tabella WHERE id = ?");
            $stmt->bind_param("i", $nuovoId);
            $stmt->execute();
            rispondi($stmt->get_result()->fetch_assoc(), 201, $singolare); // 201 = Created
            break;
            
        case 'PUT':
            // UPDATE - Aggiorna risorsa esistente
            if (!$id) {
                rispondi(["errore" => "ID mancante"], 400);
            }
            
            $dati = ottieniDatiRichiesta();
            if (empty($dati)) {
                rispondi(["errore" => "Nessun dato da aggiornare"], 400);
            }
            
            // Verifica esistenza della risorsa
            $stmt = $connessione->prepare("SELECT id FROM $tabella WHERE id = ?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            if ($stmt->get_result()->num_rows === 0) {
                rispondi(["errore" => ucfirst($singolare) . " non trovato"], 404);
            }
            
            // Costruzione query di aggiornamento
            $campi = array_keys(array_intersect_key($campiTabella[$tabella], $dati));
            $setClause = array_map(function($campo) {
                return "$campo = ?";
            }, $campi);
            
            $query = "UPDATE $tabella SET " . implode(', ', $setClause) . " WHERE id = ?";
            $stmt = $connessione->prepare($query);
            
            // Prepara i valori e tipi per bind_param
            $tipi = '';
            $valori = [];
            foreach ($campi as $campo) {
                $tipi .= $campiTabella[$tabella][$campo];
                $valori[] = $dati[$campo];
            }
            $tipi .= 'i';       // Aggiunge tipo per l'ID
            $valori[] = $id;    // Aggiunge l'ID alla fine
            
            // Bind e esecuzione
            $stmt->bind_param($tipi, ...$valori);
            if (!$stmt->execute()) {
                rispondi(["errore" => "Errore aggiornamento: " . $stmt->error], 500);
            }
            
            // Leggi risorsa aggiornata per restituirla nella risposta
            $stmt = $connessione->prepare("SELECT * FROM $tabella WHERE id = ?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            rispondi($stmt->get_result()->fetch_assoc(), 200, $singolare);
            break;
            
        case 'DELETE':
            // DELETE - Elimina risorsa
            if (!$id) {
                rispondi(["errore" => "ID mancante"], 400);
            }
            
            $stmt = $connessione->prepare("DELETE FROM $tabella WHERE id = ?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            
            // Verifica se la risorsa è stata effettivamente eliminata
            if ($stmt->affected_rows === 0) {
                rispondi(["errore" => ucfirst($singolare) . " non trovato"], 404);
            }
            
            http_response_code(204); // 204 = No content (successo senza contenuto)
            exit;
            
        default:
            rispondi(["errore" => "Metodo non supportato"], 405); // 405 = Method Not Allowed
    }
}

/**
 * Gestisce casi speciali per le iscrizioni
 * Implementa query relazionali specifiche per le iscrizioni (solo lettura)
 * 
 * @param string $metodo Metodo HTTP
 * @param string $tipo Tipo di relazione (studente/corso)
 * @param mixed $id ID dello studente o del corso
 */
function gestisciIscrizioni($metodo, $tipo, $id) {
    global $connessione;
    
    // Solo GET è supportato per queste query speciali
    if ($metodo !== 'GET') {
        rispondi(["errore" => "Solo GET è supportato per iscrizioni"], 405);
    }
    
    if ($tipo === "studente") {
        // GET iscrizioni di uno studente - include dettagli corsi
        $stmt = $connessione->prepare(
            "SELECT i.*, c.titolo, c.docente 
             FROM iscrizioni i 
             JOIN corsi c ON i.corso_id = c.id 
             WHERE i.studente_id = ?"
        );
        $stmt->bind_param("i", $id);
        $stmt->execute();
        rispondi($stmt->get_result()->fetch_all(MYSQLI_ASSOC), 200, "iscrizioni_studente");
    } else if ($tipo === "corso") {
        // GET studenti iscritti a un corso - include dettagli studenti
        $stmt = $connessione->prepare(
            "SELECT i.*, s.nome, s.cognome, s.email 
             FROM iscrizioni i 
             JOIN studenti s ON i.studente_id = s.id 
             WHERE i.corso_id = ?"
        );
        $stmt->bind_param("i", $id);
        $stmt->execute();
        rispondi($stmt->get_result()->fetch_all(MYSQLI_ASSOC), 200, "iscrizioni_corso");
    }
}

/**
 * Invia risposta al client
 * Formatta e invia i dati in JSON
 * 
 * @param mixed $dati Dati da inviare
 * @param int $codice Codice HTTP di risposta
 * @param string $elemento Elemento radice XML (non usato in JSON)
 */
function rispondi($dati, $codice = 200, $elemento = "risposta") {
    http_response_code($codice);  // Imposta codice di stato HTTP
    
    // Invia risposta JSON
    header("Content-Type: application/json; charset=UTF-8");
    echo json_encode($dati);
    exit;
}

/**
 * Ottieni dati dalla richiesta POST/PUT
 * Supporta dati in formato JSON o form tradizionale
 * 
 * @return array Dati ricevuti
 */
function ottieniDatiRichiesta() {
    $inputJSON = file_get_contents('php://input');  // Legge il corpo della richiesta
    $dati = json_decode($inputJSON, true);          // Decodifica JSON
    
    // Se non è JSON valido, prova a usare i dati POST tradizionali
    if (json_last_error() !== JSON_ERROR_NONE) {
        $dati = $_POST;
    }
    
    return $dati;
}