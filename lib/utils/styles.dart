import 'package:flutter/material.dart';

// Color scheme based on Tailwind config
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF3A86FF);
  static const Color secondary = Color(0xFF8338EC);
  static const Color accent = Color(0xFFFF006E);
  static const Color text = Color(0xFF333333);
  
  // System colors
  static const Color background = Colors.white;
  static const Color foreground = Color(0xFF333333);
  static const Color muted = Color(0xFFE5E5E5);
  static const Color mutedForeground = Color(0xFF6B7280);
  static const Color border = Color(0xFFE2E8F0);
  static const Color input = Color(0xFFE2E8F0);
  static const Color card = Colors.white;
  static const Color cardForeground = Color(0xFF333333);
  static const Color destructive = Color(0xFFEF4444);
  static const Color destructiveForeground = Colors.white;
}

// Border radius values
class AppRadius {
  static const double sm = 4.0;
  static const double md = 6.0;
  static const double lg = 8.0;
}

// Theme data
ThemeData getAppTheme() {
  return ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      error: AppColors.destructive,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.foreground,
      onError: AppColors.destructiveForeground,
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.text),
      bodyMedium: TextStyle(color: AppColors.text),
    ),
    fontFamily: 'Inter',
    cardTheme: const CardTheme(
      color: AppColors.card,
      elevation: 2,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.input,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
  );
}