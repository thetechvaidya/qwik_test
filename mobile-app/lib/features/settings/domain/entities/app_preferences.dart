import 'package:equatable/equatable.dart';
// Removed unused import: offline_preferences.dart

enum ThemeMode {
  light,
  dark,
  system,
}

class AppPreferences extends Equatable {
  const AppPreferences({
    this.theme = 'system',
    this.language = 'en',
  });

  final String theme;
  final String language;
  // Removed unused fields: timezone, offlineSettings, fontSize, soundEnabled, 
  // vibrationEnabled, autoLockEnabled, autoLockTimeout, showHints, animationsEnabled

  @override
  List<Object?> get props => [
        theme,
        language,
      ];

  /// Gets the theme mode enum from string
  ThemeMode getThemeMode() {
    switch (theme.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Checks if dark theme is active
  bool isDarkTheme() {
    return theme.toLowerCase() == 'dark';
  }

  /// Checks if system theme is being used
  bool isSystemTheme() {
    return theme.toLowerCase() == 'system';
  }

  // Removed font size methods - not used in simplified UI

  /// Gets available theme options
  static List<String> getThemeOptions() {
    return ['light', 'dark', 'system'];
  }

  /// Gets available language options
  static List<Map<String, String>> getLanguageOptions() {
    return [
      {'code': 'en', 'name': 'English'},
      {'code': 'es', 'name': 'Español'},
      {'code': 'fr', 'name': 'Français'},
      {'code': 'de', 'name': 'Deutsch'},
      {'code': 'it', 'name': 'Italiano'},
      {'code': 'pt', 'name': 'Português'},
      {'code': 'ru', 'name': 'Русский'},
      {'code': 'zh', 'name': '中文'},
      {'code': 'ja', 'name': '日本語'},
      {'code': 'ko', 'name': '한국어'},
    ];
  }

  /// Gets language display name
  String getLanguageDisplayName() {
    final languages = getLanguageOptions();
    final lang = languages.firstWhere(
      (l) => l['code'] == language,
      orElse: () => {'code': 'en', 'name': 'English'},
    );
    return lang['name'] ?? 'English';
  }

  // Removed auto-lock and accessibility methods - not used in simplified UI

  AppPreferences copyWith({
    String? theme,
    String? language,
  }) {
    return AppPreferences(
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }

  @override
  String toString() {
    return 'AppPreferences(theme: $theme, language: $language)';
  }
}