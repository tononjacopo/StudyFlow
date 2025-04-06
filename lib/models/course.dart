// lib/models/course.dart
class Course {
  final int? id;
  final String title;
  final String description;
  final String teacher;
  final double price;

  Course({
    this.id,
    required this.title,
    required this.description,
    required this.teacher,
    required this.price,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['titolo'],
      description: json['descrizione'],
      teacher: json['docente'],
      price: json['prezzo'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titolo': title,
      'descrizione': description,
      'docente': teacher,
      'prezzo': price,
    };
  }
}