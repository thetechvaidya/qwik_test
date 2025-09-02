import 'package:equatable/equatable.dart';
import 'offline_preferences.dart';

enum ThemeMode {
  light,
  dark,
  system,
}

class AppPreferences extends Equatable {
  const AppPreferences({
    this.theme = 'system',
    this.language = 'en',
    this.timezone = 'UTC',
    this.offlineSettings = const OfflinePreferences(),
    this.fontSize = 'medium',
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.autoLockEnabled = false,
    this.autoLockTimeout = 300, // 5 minutes in seconds
    this.showHints = true,
    this.animationsEnabled = true,
  });

  final String theme;
  final String language;
  final String timezone;
  final OfflinePreferences offlineSettings;
  final String fontSize;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool autoLockEnabled;
  final int autoLockTimeout;
  final bool showHints;
  final bool animationsEnabled;

  @override
  List<Object?> get props => [
        theme,
        language,
        timezone,
        offlineSettings,
        fontSize,
        soundEnabled,
        vibrationEnabled,
        autoLockEnabled,
        autoLockTimeout,
        showHints,
        animationsEnabled,
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

  /// Gets font size multiplier
  double getFontSizeMultiplier() {
    switch (fontSize.toLowerCase()) {
      case 'small':
        return 0.85;
      case 'large':
        return 1.15;
      case 'extra_large':
        return 1.3;
      case 'medium':
      default:
        return 1.0;
    }
  }

  /// Gets available font size options
  static List<String> getFontSizeOptions() {
    return ['small', 'medium', 'large', 'extra_large'];
  }

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

  /// Gets auto-lock timeout in minutes
  int getAutoLockTimeoutMinutes() {
    return (autoLockTimeout / 60).round();
  }

  /// Checks if accessibility features are enabled
  bool hasAccessibilityFeatures() {
    return fontSize != 'medium' || !animationsEnabled;
  }

  AppPreferences copyWith({
    String? theme,
    String? language,
    String? timezone,
    OfflinePreferences? offlineSettings,
    String? fontSize,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? autoLockEnabled,
    int? autoLockTimeout,
    bool? showHints,
    bool? animationsEnabled,
  }) {
    return AppPreferences(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      offlineSettings: offlineSettings ?? this.offlineSettings,
      fontSize: fontSize ?? this.fontSize,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      autoLockEnabled: autoLockEnabled ?? this.autoLockEnabled,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      showHints: showHints ?? this.showHints,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }

  @override
  String toString() {
    return 'AppPreferences(theme: $theme, language: $language, timezone: $timezone, offlineSettings: $offlineSettings, fontSize: $fontSize, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, autoLockEnabled: $autoLockEnabled, autoLockTimeout: $autoLockTimeout, showHints: $showHints, animationsEnabled: $animationsEnabled)';
  }
}