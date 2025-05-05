class Corso {
  final int? id;
  final String titolo;
  final String? descrizione;
  final String docente;
  final double prezzo;

  Corso({
    this.id,
    required this.titolo,
    this.descrizione,
    required this.docente,
    required this.prezzo,
  });

  factory Corso.fromJson(Map<String, dynamic> json) {
    return Corso(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      titolo: json['titolo'],
      descrizione: json['descrizione'],
      docente: json['docente'],
      prezzo: double.parse(json['prezzo'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titolo': titolo,
      if (descrizione != null) 'descrizione': descrizione,
      'docente': docente,
      'prezzo': prezzo,
    };
  }
}