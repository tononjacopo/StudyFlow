import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/responsive_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Parte sopra (Logo + Slogan)
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenSize.height * 0.05),
                        
                        // Logo Study + Immagine + Flow
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Testo "Study"
                                Text(
                                  'Study',
                                  style: GoogleFonts.poppins(
                                    fontSize: isMobile ? 40 : 68,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF000080),
                                  ),
                                ),

                                // Immagine centrale (grande senza spazio extra)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: isMobile ? 30 : 44),
                                  child: Transform.scale(
                                    scale: isMobile ? 5 : 5.8, // ingrandimento visivo
                                    child: SizedBox(
                                      width: isMobile ? 60 : 80,
                                      height: isMobile ? 30 : 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/logo-studyflow.png',
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  top: isMobile ? 10 : 20,
                                                  child: Container(
                                                    width: isMobile ? 50 : 80,
                                                    height: isMobile ? 5 : 8,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue[700],
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: isMobile ? 18 : 32,
                                                  child: Container(
                                                    width: isMobile ? 50 : 80,
                                                    height: isMobile ? 5 : 8,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue[500],
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: isMobile ? 26 : 44,
                                                  child: Container(
                                                    width: isMobile ? 50 : 80,
                                                    height: isMobile ? 5 : 8,
                                                    decoration: BoxDecoration(
                                                      color: Colors.lightBlue[300],
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Testo "Flow"
                                Text(
                                  'Flow',
                                  style: GoogleFonts.poppins(
                                    fontSize: isMobile ? 40 : 68,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF000080),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Slogan
                        Text(
                          'Where learning never stops',
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 22 : 28,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: screenSize.height * 0.1),
                      ],
                    ),
                  ),
                ),
              ),

              // Parte bassa (Crediti)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Developed by Tonon e Menegazzi',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
