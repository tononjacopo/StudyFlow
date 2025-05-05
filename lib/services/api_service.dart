import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/studente.dart';
import '../models/corso.dart';
import '../models/iscrizione.dart';

class ApiService {
  // URL corretto per il tuo server
  static const String baseUrl = 'http://localhost/api_study_flow/api.php';

  // Headers per le richieste HTTP
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Metodo per ottenere tutti gli studenti
  Future<List<Studente>> getStudenti() async {
    final response = await http.get(
      Uri.parse('$baseUrl/studenti'),  // URL completo: http://localhost/api_study_flow/api.php/studenti
      headers: _headers,
    );
    
    // Codice per il debug
    print('Status code: ${response.statusCode}');
    print('Corpo risposta: ${response.body}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Studente.fromJson(json)).toList();
    } else {
      throw Exception('Errore nel caricamento degli studenti: ${response.statusCode} - ${response.body}');
    }
  }

  // Ottieni un singolo studente
  Future<Studente> getStudente(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/studenti/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Studente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Errore nel caricamento dello studente: ${response.statusCode}');
    }
  }

  // Crea un nuovo studente
  Future<Studente> createStudente(Studente studente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/studenti'),
      headers: _headers,
      body: json.encode(studente.toJson()),
    );

    if (response.statusCode == 201) {
      return Studente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Errore nella creazione dello studente: ${response.statusCode}');
    }
  }

  // Aggiorna uno studente
  Future<Studente> updateStudente(Studente studente) async {
    final response = await http.put(
      Uri.parse('$baseUrl/studenti/${studente.id}'),
      headers: _headers,
      body: json.encode(studente.toJson()),
    );

    if (response.statusCode == 200) {
      return Studente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Errore nell\'aggiornamento dello studente: ${response.statusCode}');
    }
  }

  // Elimina uno studente
  Future<bool> deleteStudente(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/studenti/$id'),
      headers: _headers,
    );

    return response.statusCode == 204;
  }

  // *** GESTIONE CORSI ***
  
  // Ottieni tutti i corsi
  Future<List<Corso>> getCorsi() async {
    final response = await http.get(
      Uri.parse('$baseUrl/corsi'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Corso.fromJson(json)).toList();
    } else {
      throw Exception('Errore nel caricamento dei corsi: ${response.statusCode}');
    }
  }

  // Ottieni un singolo corso
  Future<Corso> getCorso(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/corsi/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Corso.fromJson(json.decode(response.body));
    } else {
      throw Exception('Errore nel caricamento del corso: ${response.statusCode}');
    }
  }

  // Crea un nuovo corso
  Future<Corso> createCorso(Corso corso) async {
    final response = await http.post(
      Uri.parse('$baseUrl/corsi'),
      headers: _headers,
      body: json.encode(corso.toJson()),
    );

    if (response.statusCode == 201) {
      return Corso.fromJson(json.decode(response.body));
    } else {
      throw Exception('Errore nella creazione del corso: ${response.statusCode}');
    }
  }

  // Aggiorna un corso
  Future<Corso> updateCorso(Corso corso) async {
    final response = await http.put(
      Uri.parse('$baseUrl/corsi/${corso.id}'),
      headers: _headers,
      body: json.encode(corso.toJson()),
    );

    if (response.statusCode == 200) {
      return Corso.fromJson(json.decode(response.body));
    } else {
      throw Exception('Errore nell\'aggiornamento del corso: ${response.statusCode}');
    }
  }

  // Elimina un corso
  Future<bool> deleteCorso(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/corsi/$id'),
      headers: _headers,
    );

    return response.statusCode == 204;
  }

  // *** GESTIONE ISCRIZIONI ***
  
  // Ottieni iscrizioni di uno studente
  Future<List<Iscrizione>> getIscrizioniStudente(int studenteId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/iscrizioni/studente/$studenteId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Iscrizione.fromJson(json)).toList();
    } else {
      throw Exception('Errore nel caricamento delle iscrizioni: ${response.statusCode}');
    }
  }

  // Ottieni studenti iscritti a un corso
  Future<List<Iscrizione>> getIscrizioniCorso(int corsoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/iscrizioni/corso/$corsoId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Iscrizione.fromJson(json)).toList();
    } else {
      throw Exception('Errore nel caricamento delle iscrizioni: ${response.statusCode}');
    }
  }
}