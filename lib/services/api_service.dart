// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';
import '../models/course.dart';
import '../models/enrollment.dart';

class ApiService {
  static const String baseUrl = 'http://your-java-service-url/api';

  // Student endpoints
  static Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((student) => Student.fromJson(student)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  static Future<Student> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse('$baseUrl/students'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    if (response.statusCode == 201) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create student');
    }
  }

  // Similar methods for update, delete, and other operations...
  // Course endpoints
  static Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  static Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toJson()),
    );
    if (response.statusCode == 201) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create course');
    }
  }

  // Enrollment endpoints
  static Future<List<Enrollment>> getEnrollments() async {
    final response = await http.get(Uri.parse('$baseUrl/enrollments'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((enrollment) => Enrollment.fromJson(enrollment)).toList();
    } else {
      throw Exception('Failed to load enrollments');
    }
  }

  static Future<Enrollment> createEnrollment(Enrollment enrollment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/enrollments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(enrollment.toJson()),
    );
    if (response.statusCode == 201) {
      return Enrollment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create enrollment');
    }
  }
}