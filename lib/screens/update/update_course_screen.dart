// lib/screens/update/update_course_screen.dart
import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/api_service.dart';

class UpdateCourseScreen extends StatefulWidget {
  const UpdateCourseScreen({super.key});

  @override
  _UpdateCourseScreenState createState() => _UpdateCourseScreenState();
}

class _UpdateCourseScreenState extends State<UpdateCourseScreen> {
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  Course? _selectedCourse;
  bool _isLoading = true;
  bool _isEditing = false;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _teacherController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await ApiService.getCourses();
      setState(() {
        _courses = courses;
        _filteredCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading courses: $e')),
      );
    }
  }

  void _filterCourses(String query) {
    setState(() {
      _filteredCourses = _courses.where((course) {
        final title = course.title.toLowerCase();
        final teacher = course.teacher.toLowerCase();
        final searchLower = query.toLowerCase();
        return title.contains(searchLower) ||
            teacher.contains(searchLower) ||
            course.id.toString().contains(query);
      }).toList();
    });
  }

  void _selectCourse(Course course) {
    setState(() {
      _selectedCourse = course;
      _isEditing = true;
      _titleController.text = course.title;
      _descriptionController.text = course.description;
      _teacherController.text = course.teacher;
      _priceController.text = course.price.toString();
    });
  }

  Future<void> _updateCourse() async {
    if (_formKey.currentState!.validate() && _selectedCourse != null) {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      if (price < 50) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Price cannot be less than \$50')),
        );
        return;
      }

      final updatedCourse = Course(
        id: _selectedCourse!.id,
        title: _titleController.text,
        description: _descriptionController.text,
        teacher: _teacherController.text,
        price: price,
      );

      try {
        // Call your API update method here
        // await ApiService.updateCourse(updatedCourse);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course updated successfully')),
        );
        setState(() {
          _isEditing = false;
          _selectedCourse = null;
        });
        _loadCourses(); // Refresh the list
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
        title: const Text('Edit Course'),
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
                    'Research Course',
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
                          _filterCourses('');
                        },
                      ),
                    ),
                    onChanged: _filterCourses,
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_filteredCourses.isEmpty)
              const Center(child: Text('No courses found'))
            else if (!_isEditing)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = _filteredCourses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(course.title),
                      subtitle: Text('Taught by ${course.teacher} - \$${course.price}'),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _selectCourse(course),
                    ),
                  );
                },
              ),
            if (_isEditing && _selectedCourse != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Course Data',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _teacherController,
                        decoration: const InputDecoration(
                          labelText: 'Teacher',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a teacher name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price \$',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) < 50) {
                            return 'Price must be at least \$50';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _selectedCourse = null;
                              });
                            },
                            child: const Text('Discard'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _updateCourse,
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