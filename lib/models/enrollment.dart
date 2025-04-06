// lib/models/enrollment.dart
class Enrollment {
  final int id;
  final int studentId;
  final int courseId;
  final DateTime enrollmentDate;

  Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.enrollmentDate,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'],
      studentId: json['studente_id'],
      courseId: json['corso_id'],
      enrollmentDate: DateTime.parse(json['data_iscrizione']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studente_id': studentId,
      'corso_id': courseId,
      'data_iscrizione': enrollmentDate.toIso8601String().split('T')[0],
    };
  }
}