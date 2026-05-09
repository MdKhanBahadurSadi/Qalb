import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle get _basePoppins => GoogleFonts.poppins();
  static TextStyle get _baseArabic => GoogleFonts.notoNaskhArabic();

  static TextTheme getTextTheme() {
    return TextTheme(
      displayLarge: _basePoppins.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: _basePoppins.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: _basePoppins.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: _basePoppins.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: _basePoppins.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: _basePoppins.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: _basePoppins.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: _basePoppins.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: _basePoppins.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static TextStyle arabicStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return _baseArabic.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
