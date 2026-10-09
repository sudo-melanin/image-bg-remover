import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B0E17);
  static const Color surfaceCard = Color(0xFF131728);
  static const Color surfaceElevated = Color(0xFF1C2237);
  static const Color surfaceBorder = Color(0xFF262E49);

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryPurple = Color(0xFF7C3AED);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static final BorderRadius radiusSmall = BorderRadius.circular(10);
  static final BorderRadius radiusMedium = BorderRadius.circular(16);
  static final BorderRadius radiusLarge = BorderRadius.circular(24);

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        surface: surfaceCard,
      ),
      appBarTheme: const AppBarTheme(backgroundColor: background, elevation: 0),
    );
  }
}
