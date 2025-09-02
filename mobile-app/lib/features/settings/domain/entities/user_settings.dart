import 'package:equatable/equatable.dart';
import 'notification_settings.dart';
import 'app_preferences.dart';

class UserSettings extends Equatable {
  const UserSettings({
    required this.userId,
    this.notifications = const NotificationSettings(),
    this.preferences = const AppPreferences(),
    this.privacy = const {},
    this.security = const {},
    this.updatedAt,
  });

  final String userId;
  final NotificationSettings notifications;
  final AppPreferences preferences;
  final Map<String, dynamic> privacy;
  final Map<String, dynamic> security;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        userId,
        notifications,
        preferences,
        privacy,
        security,
        updatedAt,
      ];

  /// Checks if a specific notification type is enabled
  bool isNotificationEnabled(String type) {
    return notifications.isEnabled(type);
  }

  /// Gets the current theme mode
  String getThemeMode() {
    return preferences.theme;
  }

  /// Checks if biometric authentication is enabled
  bool isBiometricEnabled() {
    return security['biometric_enabled'] as bool? ?? false;
  }

  /// Checks if offline mode is enabled
  bool isOfflineModeEnabled() {
    return preferences.offlineSettings.autoDownloadEnabled;
  }

  /// Gets language preference
  String getLanguage() {
    return preferences.language;
  }

  /// Checks if auto-sync is enabled
  bool isAutoSyncEnabled() {
    return preferences.offlineSettings.autoSyncEnabled;
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
    NotificationSettings? notifications,
    AppPreferences? preferences,
    Map<String, dynamic>? privacy,
    Map<String, dynamic>? security,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      notifications: notifications ?? this.notifications,
      preferences: preferences ?? this.preferences,
      privacy: privacy ?? this.privacy,
      security: security ?? this.security,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserSettings(userId: $userId, notifications: $notifications, preferences: $preferences, privacy: $privacy, security: $security, updatedAt: $updatedAt)';
  }
}