import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  
  const ResponsiveLayout({
    Key? key, 
    required this.mobile, 
    required this.desktop,
  }) : super(key: key);
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 800;
  }

  @override
  Widget build(BuildContext context) {
    // Ritorna layout appropriato in base alla larghezza dello schermo
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return mobile;
        } else {
          return desktop;
        }
      },
    );
  }
}