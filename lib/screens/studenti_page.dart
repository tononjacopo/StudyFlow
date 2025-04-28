import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/studente.dart';
import '../services/api_service.dart';
import '../widgets/responsive_layout.dart';

class StudentiPage extends StatefulWidget {
  const StudentiPage({Key? key}) : super(key: key);

  @override
  State<StudentiPage> createState() => _StudentiPageState();
}

class _StudentiPageState extends State<StudentiPage> {
  final ApiService _apiService = ApiService();
  List<Studente> _studenti = [];
  List<Studente> _studentiFiltered = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudenti();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudenti() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final studenti = await _apiService.getStudenti();
      setState(() {
        _studenti = studenti;
        _studentiFiltered = studenti;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  
  void _searchStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        _studentiFiltered = _studenti;
      });
      return;
    }
    
    final queryLower = query.toLowerCase();
    setState(() {
      _studentiFiltered = _studenti.where((studente) {
        final fullName = '${studente.nome} ${studente.cognome}'.toLowerCase();
        final email = studente.email.toLowerCase();
        return fullName.contains(queryLower) || 
               email.contains(queryLower);
      }).toList();
    });
  }

  Future<void> _deleteStudent(int id) async {
    try {
      final success = await _apiService.deleteStudente(id);
      if (success) {
        // Rimuovi studente dalla lista locale
        setState(() {
          _studenti.removeWhere((s) => s.id == id);
          _studentiFiltered.removeWhere((s) => s.id == id);
        });
        _showSnackBar('Studente eliminato con successo');
      }
    } catch (e) {
      _showSnackBar('Errore durante l\'eliminazione: ${e.toString()}');
    }
  }

  Future<void> _showStudenteDialog(BuildContext context, [Studente? studente]) async {
    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController(text: studente?.nome ?? '');
    final cognomeController = TextEditingController(text: studente?.cognome ?? '');
    final emailController = TextEditingController(text: studente?.email ?? '');
    final dataNascitaController = TextEditingController(text: studente?.dataNascita ?? '');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          studente == null ? 'Nuovo Studente' : 'Modifica Studente',
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
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
                ),
                TextFormField(
                  controller: cognomeController,
                  decoration: const InputDecoration(labelText: 'Cognome'),
                  validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obbligatorio';
                    if (!value.contains('@')) return 'Email non valida';
                    return null;
                  },
                ),
                TextFormField(
                  controller: dataNascitaController,
                  decoration: const InputDecoration(
                    labelText: 'Data di Nascita',
                    hintText: 'YYYY-MM-DD',
                  ),
                  validator: (value) => value!.isEmpty ? 'Campo obbligatorio' : null,
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
                final nuovoStudente = Studente(
                  id: studente?.id,
                  nome: nomeController.text,
                  cognome: cognomeController.text,
                  email: emailController.text,
                  dataNascita: dataNascitaController.text,
                );

                try {
                  if (studente == null) {
                    // Creazione nuovo studente
                    await _apiService.createStudente(nuovoStudente);
                    _showSnackBar('Studente creato con successo');
                  } else {
                    // Aggiornamento studente
                    await _apiService.updateStudente(nuovoStudente);
                    _showSnackBar('Studente aggiornato con successo');
                  }
                  
                  Navigator.of(context).pop();
                  _loadStudenti(); // Ricarica la lista
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
        onPressed: () => _showStudenteDialog(context),
        backgroundColor: Colors.lightBlue,
        tooltip: 'Aggiungi studente',
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
                  'Gestione Studenti',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000080),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _searchStudents,
                  decoration: InputDecoration(
                    hintText: 'Cerca studenti...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchStudents('');
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
              onPressed: _loadStudenti,
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

    if (_studentiFiltered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_rounded, color: Colors.grey[400], size: 64),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'Nessuno studente registrato'
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
                  _searchStudents('');
                },
                icon: const Icon(Icons.clear),
                label: const Text('Cancella ricerca'),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadStudenti,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _studentiFiltered.length,
        itemBuilder: (context, index) {
          final studente = _studentiFiltered[index];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text(
                  '${studente.nome[0]}${studente.cognome[0]}',
                  style: TextStyle(color: Colors.blue[800]),
                ),
              ),
              title: Text(
                '${studente.nome} ${studente.cognome}',
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
                    'Email: ${studente.email}',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  Text(
                    'Data di nascita: ${studente.dataNascita}',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showStudenteDialog(context, studente),
                    tooltip: 'Modifica',
                    color: Colors.blue[700],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteStudent(studente.id!),
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