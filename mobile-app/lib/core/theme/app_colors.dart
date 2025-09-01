import 'package:flutter/material.dart';

/// Application color scheme based on Material 3 design
class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  
  // Secondary Colors
  static const Color secondaryGreen = Color(0xFF10B981);
  static const Color secondaryGreenLight = Color(0xFF34D399);
  static const Color secondaryGreenDark = Color(0xFF059669);
  
  // Accent Colors
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentPurple = Color(0xFF8B5CF6);
  
  // Neutral Colors
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  
  // Common Colors
  static const Color primary = primaryBlue;
  static const Color background = Color(0xFFFAFAFA);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral600;
  static const Color border = neutral300;
  
  // Light Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryBlue,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFDBEAFE),
    onPrimaryContainer: Color(0xFF1E3A8A),
    secondary: secondaryGreen,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFD1FAE5),
    onSecondaryContainer: Color(0xFF064E3B),
    tertiary: accentOrange,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFEF3C7),
    onTertiaryContainer: Color(0xFF92400E),
    error: error,
    onError: Colors.white,
    errorContainer: errorLight,
    onErrorContainer: Color(0xFF7F1D1D),
    surface: Colors.white,
    onSurface: neutral900,
    surfaceContainerHighest: neutral100,
    onSurfaceVariant: neutral600,
    outline: neutral300,
    outlineVariant: neutral200,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: neutral800,
    onInverseSurface: neutral100,
    inversePrimary: Color(0xFF93C5FD),
  );
  
  // Dark Color Scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF93C5FD),
    onPrimary: Color(0xFF1E3A8A),
    primaryContainer: Color(0xFF1D4ED8),
    onPrimaryContainer: Color(0xFFDBEAFE),
    secondary: Color(0xFF6EE7B7),
    onSecondary: Color(0xFF064E3B),
    secondaryContainer: Color(0xFF059669),
    onSecondaryContainer: Color(0xFFD1FAE5),
    tertiary: Color(0xFFFBBF24),
    onTertiary: Color(0xFF92400E),
    tertiaryContainer: Color(0xFFD97706),
    onTertiaryContainer: Color(0xFFFEF3C7),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    errorContainer: Color(0xFFDC2626),
    onErrorContainer: Color(0xFFFEE2E2),
    surface: Color(0xFF111827),
    onSurface: neutral100,
    surfaceContainerHighest: neutral800,
    onSurfaceVariant: neutral400,
    outline: neutral600,
    outlineVariant: neutral700,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: neutral100,
    onInverseSurface: neutral800,
    inversePrimary: primaryBlue,
  );
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [secondaryGreen, secondaryGreenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [accentOrange, Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}