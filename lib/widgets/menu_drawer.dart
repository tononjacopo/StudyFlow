// lib/widgets/menu_drawer.dart
import 'package:flutter/material.dart';
import '../../screens/read/read_student_screen.dart';
import '../../screens/update/update_student_screen.dart';
import '../../screens/delete/delete_student_screen.dart';
import '../../screens/update/update_course_screen.dart';
import '../../screens/delete/delete_course_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.edit),
            title: const Text('Update'),
            children: [
              ListTile(
                title: const Text('Edit Student'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdateStudentScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Edit Course'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdateCourseScreen()),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            children: [
              ListTile(
                title: const Text('Delete Student'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeleteStudentScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Delete Course'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeleteCourseScreen()),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Read'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReadStudentScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Update'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateStudentScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeleteStudentScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}