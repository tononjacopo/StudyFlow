// lib/screens/delete/delete_course_screen.dart
import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/api_service.dart';

class DeleteCourseScreen extends StatefulWidget {
  const DeleteCourseScreen({super.key});

  @override
  _DeleteCourseScreenState createState() => _DeleteCourseScreenState();
}

class _DeleteCourseScreenState extends State<DeleteCourseScreen> {
  final _searchController = TextEditingController();
  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  Course? _selectedCourse;
  bool _isLoading = true;

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
    });
  }

  Future<void> _deleteCourse() async {
    if (_selectedCourse != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete the course "${_selectedCourse!.title}"?'),
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
          // await ApiService.deleteCourse(_selectedCourse!.id!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course deleted successfully')),
          );
          setState(() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Course'),
      ),
      body: Column(
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
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = _filteredCourses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(course.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Teacher: ${course.teacher}'),
                          Text('Price: \$${course.price.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: const Icon(Icons.delete),
                      onTap: () => _selectCourse(course),
                    ),
                  );
                },
              ),
            ),
          if (_selectedCourse != null)
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
                  Text('Title: ${_selectedCourse!.title}'),
                  const SizedBox(height: 8),
                  Text('Description: ${_selectedCourse!.description}'),
                  const SizedBox(height: 8),
                  Text('Teacher: ${_selectedCourse!.teacher}'),
                  const SizedBox(height: 8),
                  Text('Price: \$${_selectedCourse!.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCourse = null;
                          });
                        },
                        child: const Text('Discard'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _deleteCourse,
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