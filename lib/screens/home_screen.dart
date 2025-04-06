// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),
      drawer: const MenuDrawer(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Study',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Where learning never stops'),
            SizedBox(height: 20),
            Text('Flow'),
          ],
        ),
      ),
    );
  }
}