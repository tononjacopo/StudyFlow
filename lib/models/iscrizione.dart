class Iscrizione {
  final int? id;
  final int studenteId;
  final int corsoId;
  final String dataIscrizione;
  final String? titoloCorso;
  final String? docente;
  final String? nomeStudente;
  final String? cognomeStudente;

  Iscrizione({
    this.id,
    required this.studenteId,
    required this.corsoId,
    required this.dataIscrizione,
    this.titoloCorso,
    this.docente,
    this.nomeStudente,
    this.cognomeStudente,
  });

  factory Iscrizione.fromJson(Map<String, dynamic> json) {
    return Iscrizione(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      studenteId: int.parse(json['studente_id'].toString()),
      corsoId: int.parse(json['corso_id'].toString()),
      dataIscrizione: json['data_iscrizione'],
      titoloCorso: json['titolo'],
      docente: json['docente'],
      nomeStudente: json['nome'],
      cognomeStudente: json['cognome'],
    );
  }
}