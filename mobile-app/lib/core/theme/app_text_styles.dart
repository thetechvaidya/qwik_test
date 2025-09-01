import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Base font family
  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  // Display styles
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      );

  static TextStyle get displaySmall => GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      );

  // Headline styles
  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
      );

  // Title styles
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.50,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // Label styles
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );

  // Body styles
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  // Custom app-specific styles
  static TextStyle get examTitle => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.30,
      );

  static TextStyle get questionText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      );

  static TextStyle get answerText => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get timerText => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
      );

  static TextStyle get scoreText => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.25,
      );

  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get captionText => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  static TextStyle get overlineText => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        height: 1.60,
      );

  // Helper method to get TextTheme
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
      );
}