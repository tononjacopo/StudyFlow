// lib/screens/delete/delete_student_screen.dart
import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../services/api_service.dart';

class DeleteStudentScreen extends StatefulWidget {
  const DeleteStudentScreen({super.key});

  @override
  _DeleteStudentScreenState createState() => _DeleteStudentScreenState();
}

class _DeleteStudentScreenState extends State<DeleteStudentScreen> {
  final _searchController = TextEditingController();
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  Student? _selectedStudent;
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

  void _selectStudent(Student student) {
    setState(() {
      _selectedStudent = student;
    });
  }

  Future<void> _deleteStudent() async {
    if (_selectedStudent != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete ${_selectedStudent!.name} ${_selectedStudent!.surname}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        try {
          // Call your API delete method here
          // await ApiService.deleteStudent(_selectedStudent!.id!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student deleted successfully')),
          );
          setState(() {
            _selectedStudent = null;
          });
          _loadStudents(); // Refresh the list
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Student'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Research Student',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
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
              ],
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_filteredStudents.isEmpty)
            const Center(child: Text('No students found'))
          else
            Expanded(
              child: ListView.builder(
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
                      trailing: const Icon(Icons.delete),
                      onTap: () => _selectStudent(student),
                    ),
                  );
                },
              ),
            ),
          if (_selectedStudent != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text('Name: ${_selectedStudent!.name}'),
                  const SizedBox(height: 8),
                  Text('Surname: ${_selectedStudent!.surname}'),
                  const SizedBox(height: 8),
                  Text('Email: ${_selectedStudent!.email}'),
                  const SizedBox(height: 8),
                  Text(
                      'Date of Birth: ${_selectedStudent!.dateOfBirth.toLocal().toString().split(' ')[0]}'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedStudent = null;
                          });
                        },
                        child: const Text('Discard'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _deleteStudent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}