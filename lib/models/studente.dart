class Studente {
  final int? id;
  final String nome;
  final String cognome;
  final String email;
  final String dataNascita;

  Studente({
    this.id,
    required this.nome,
    required this.cognome,
    required this.email,
    required this.dataNascita,
  });

  factory Studente.fromJson(Map<String, dynamic> json) {
    return Studente(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      nome: json['nome'],
      cognome: json['cognome'],
      email: json['email'],
      dataNascita: json['data_nascita'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'cognome': cognome,
      'email': email,
      'data_nascita': dataNascita,
    };
  }
}