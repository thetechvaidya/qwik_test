import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/user_settings.dart';
import 'notification_settings_model.dart';
import 'app_preferences_model.dart';

part 'user_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class UserSettingsModel extends UserSettings {
  const UserSettingsModel({
    @HiveField(0) required super.userId,
    @HiveField(1) super.notifications = const NotificationSettingsModel(),
    @HiveField(2) super.preferences = const AppPreferencesModel(),
    @HiveField(3) super.privacy = const {},
    @HiveField(4) super.security = const {},
    @HiveField(5) super.updatedAt,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserSettingsModelFromJson(json);
    } catch (e) {
      // Handle malformed JSON by providing fallback values
      return UserSettingsModel(
        userId: json['user_id']?.toString() ?? json['userId']?.toString() ?? '',
        notifications: _parseNotifications(json['notifications']),
        preferences: _parsePreferences(json['preferences']),
        privacy: _parseMapData(json['privacy']),
        security: _parseMapData(json['security']),
        updatedAt: _parseDateTime(json['updated_at'] ?? json['updatedAt']),
      );
    }
  }

  Map<String, dynamic> toJson() => _$UserSettingsModelToJson(this);

  factory UserSettingsModel.fromEntity(UserSettings settings) {
    return UserSettingsModel(
      userId: settings.userId,
      notifications: settings.notifications is NotificationSettingsModel
          ? settings.notifications as NotificationSettingsModel
          : NotificationSettingsModel.fromEntity(settings.notifications),
      preferences: settings.preferences is AppPreferencesModel
          ? settings.preferences as AppPreferencesModel
          : AppPreferencesModel.fromEntity(settings.preferences),
      privacy: settings.privacy,
      security: settings.security,
      updatedAt: settings.updatedAt,
    );
  }

  UserSettings toEntity() {
    return UserSettings(
      userId: userId,
      notifications: notifications,
      preferences: preferences,
      privacy: privacy,
      security: security,
      updatedAt: updatedAt,
    );
  }

  /// Helper method to parse notification settings
  static NotificationSettingsModel _parseNotifications(dynamic notificationsData) {
    if (notificationsData == null) return const NotificationSettingsModel();
    
    if (notificationsData is Map<String, dynamic>) {
      return NotificationSettingsModel.fromJson(notificationsData);
    }
    
    return const NotificationSettingsModel();
  }

  /// Helper method to parse app preferences
  static AppPreferencesModel _parsePreferences(dynamic preferencesData) {
    if (preferencesData == null) return const AppPreferencesModel();
    
    if (preferencesData is Map<String, dynamic>) {
      return AppPreferencesModel.fromJson(preferencesData);
    }
    
    return const AppPreferencesModel();
  }

  /// Helper method to parse map data
  static Map<String, dynamic> _parseMapData(dynamic mapData) {
    if (mapData == null) return {};
    
    if (mapData is Map<String, dynamic>) {
      return mapData;
    }
    
    if (mapData is Map) {
      return mapData.map((key, value) => MapEntry(key.toString(), value));
    }
    
    return {};
  }

  /// Helper method to parse DateTime from string or timestamp
  static DateTime? _parseDateTime(dynamic dateData) {
    if (dateData == null) return null;
    
    if (dateData is String) {
      return DateTime.tryParse(dateData);
    }
    
    if (dateData is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateData * 1000);
    }
    
    return null;
  }

  /// Create settings model with current timestamp
  factory UserSettingsModel.withCurrentTimestamp({
    required String userId,
    NotificationSettingsModel notifications = const NotificationSettingsModel(),
    AppPreferencesModel preferences = const AppPreferencesModel(),
    Map<String, dynamic> privacy = const {},
    Map<String, dynamic> security = const {},
  }) {
    return UserSettingsModel(
      userId: userId,
      notifications: notifications,
      preferences: preferences,
      privacy: privacy,
      security: security,
      updatedAt: DateTime.now(),
    );
  }

  /// Update settings with new timestamp
  UserSettingsModel updateWithTimestamp({
    NotificationSettingsModel? notifications,
    AppPreferencesModel? preferences,
    Map<String, dynamic>? privacy,
    Map<String, dynamic>? security,
  }) {
    return UserSettingsModel(
      userId: userId,
      notifications: notifications ?? this.notifications as NotificationSettingsModel,
      preferences: preferences ?? this.preferences as AppPreferencesModel,
      privacy: privacy ?? this.privacy,
      security: security ?? this.security,
      updatedAt: DateTime.now(),
    );
  }

  /// Create default settings for a new user
  factory UserSettingsModel.defaultSettings(String userId) {
    return UserSettingsModel(
      userId: userId,
      notifications: const NotificationSettingsModel(),
      preferences: const AppPreferencesModel(),
      privacy: {
        'profile_visibility': 'public',
        'show_stats': true,
        'show_achievements': true,
        'allow_friend_requests': true,
      },
      security: {
        'biometric_enabled': false,
        'two_factor_enabled': false,
        'login_alerts': true,
        'session_timeout': 3600, // 1 hour
      },
      updatedAt: DateTime.now(),
    );
  }

  /// Update a specific setting
  UserSettingsModel updateSetting(String category, String key, dynamic value) {
    switch (category.toLowerCase()) {
      case 'privacy':
        final updatedPrivacy = Map<String, dynamic>.from(privacy);
        updatedPrivacy[key] = value;
        return updateWithTimestamp(privacy: updatedPrivacy);
      
      case 'security':
        final updatedSecurity = Map<String, dynamic>.from(security);
        updatedSecurity[key] = value;
        return updateWithTimestamp(security: updatedSecurity);
      
      default:
        return this;
    }
  }
}