import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/corso.dart';
import '../services/api_service.dart';

class CorsiPage extends StatefulWidget {
  const CorsiPage({Key? key}) : super(key: key);

  @override
  State<CorsiPage> createState() => _CorsiPageState();
}

class _CorsiPageState extends State<CorsiPage> {
  final ApiService _apiService = ApiService();
  List<Corso> _corsi = [];
  List<Corso> _corsiFiltered = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadCorsi();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadCorsi() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final corsi = await _apiService.getCorsi();
      setState(() {
        _corsi = corsi;
        _corsiFiltered = corsi;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  
  void _searchCorsi(String query) {
    if (query.isEmpty) {
      setState(() {
        _corsiFiltered = _corsi;
      });
      return;
    }
    
    final queryLower = query.toLowerCase();
    setState(() {
      _corsiFiltered = _corsi.where((corso) {
        return corso.titolo.toLowerCase().contains(queryLower) || 
               corso.docente.toLowerCase().contains(queryLower) ||
               corso.descrizione != null && corso.descrizione!.toLowerCase().contains(queryLower);
      }).toList();
    });
  }

  Future<void> _showCorsoDialog(BuildContext context, [Corso? corso]) async {
    final formKey = GlobalKey<FormState>();
    final titoloController = TextEditingController(text: corso?.titolo ?? '');
    final docenteController = TextEditingController(text: corso?.docente ?? '');
    final descrizioneController = TextEditingController(text: corso?.descrizione ?? '');
    final prezzoController = TextEditingController(
      text: corso?.prezzo.toString() ?? '0.0',
    );

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          corso == null ? 'Nuovo Corso' : 'Modifica Corso',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.lightBlue,
          ),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titoloController,
                  decoration: const InputDecoration(labelText: 'Titolo'),
                  validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
                ),
                TextFormField(
                  controller: docenteController,
                  decoration: const InputDecoration(labelText: 'Docente'),
                  validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
                ),
                TextFormField(
                  controller: descrizioneController,
                  decoration: const InputDecoration(labelText: 'Descrizione'),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: prezzoController,
                  decoration: const InputDecoration(
                    labelText: 'Prezzo',
                    prefixText: '€ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obbligatorio';
                    try {
                      double.parse(value);
                      return null;
                    } catch (e) {
                      return 'Inserire un valore numerico';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annulla',
              style: GoogleFonts.poppins(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final nuovoCorso = Corso(
                  id: corso?.id,
                  titolo: titoloController.text,
                  docente: docenteController.text,
                  descrizione: descrizioneController.text,
                  prezzo: double.parse(prezzoController.text),
                );

                try {
                  if (corso == null) {
                    // Creazione nuovo corso
                    await _apiService.createCorso(nuovoCorso);
                    _showSnackBar('Corso creato con successo');
                  } else {
                    // Aggiornamento corso
                    await _apiService.updateCorso(nuovoCorso);
                    _showSnackBar('Corso aggiornato con successo');
                  }
                  
                  Navigator.of(context).pop();
                  _loadCorsi(); // Ricarica la lista
                } catch (e) {
                  _showSnackBar('Errore: ${e.toString()}');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
            ),
            child: Text(
              'Salva',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCorso(int id) async {
    try {
      final success = await _apiService.deleteCorso(id);
      if (success) {
        // Rimuovi corso dalla lista locale
        setState(() {
          _corsi.removeWhere((c) => c.id == id);
          _corsiFiltered.removeWhere((c) => c.id == id);
        });
        _showSnackBar('Corso eliminato con successo');
      }
    } catch (e) {
      _showSnackBar('Errore durante l\'eliminazione: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCorsoDialog(context),
        backgroundColor: Colors.lightBlue,
        tooltip: 'Aggiungi corso',
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con titolo e ricerca
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gestione Corsi',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000080),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _searchCorsi,
                  decoration: InputDecoration(
                    hintText: 'Cerca corsi...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchCorsi('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue[300]!),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ],
            ),
          ),
          
          // Contenuto principale
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 48),
            const SizedBox(height: 16),
            Text(
              'Errore: $_errorMessage',
              style: TextStyle(color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCorsi,
              icon: const Icon(Icons.refresh),
              label: const Text('Riprova'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    if (_corsiFiltered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, color: Colors.grey[400], size: 64),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'Nessun corso disponibile'
                  : 'Nessun risultato per "${_searchController.text}"',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchController.text.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  _searchCorsi('');
                },
                icon: const Icon(Icons.clear),
                label: const Text('Cancella ricerca'),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCorsi,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _corsiFiltered.length,
        itemBuilder: (context, index) {
          final corso = _corsiFiltered[index];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
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
              title: Text(
                corso.titolo,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Docente: ${corso.docente}',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  if (corso.descrizione != null && corso.descrizione!.isNotEmpty)
                    Text(
                      corso.descrizione!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    '€ ${corso.prezzo.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showCorsoDialog(context, corso),
                    tooltip: 'Modifica',
                    color: Colors.blue[700],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteCorso(corso.id!),
                    tooltip: 'Elimina',
                    color: Colors.red[700],
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}