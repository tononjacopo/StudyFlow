import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/responsive_layout.dart';
import 'home_page.dart';
import 'studenti_page.dart';
import 'corsi_page.dart';
import 'iscrizioni_page.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({Key? key}) : super(key: key);

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  bool _isSidebarExpanded = true;
  int _selectedIndex = 0;
  
  // Dati per il contenuto dinamico
  int? _selectedStudentId;
  String? _selectedStudentName;
  int? _selectedCourseId;
  String? _selectedCourseName;
  
  // Gestori di navigazione
  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }
  
  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      // Reset delle selezioni quando si cambia sezione
      if (index != 3) { // 3 è l'indice per Subscriptions
        _clearSelections();
      }
    });
  }

  void _clearSelections() {
    setState(() {
      _selectedStudentId = null;
      _selectedStudentName = null;
      _selectedCourseId = null;
      _selectedCourseName = null;
    });
  }
  
  void _selectStudent(int id, String name) {
    setState(() {
      _selectedStudentId = id;
      _selectedStudentName = name;
      _selectedCourseId = null;
      _selectedCourseName = null;
    });
  }
  
  void _selectCourse(int id, String name) {
    setState(() {
      _selectedCourseId = id;
      _selectedCourseName = name;
      _selectedStudentId = null;
      _selectedStudentName = null;
    });
  }
  
  // Selettore di contenuto basato su stato
  Widget _getContent() {
    switch (_selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const StudentiPage();
      case 2:
        return const CorsiPage();
      case 3:
        if (_selectedStudentId != null) {
          return IscrizioniPage(
            studenteId: _selectedStudentId,
            titolo: "Corsi di $_selectedStudentName",
            onBack: _clearSelections,
          );
        } else if (_selectedCourseId != null) {
          return IscrizioniPage(
            corsoId: _selectedCourseId,
            titolo: "Studenti iscritti a $_selectedCourseName",
            onBack: _clearSelections,
          );
        } else {
          return IscrizioniPage(
            onSelectStudent: _selectStudent,
            onSelectCourse: _selectCourse,
          );
        }
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: Column(
          children: [
            // Header per mobile
            Container(
              color: const Color(0xFF000080),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: _toggleSidebar,
                  ),
                  const Expanded(
                    child: Text(
                      'Study Flow',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Content per mobile
            Expanded(
              child: Stack(
                children: [
                  _getContent(),
                  if (_isSidebarExpanded)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: Row(
                          children: [
                            Sidebar(
                              isSidebarExpanded: true,
                              selectedIndex: _selectedIndex,
                              onMenuItemSelected: (index) {
                                _onMenuItemSelected(index);
                                setState(() {
                                  _isSidebarExpanded = false;
                                });
                              },
                              onToggleSidebar: _toggleSidebar,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSidebarExpanded = false;
                                  });
                                },
                                child: Container(color: Colors.transparent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            // Sidebar per desktop
            Sidebar(
              isSidebarExpanded: _isSidebarExpanded,
              selectedIndex: _selectedIndex,
              onMenuItemSelected: _onMenuItemSelected,
              onToggleSidebar: _toggleSidebar,
            ),
            
            // Area contenuto principale
            Expanded(
              child: _getContent(),
            ),
          ],
        ),
      ),
    );
  }
}