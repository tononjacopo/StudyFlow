import 'package:flutter/material.dart';
import 'screens/dashboard_layout.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF000080),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF000080),
          primary: const Color(0xFF000080),
          secondary: const Color(0xFF2196F3),
        ),
        // Utilizzo di Google Fonts per migliorare la tipografia
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DashboardLayout(),
    );
  }
}