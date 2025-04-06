// lib/models/student.dart
class Student {
  final int? id;
  final String name;
  final String surname;
  final String email;
  final DateTime dateOfBirth;

  Student({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.dateOfBirth,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['nome'],
      surname: json['cognome'],
      email: json['email'],
      dateOfBirth: DateTime.parse(json['data_nascita']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name,
      'cognome': surname,
      'email': email,
      'data_nascita': dateOfBirth.toIso8601String().split('T')[0],
    };
  }
}