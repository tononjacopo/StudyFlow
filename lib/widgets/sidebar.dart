import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatelessWidget {
  final bool isSidebarExpanded;
  final int selectedIndex;
  final Function(int) onMenuItemSelected;
  final VoidCallback onToggleSidebar;

  const Sidebar({
    Key? key,
    required this.isSidebarExpanded,
    required this.selectedIndex,
    required this.onMenuItemSelected,
    required this.onToggleSidebar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: isSidebarExpanded ? 220 : 70,
      decoration: const BoxDecoration(
        color: Color(0xFF000080),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo/Admin header
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
              ),
            ),
            child: Row(
              children: [
                // Qui inserisci la tua immagine personalizzata
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Immagine logo (sostituisci con la tua)
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/logo-studyflow.png',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, obj, stack) => const Icon(
                        Icons.waves,
                        color: Color(0xFF000080),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                if (isSidebarExpanded) const SizedBox(width: 16),
                if (isSidebarExpanded)
                  Text(
                    'Admin',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  ),
              ],
            ),
          ),
          
          // Menu header
          Container(
            padding: EdgeInsets.only(
              left: 18,
              top: 20,
              bottom: 10,
              right: isSidebarExpanded ? 16 : 0,
            ),
            alignment: Alignment.centerLeft,
            child: isSidebarExpanded
                ? Text(
                    'MENU',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : const Divider(color: Colors.white24, height: 1),
          ),
          
          // Menu items
          _buildMenuItem(context, 0, Icons.home_rounded, 'Home'),
          _buildMenuItem(context, 1, Icons.person_rounded, 'Students'),
          _buildMenuItem(context, 2, Icons.book_rounded, 'Courses'),
          _buildMenuItem(context, 3, Icons.subscriptions_rounded, 'Subscriptions'),
          
          const Spacer(),
          
          // Toggle button
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToggleSidebar,
                child: Center(
                  child: AnimatedRotation(
                    turns: isSidebarExpanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, int index, IconData icon, String title) {
    final bool isSelected = selectedIndex == index;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isSelected 
            ? Colors.white.withOpacity(0.15) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onMenuItemSelected(index),
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 12, 
              horizontal: isSidebarExpanded ? 16 : 0,
            ),
            child: Row(
              mainAxisAlignment: isSidebarExpanded 
                  ? MainAxisAlignment.start 
                  : MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                  size: 22,
                ),
                if (isSidebarExpanded) const SizedBox(width: 14),
                if (isSidebarExpanded)
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}