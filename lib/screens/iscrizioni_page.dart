import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/iscrizione.dart';
import '../models/studente.dart';
import '../models/corso.dart';
import '../services/api_service.dart';


class IscrizioniPage extends StatefulWidget {
  final int? studenteId;
  final int? corsoId;
  final String? titolo;
  final Function(int, String)? onSelectStudent;
  final Function(int, String)? onSelectCourse;
  final VoidCallback? onBack;

  const IscrizioniPage({
    Key? key,
    this.studenteId,
    this.corsoId,
    this.titolo,
    this.onSelectStudent,
    this.onSelectCourse,
    this.onBack,
  }) : super(key: key);

  @override
  State<IscrizioniPage> createState() => _IscrizioniPageState();
}

class _IscrizioniPageState extends State<IscrizioniPage> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<Iscrizione> _iscrizioni = [];
  List<Studente> _studenti = [];
  List<Corso> _corsi = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late TabController _tabController;
  
  // Aggiunti per tracciare i parametri correnti
  int? _currentStudentId;
  int? _currentCourseId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentStudentId = widget.studenteId;
    _currentCourseId = widget.corsoId;
    _loadData();
  }
  
  @override
  void didUpdateWidget(IscrizioniPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se i parametri sono cambiati, ricarica i dati
    if (oldWidget.studenteId != widget.studenteId || 
        oldWidget.corsoId != widget.corsoId) {
      // Aggiorna i tracker dei parametri correnti
      _currentStudentId = widget.studenteId;
      _currentCourseId = widget.corsoId;
      
      // Forza il ricaricamento dei dati
      setState(() {
        _iscrizioni = []; // Reset dei dati vecchi
        _isLoading = true;
      });
      _loadData(); // Carica nuovi dati
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      if (widget.studenteId != null) {
        // Reset dati precedenti
        _iscrizioni = [];
        final iscrizioni = await _apiService.getIscrizioniStudente(widget.studenteId!);
        
        // Verifica che i parametri non siano cambiati durante il caricamento
        if (mounted && widget.studenteId == _currentStudentId) {
          setState(() {
            _iscrizioni = iscrizioni;
            _isLoading = false;
          });
        }
      } else if (widget.corsoId != null) {
        // Reset dati precedenti
        _iscrizioni = [];
        final iscrizioni = await _apiService.getIscrizioniCorso(widget.corsoId!);
        
        // Verifica che i parametri non siano cambiati durante il caricamento
        if (mounted && widget.corsoId == _currentCourseId) {
          setState(() {
            _iscrizioni = iscrizioni;
            _isLoading = false;
          });
        }
      } else {
        // Reset dati precedenti
        _studenti = [];
        _corsi = [];
        
        // Carica entrambi per la panoramica
        final studenti = await _apiService.getStudenti();
        final corsi = await _apiService.getCorsi();
        
        if (mounted) {
          setState(() {
            _studenti = studenti;
            _corsi = corsi;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      // Verifica che il widget sia ancora montato prima di aggiornare lo stato
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con titolo e pulsante indietro se necessario
          _buildHeader(),
          
          // Contenuto principale
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mostra pulsante indietro se siamo in una vista dettaglio
          if (widget.onBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: widget.onBack,
              tooltip: 'Torna alla panoramica',
              splashRadius: 24,
              color: const Color(0xFF000080),
            ),
            
          Expanded(
            child: Text(
              widget.titolo ?? 'Iscrizioni',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF000080),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Pulsante di refresh
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadData,
            tooltip: 'Aggiorna',
            splashRadius: 24,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red[700],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Errore: $_errorMessage',
              style: TextStyle(color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Riprova'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000080),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    // Vista dettaglio: iscrizioni di uno studente o di un corso
    if (widget.studenteId != null || widget.corsoId != null) {
      return _buildIscrizioniDettaglio();
    }
    
    // Vista panoramica: tutti gli studenti e corsi
    return _buildPanoramica();
  }

  Widget _buildIscrizioniDettaglio() {
    if (_iscrizioni.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Colors.blue[300],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              widget.studenteId != null 
                  ? 'Questo studente non è iscritto a nessun corso'
                  : 'Nessuno studente iscritto a questo corso',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Utilizzo una chiave unica basata sui parametri attuali
    final String listKey = 'iscrizioni_list_${widget.studenteId ?? 0}_${widget.corsoId ?? 0}';
    
    return ListView.builder(
      key: Key(listKey), // Forza il rebuild della lista con nuova chiave
      padding: const EdgeInsets.all(16),
      itemCount: _iscrizioni.length,
      itemBuilder: (context, index) {
        final iscrizione = _iscrizioni[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              widget.studenteId != null
                  ? iscrizione.titoloCorso ?? 'Corso senza titolo'
                  : '${iscrizione.nomeStudente ?? ''} ${iscrizione.cognomeStudente ?? ''}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.studenteId != null
                    ? 'Docente: ${iscrizione.docente ?? 'Non specificato'}\n'
                      'Data iscrizione: ${iscrizione.dataIscrizione}'
                    : 'Data iscrizione: ${iscrizione.dataIscrizione}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            isThreeLine: widget.studenteId != null,
          ),
        );
      },
    );
  }

  Widget _buildPanoramica() {
    return Column(
      children: [
        // Tab Bar per la navigazione tra studenti e corsi
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF000080),
            unselectedLabelColor: Colors.grey[600],
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            indicatorColor: const Color(0xFF000080),
            indicatorWeight: 3,
            tabs: const [
              Tab(
                icon: Icon(Icons.person_rounded),
                text: 'Studenti',
              ),
              Tab(
                icon: Icon(Icons.book_rounded),
                text: 'Corsi',
              ),
            ],
          ),
        ),
        
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Studenti Tab
              _studenti.isEmpty
                  ? Center(
                      child: Text(
                        'Nessuno studente trovato',
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    )
                  : _buildStudentiList(),
              
              // Corsi Tab
              _corsi.isEmpty
                  ? Center(
                      child: Text(
                        'Nessun corso trovato',
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    )
                  : _buildCorsiList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentiList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _studenti.length,
      itemBuilder: (context, index) {
        final studente = _studenti[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (widget.onSelectStudent != null) {
                widget.onSelectStudent!(
                  studente.id!,
                  '${studente.nome} ${studente.cognome}',
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      '${studente.nome[0]}${studente.cognome[0]}',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Dettagli
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${studente.nome} ${studente.cognome}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          studente.email,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Icona
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[600], size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCorsiList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _corsi.length,
      itemBuilder: (context, index) {
        final corso = _corsi[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (widget.onSelectCourse != null) {
                widget.onSelectCourse!(corso.id!, corso.titolo);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icona corso
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.book_rounded,
                      color: Colors.blue[800],
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Dettagli
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          corso.titolo,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Docente: ${corso.docente}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '€ ${corso.prezzo.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Icona
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[600], size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}