import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/app_preferences.dart';
// Removed unused import: offline_preferences_model.dart

part 'app_preferences_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 4)
class AppPreferencesModel extends AppPreferences {
  const AppPreferencesModel({
    @HiveField(0) super.theme = 'system',
    @HiveField(1) super.language = 'en',
    // Removed unused fields: timezone, fontSize, soundEnabled, vibrationEnabled,
    // animationsEnabled, autoLockEnabled, autoLockTimeout, biometricEnabled,
    // crashReportingEnabled, analyticsEnabled, performanceMonitoringEnabled,
    // highContrastMode, reduceMotion, screenReaderSupport, offlinePreferences
  });

  factory AppPreferencesModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$AppPreferencesModelFromJson(json);
    } catch (e) {
      // Handle malformed JSON by providing fallback values
      return AppPreferencesModel(
        theme: json['theme']?.toString() ?? 'system',
        language: json['language']?.toString() ?? 'en',
      );
    }
  }

  Map<String, dynamic> toJson() => _$AppPreferencesModelToJson(this);

  factory AppPreferencesModel.fromEntity(AppPreferences preferences) {
    return AppPreferencesModel(
      theme: preferences.theme,
      language: preferences.language,
    );
  }

  AppPreferences toEntity() {
    return AppPreferences(
      theme: theme,
      language: language,
    );
  }

  // Removed all helper parsing methods - not needed for simplified preferences
}