// lib/screens/read/read_student_screen.dart
import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../services/api_service.dart';

class ReadStudentScreen extends StatefulWidget {
  const ReadStudentScreen({super.key});

  @override
  _ReadStudentScreenState createState() => _ReadStudentScreenState();
}

class _ReadStudentScreenState extends State<ReadStudentScreen> {
  final _searchController = TextEditingController();
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final students = await ApiService.getStudents();
      setState(() {
        _students = students;
        _filteredStudents = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading students: $e')),
      );
    }
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _students.where((student) {
        final name = student.name.toLowerCase();
        final surname = student.surname.toLowerCase();
        final email = student.email.toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) ||
            surname.contains(searchLower) ||
            email.contains(searchLower) ||
            student.id.toString().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Student'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterStudents('');
                  },
                ),
              ),
              onChanged: _filterStudents,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredStudents.isEmpty
                    ? const Center(child: Text('No students found'))
                    : ListView.builder(
                        itemCount: _filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = _filteredStudents[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text('${student.name} ${student.surname}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email: ${student.email}'),
                                  Text(
                                      'Date of Birth: ${student.dateOfBirth.toLocal().toString().split(' ')[0]}'),
                                ],
                              ),
                              trailing: Text('ID: ${student.id}'),
                            ),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Discard'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}