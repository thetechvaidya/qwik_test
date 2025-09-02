import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/app_preferences.dart';
import 'offline_preferences_model.dart';

part 'app_preferences_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 4)
class AppPreferencesModel extends AppPreferences {
  const AppPreferencesModel({
    @HiveField(0) super.themeMode = ThemeMode.system,
    @HiveField(1) super.language = 'en',
    @HiveField(2) super.timezone = 'UTC',
    @HiveField(3) super.fontSize = FontSize.medium,
    @HiveField(4) super.soundEnabled = true,
    @HiveField(5) super.vibrationEnabled = true,
    @HiveField(6) super.animationsEnabled = true,
    @HiveField(7) super.autoLockEnabled = false,
    @HiveField(8) super.autoLockTimeout = AutoLockTimeout.fiveMinutes,
    @HiveField(9) super.biometricEnabled = false,
    @HiveField(10) super.crashReportingEnabled = true,
    @HiveField(11) super.analyticsEnabled = true,
    @HiveField(12) super.performanceMonitoringEnabled = true,
    @HiveField(13) super.highContrastMode = false,
    @HiveField(14) super.reduceMotion = false,
    @HiveField(15) super.screenReaderSupport = false,
    @HiveField(16) super.offlinePreferences = const OfflinePreferencesModel(),
  });

  factory AppPreferencesModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$AppPreferencesModelFromJson(json);
    } catch (e) {
      // Handle malformed JSON by providing fallback values
      return AppPreferencesModel(
        themeMode: _parseThemeMode(json['theme_mode'] ?? json['themeMode']),
        language: json['language']?.toString() ?? 'en',
        timezone: json['timezone']?.toString() ?? 'UTC',
        fontSize: _parseFontSize(json['font_size'] ?? json['fontSize']),
        soundEnabled: _parseBool(json['sound_enabled'] ?? json['soundEnabled']),
        vibrationEnabled: _parseBool(json['vibration_enabled'] ?? json['vibrationEnabled']),
        animationsEnabled: _parseBool(json['animations_enabled'] ?? json['animationsEnabled']),
        autoLockEnabled: _parseBool(json['auto_lock_enabled'] ?? json['autoLockEnabled'], defaultValue: false),
        autoLockTimeout: _parseAutoLockTimeout(json['auto_lock_timeout'] ?? json['autoLockTimeout']),
        biometricEnabled: _parseBool(json['biometric_enabled'] ?? json['biometricEnabled'], defaultValue: false),
        crashReportingEnabled: _parseBool(json['crash_reporting_enabled'] ?? json['crashReportingEnabled']),
        analyticsEnabled: _parseBool(json['analytics_enabled'] ?? json['analyticsEnabled']),
        performanceMonitoringEnabled: _parseBool(json['performance_monitoring_enabled'] ?? json['performanceMonitoringEnabled']),
        highContrastMode: _parseBool(json['high_contrast_mode'] ?? json['highContrastMode'], defaultValue: false),
        reduceMotion: _parseBool(json['reduce_motion'] ?? json['reduceMotion'], defaultValue: false),
        screenReaderSupport: _parseBool(json['screen_reader_support'] ?? json['screenReaderSupport'], defaultValue: false),
        offlinePreferences: _parseOfflinePreferences(json['offline_preferences'] ?? json['offlinePreferences']),
      );
    }
  }

  Map<String, dynamic> toJson() => _$AppPreferencesModelToJson(this);

  factory AppPreferencesModel.fromEntity(AppPreferences preferences) {
    return AppPreferencesModel(
      themeMode: preferences.themeMode,
      language: preferences.language,
      timezone: preferences.timezone,
      fontSize: preferences.fontSize,
      soundEnabled: preferences.soundEnabled,
      vibrationEnabled: preferences.vibrationEnabled,
      animationsEnabled: preferences.animationsEnabled,
      autoLockEnabled: preferences.autoLockEnabled,
      autoLockTimeout: preferences.autoLockTimeout,
      biometricEnabled: preferences.biometricEnabled,
      crashReportingEnabled: preferences.crashReportingEnabled,
      analyticsEnabled: preferences.analyticsEnabled,
      performanceMonitoringEnabled: preferences.performanceMonitoringEnabled,
      highContrastMode: preferences.highContrastMode,
      reduceMotion: preferences.reduceMotion,
      screenReaderSupport: preferences.screenReaderSupport,
      offlinePreferences: preferences.offlinePreferences is OfflinePreferencesModel
          ? preferences.offlinePreferences as OfflinePreferencesModel
          : OfflinePreferencesModel.fromEntity(preferences.offlinePreferences),
    );
  }

  AppPreferences toEntity() {
    return AppPreferences(
      themeMode: themeMode,
      language: language,
      timezone: timezone,
      fontSize: fontSize,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      animationsEnabled: animationsEnabled,
      autoLockEnabled: autoLockEnabled,
      autoLockTimeout: autoLockTimeout,
      biometricEnabled: biometricEnabled,
      crashReportingEnabled: crashReportingEnabled,
      analyticsEnabled: analyticsEnabled,
      performanceMonitoringEnabled: performanceMonitoringEnabled,
      highContrastMode: highContrastMode,
      reduceMotion: reduceMotion,
      screenReaderSupport: screenReaderSupport,
      offlinePreferences: offlinePreferences,
    );
  }

  /// Helper method to parse ThemeMode
  static ThemeMode _parseThemeMode(dynamic value) {
    if (value == null) return ThemeMode.system;
    
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
        default:
          return ThemeMode.system;
      }
    }
    
    if (value is int) {
      switch (value) {
        case 0:
          return ThemeMode.system;
        case 1:
          return ThemeMode.light;
        case 2:
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    }
    
    return ThemeMode.system;
  }

  /// Helper method to parse FontSize
  static FontSize _parseFontSize(dynamic value) {
    if (value == null) return FontSize.medium;
    
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'small':
          return FontSize.small;
        case 'medium':
        case 'normal':
          return FontSize.medium;
        case 'large':
          return FontSize.large;
        case 'extra_large':
        case 'extralarge':
        case 'xl':
          return FontSize.extraLarge;
        default:
          return FontSize.medium;
      }
    }
    
    if (value is int) {
      switch (value) {
        case 0:
          return FontSize.small;
        case 1:
          return FontSize.medium;
        case 2:
          return FontSize.large;
        case 3:
          return FontSize.extraLarge;
        default:
          return FontSize.medium;
      }
    }
    
    return FontSize.medium;
  }

  /// Helper method to parse AutoLockTimeout
  static AutoLockTimeout _parseAutoLockTimeout(dynamic value) {
    if (value == null) return AutoLockTimeout.fiveMinutes;
    
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'never':
          return AutoLockTimeout.never;
        case 'one_minute':
        case 'oneminute':
        case '1min':
          return AutoLockTimeout.oneMinute;
        case 'five_minutes':
        case 'fiveminutes':
        case '5min':
          return AutoLockTimeout.fiveMinutes;
        case 'fifteen_minutes':
        case 'fifteenminutes':
        case '15min':
          return AutoLockTimeout.fifteenMinutes;
        case 'thirty_minutes':
        case 'thirtyminutes':
        case '30min':
          return AutoLockTimeout.thirtyMinutes;
        case 'one_hour':
        case 'onehour':
        case '1hour':
          return AutoLockTimeout.oneHour;
        default:
          return AutoLockTimeout.fiveMinutes;
      }
    }
    
    if (value is int) {
      switch (value) {
        case 0:
          return AutoLockTimeout.never;
        case 60:
          return AutoLockTimeout.oneMinute;
        case 300:
          return AutoLockTimeout.fiveMinutes;
        case 900:
          return AutoLockTimeout.fifteenMinutes;
        case 1800:
          return AutoLockTimeout.thirtyMinutes;
        case 3600:
          return AutoLockTimeout.oneHour;
        default:
          return AutoLockTimeout.fiveMinutes;
      }
    }
    
    return AutoLockTimeout.fiveMinutes;
  }

  /// Helper method to parse boolean values
  static bool _parseBool(dynamic value, {bool defaultValue = true}) {
    if (value == null) return defaultValue;
    
    if (value is bool) return value;
    
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    
    if (value is int) {
      return value == 1;
    }
    
    return defaultValue;
  }

  /// Helper method to parse offline preferences
  static OfflinePreferencesModel _parseOfflinePreferences(dynamic value) {
    if (value == null) return const OfflinePreferencesModel();
    
    if (value is Map<String, dynamic>) {
      return OfflinePreferencesModel.fromJson(value);
    }
    
    return const OfflinePreferencesModel();
  }

  /// Create preferences optimized for performance
  factory AppPreferencesModel.performanceOptimized() {
    return const AppPreferencesModel(
      themeMode: ThemeMode.system,
      language: 'en',
      fontSize: FontSize.medium,
      soundEnabled: false,
      vibrationEnabled: false,
      animationsEnabled: false,
      autoLockEnabled: true,
      autoLockTimeout: AutoLockTimeout.fiveMinutes,
      biometricEnabled: false,
      crashReportingEnabled: false,
      analyticsEnabled: false,
      performanceMonitoringEnabled: false,
      highContrastMode: false,
      reduceMotion: true,
      screenReaderSupport: false,
    );
  }

  /// Create preferences optimized for accessibility
  factory AppPreferencesModel.accessibilityOptimized() {
    return const AppPreferencesModel(
      themeMode: ThemeMode.system,
      language: 'en',
      fontSize: FontSize.large,
      soundEnabled: true,
      vibrationEnabled: true,
      animationsEnabled: false,
      autoLockEnabled: false,
      autoLockTimeout: AutoLockTimeout.never,
      biometricEnabled: false,
      crashReportingEnabled: true,
      analyticsEnabled: false,
      performanceMonitoringEnabled: false,
      highContrastMode: true,
      reduceMotion: true,
      screenReaderSupport: true,
    );
  }

  /// Create preferences for battery saving
  factory AppPreferencesModel.batterySaving() {
    return const AppPreferencesModel(
      themeMode: ThemeMode.dark,
      language: 'en',
      fontSize: FontSize.medium,
      soundEnabled: false,
      vibrationEnabled: false,
      animationsEnabled: false,
      autoLockEnabled: true,
      autoLockTimeout: AutoLockTimeout.oneMinute,
      biometricEnabled: true,
      crashReportingEnabled: false,
      analyticsEnabled: false,
      performanceMonitoringEnabled: false,
      highContrastMode: false,
      reduceMotion: true,
      screenReaderSupport: false,
    );
  }

  /// Update theme mode
  AppPreferencesModel updateTheme(ThemeMode newThemeMode) {
    return AppPreferencesModel.fromEntity(copyWith(themeMode: newThemeMode));
  }

  /// Update language
  AppPreferencesModel updateLanguage(String newLanguage) {
    return AppPreferencesModel.fromEntity(copyWith(language: newLanguage));
  }

  /// Update font size
  AppPreferencesModel updateFontSize(FontSize newFontSize) {
    return AppPreferencesModel.fromEntity(copyWith(fontSize: newFontSize));
  }

  /// Toggle biometric authentication
  AppPreferencesModel toggleBiometric() {
    return AppPreferencesModel.fromEntity(copyWith(biometricEnabled: !biometricEnabled));
  }

  /// Update auto-lock settings
  AppPreferencesModel updateAutoLock({
    bool? enabled,
    AutoLockTimeout? timeout,
  }) {
    return AppPreferencesModel.fromEntity(copyWith(
      autoLockEnabled: enabled ?? autoLockEnabled,
      autoLockTimeout: timeout ?? autoLockTimeout,
    ));
  }

  /// Update accessibility settings
  AppPreferencesModel updateAccessibility({
    bool? highContrast,
    bool? reduceMotion,
    bool? screenReader,
    FontSize? fontSize,
  }) {
    return AppPreferencesModel.fromEntity(copyWith(
      highContrastMode: highContrast ?? highContrastMode,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      screenReaderSupport: screenReader ?? screenReaderSupport,
      fontSize: fontSize ?? this.fontSize,
    ));
  }

  /// Update privacy settings
  AppPreferencesModel updatePrivacy({
    bool? crashReporting,
    bool? analytics,
    bool? performanceMonitoring,
  }) {
    return AppPreferencesModel.fromEntity(copyWith(
      crashReportingEnabled: crashReporting ?? crashReportingEnabled,
      analyticsEnabled: analytics ?? analyticsEnabled,
      performanceMonitoringEnabled: performanceMonitoring ?? performanceMonitoringEnabled,
    ));
  }
}