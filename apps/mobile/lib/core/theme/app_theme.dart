import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const base = Color(0xFF143B2D);
    const accent = Color(0xFFE3A008);
    const canvas = Color(0xFFF4F1E8);
    const panel = Color(0xFFFFFCF5);
    const text = Color(0xFF182018);

    final scheme = ColorScheme.fromSeed(
      seedColor: base,
      brightness: Brightness.light,
      primary: base,
      secondary: accent,
      surface: panel,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: text,
          height: 1.05,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: text,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: text,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: panel,
        elevation: 0,
        indicatorColor: base.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: accent, width: 1.2),
        ),
      ),
    );
  }
}
