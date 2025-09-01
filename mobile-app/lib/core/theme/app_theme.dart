import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Application theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      fontFamily: 'Inter',
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightColorScheme.surface,
        foregroundColor: AppColors.lightColorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.lightColorScheme.onSurface,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.lightColorScheme.surface,
        elevation: 2,
        shadowColor: AppColors.lightColorScheme.shadow.withAlpha(25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightColorScheme.primary,
          foregroundColor: AppColors.lightColorScheme.onPrimary,
          elevation: 2,
          shadowColor: AppColors.lightColorScheme.primary.withAlpha(76),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightColorScheme.primary,
          side: BorderSide(
            color: AppColors.lightColorScheme.outline,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightColorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightColorScheme.surface,
        selectedItemColor: AppColors.lightColorScheme.primary,
        unselectedItemColor: AppColors.lightColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),
      
      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightColorScheme.surface,
        indicatorColor: AppColors.lightColorScheme.secondaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        surfaceTintColor: AppColors.lightColorScheme.surfaceTint,
        elevation: 3,
        shadowColor: AppColors.lightColorScheme.shadow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall.copyWith(
              color: AppColors.lightColorScheme.onSecondaryContainer,
            );
          }
          return AppTextStyles.labelSmall.copyWith(
            color: AppColors.lightColorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: AppColors.lightColorScheme.onSecondaryContainer,
              size: 24,
            );
          }
          return IconThemeData(
            color: AppColors.lightColorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      
      // Navigation Rail Theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.lightColorScheme.surface,
        indicatorColor: AppColors.lightColorScheme.secondaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        labelType: NavigationRailLabelType.all,
        selectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.lightColorScheme.onSecondaryContainer,
        ),
        unselectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.lightColorScheme.onSurfaceVariant,
        ),
        selectedIconTheme: IconThemeData(
          color: AppColors.lightColorScheme.onSecondaryContainer,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppColors.lightColorScheme.onSurfaceVariant,
          size: 24,
        ),
      )
      
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.lightColorScheme.primary,
        linearTrackColor: AppColors.lightColorScheme.surfaceContainerHighest,
        circularTrackColor: AppColors.lightColorScheme.surfaceContainerHighest,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.lightColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkColorScheme.surface,
        selectedItemColor: AppColors.darkColorScheme.primary,
        unselectedItemColor: AppColors.darkColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),
      
      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkColorScheme.surface,
        indicatorColor: AppColors.darkColorScheme.secondaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        surfaceTintColor: AppColors.darkColorScheme.surfaceTint,
        elevation: 3,
        shadowColor: AppColors.darkColorScheme.shadow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall.copyWith(
              color: AppColors.darkColorScheme.onSecondaryContainer,
            );
          }
          return AppTextStyles.labelSmall.copyWith(
            color: AppColors.darkColorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: AppColors.darkColorScheme.onSecondaryContainer,
              size: 24,
            );
          }
          return IconThemeData(
            color: AppColors.darkColorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      
      // Navigation Rail Theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.darkColorScheme.surface,
        indicatorColor: AppColors.darkColorScheme.secondaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        labelType: NavigationRailLabelType.all,
        selectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.darkColorScheme.onSecondaryContainer,
        ),
        unselectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.darkColorScheme.onSurfaceVariant,
        ),
        selectedIconTheme: IconThemeData(
          color: AppColors.darkColorScheme.onSecondaryContainer,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppColors.darkColorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.darkColorScheme.primary,
        linearTrackColor: AppColors.darkColorScheme.surfaceContainerHighest,
        circularTrackColor: AppColors.darkColorScheme.surfaceContainerHighest,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.darkColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      fontFamily: 'Inter',
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkColorScheme.surface,
        foregroundColor: AppColors.darkColorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.darkColorScheme.surface,
        elevation: 2,
        shadowColor: AppColors.darkColorScheme.shadow.withAlpha(76),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkColorScheme.primary,
          foregroundColor: AppColors.darkColorScheme.onPrimary,
          elevation: 2,
          shadowColor: AppColors.darkColorScheme.primary.withAlpha(76),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.darkColorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.darkColorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.darkColorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkColorScheme.onSurfaceVariant,
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
      ),
    );
  }
}