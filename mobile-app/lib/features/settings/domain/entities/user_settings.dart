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

  @override
  String toString() {
    return 'UserSettings(userId: $userId, preferences: $preferences, privacy: $privacy, security: $security, updatedAt: $updatedAt)';
  }
}