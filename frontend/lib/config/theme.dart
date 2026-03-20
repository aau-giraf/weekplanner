import 'package:flutter/material.dart';

class GirafColors {
  static const Color orange = Color(0xFFFF8C00);
  static const Color lighterOrange = Color(0xFFFFD494);
  static const Color black = Color(0xFF1A1A1A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFF808080);
  static const Color lightGray = Color(0xFFF0F0F0);
  static const Color blue = Color(0xFF006EB8);
  static const Color lightBlue = Color(0xFFE0F4FF);
  static const Color green = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFFE5F5E5);
  static const Color red = Color(0xFFFF0000);
  static const Color lightRed = Color(0xFFFFE5E5);
}

final ThemeData girafTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: GirafColors.orange,
    primary: GirafColors.orange,
    onPrimary: GirafColors.white,
    surface: GirafColors.white,
    error: GirafColors.red,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: GirafColors.orange,
    foregroundColor: GirafColors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: GirafColors.orange,
      foregroundColor: GirafColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: GirafColors.orange, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  useMaterial3: true,
);
