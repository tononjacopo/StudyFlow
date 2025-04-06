// lib/screens/read/read_course_screen.dart
import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/api_service.dart';

class ReadCourseScreen extends StatefulWidget {
  const ReadCourseScreen({super.key});

  @override
  _ReadCourseScreenState createState() => _ReadCourseScreenState();
}

class _ReadCourseScreenState extends State<ReadCourseScreen> {
  final _searchController = TextEditingController();
  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Course'),
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
                    _filterCourses('');
                  },
                ),
              ),
              onChanged: _filterCourses,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCourses.isEmpty
                    ? const Center(child: Text('No courses found'))
                    : ListView.builder(
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
                                  Text('Description: ${course.description}'),
                                  Text('Teacher: ${course.teacher}'),
                                  Text('Price: \$${course.price.toStringAsFixed(2)}'),
                                ],
                              ),
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