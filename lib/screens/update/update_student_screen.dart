// lib/screens/update/update_student_screen.dart
import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../services/api_service.dart';

class UpdateStudentScreen extends StatefulWidget {
  const UpdateStudentScreen({super.key});

  @override
  _UpdateStudentScreenState createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  Student? _selectedStudent;
  bool _isLoading = true;
  bool _isEditing = false;

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _birthDate;

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
      _isEditing = true;
      _nameController.text = student.name;
      _surnameController.text = student.surname;
      _emailController.text = student.email;
      _birthDate = student.dateOfBirth;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate() && _birthDate != null && _selectedStudent != null) {
      final updatedStudent = Student(
        id: _selectedStudent!.id,
        name: _nameController.text,
        surname: _surnameController.text,
        email: _emailController.text,
        dateOfBirth: _birthDate!,
      );

      try {
        // Call your API update method here
        // await ApiService.updateStudent(updatedStudent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student updated successfully')),
        );
        setState(() {
          _isEditing = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            else if (!_isEditing)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = _filteredStudents[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text('${student.name} ${student.surname}'),
                      subtitle: Text(student.email),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _selectStudent(student),
                    ),
                  );
                },
              ),
            if (_isEditing && _selectedStudent != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Student Data',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _surnameController,
                        decoration: const InputDecoration(
                          labelText: 'Surname',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a surname';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _birthDate == null
                                    ? 'Select date'
                                    : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _selectedStudent = null;
                              });
                            },
                            child: const Text('Discard'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _updateStudent,
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}