import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryIndigo = Color(0xFF1A237E);
  static const Color accentBlue = Color(0xFF3F51B5);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color errorRed = Color(0xFFD32F2F);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryIndigo,
        primary: primaryIndigo,
        secondary: accentBlue,
        error: errorRed,
        surface: backgroundColor, // Reemplazado 'background' por 'surface'
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryIndigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        // Cambiado de CardTheme a CardThemeData
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
