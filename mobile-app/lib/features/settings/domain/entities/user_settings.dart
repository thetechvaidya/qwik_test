import 'package:equatable/equatable.dart';
import 'app_preferences.dart';

class UserSettings extends Equatable {
  const UserSettings({
    required this.userId,
    this.preferences = const AppPreferences(),
    this.privacy = const {},
    this.security = const {},
    this.updatedAt,
  });

  final String userId;
  final AppPreferences preferences;
  final Map<String, dynamic> privacy;
  final Map<String, dynamic> security;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        userId,
        preferences,
        privacy,
        security,
        updatedAt,
      ];

  /// Gets the current theme mode
  String getThemeMode() {
    return preferences.theme;
  }



  /// Gets language preference
  String getLanguage() {
    return preferences.language;
  }

  /// Gets privacy setting value
  T? getPrivacySetting<T>(String key) {
    return privacy[key] as T?;
  }

  /// Gets security setting value
  T? getSecuritySetting<T>(String key) {
    return security[key] as T?;
  }

  UserSettings copyWith({
    String? userId,
    AppPreferences? preferences,
    Map<String, dynamic>? privacy,
    Map<String, dynamic>? security,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      preferences: preferences ?? this.preferences,
      privacy: privacy ?? this.privacy,
      security: security ?? this.security,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts UserSettings to JSON map for API calls
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'preferences': {
        'theme': preferences.theme,
        'language': preferences.language,
      },
      'privacy': privacy,
      'security': security,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Creates UserSettings from JSON map
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'] as String,
      preferences: AppPreferences(
        theme: json['preferences']?['theme'] as String? ?? 'system',
        language: json['preferences']?['language'] as String? ?? 'en',
      ),
      privacy: Map<String, dynamic>.from(json['privacy'] as Map? ?? {}),
      security: Map<String, dynamic>.from(json['security'] as Map? ?? {}),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'UserSettings(userId: $userId, preferences: $preferences, privacy: $privacy, security: $security, updatedAt: $updatedAt)';
  }
}