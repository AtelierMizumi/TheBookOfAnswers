import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';

class AppTheme {
  // Sacred Palette
  static const Color voidColor = Color(0xFF0D0B0E);
  static const Color abyss = Color(0xFF141118);
  static const Color deep = Color(0xFF1C1824);
  static const Color stone = Color(0xFF2A2435);
  static const Color iron = Color(0xFF3D3650);
  static const Color ash = Color(0xFF5C5470);
  static const Color dust = Color(0xFF8B7FA8);
  static const Color parchment = Color(0xFFD4C5A0);
  static const Color bone = Color(0xFFE8DCC8);
  
  static const Color candlelight = Color(0xFFFFB347);
  static const Color ember = Color(0xFFE8833A);
  static const Color flame = Color(0xFFD4582A);
  static const Color gold = Color(0xFFC9A84C);
  static const Color blood = Color(0xFF8B2500);
  static const Color moss = Color(0xFF4A6741);
  static const Color ink = Color(0xFF1A1520);
  static const Color moonlight = Color(0xFFB8A9D4);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: voidColor,
      primaryColor: gold,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: candlelight,
        surface: deep,
        error: flame,
        onSurface: parchment,
      ),
      textTheme: TextTheme(
        // Use for UI elements
        bodyMedium: GoogleFonts.pressStart2p(color: parchment, fontSize: 10, height: 1.8),
        // Use for answer text
        bodyLarge: GoogleFonts.ebGaramond(color: bone, fontSize: 24, height: 1.7),
        // Use for Gothic Titles
        displayLarge: GoogleFonts.unifrakturMaguntia(color: bone, fontSize: 48, height: 1.2),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: gold,
        selectionColor: Color(0x40C9A84C),
        selectionHandleColor: gold,
      ),
    );
  }
}
