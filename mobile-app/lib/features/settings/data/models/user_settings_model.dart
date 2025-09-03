import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/user_settings.dart';
import 'notification_settings_model.dart';
import 'app_preferences_model.dart';

part 'user_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class UserSettingsModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final NotificationSettingsModel notifications;

  @HiveField(2)
  final AppPreferencesModel preferences;

  @HiveField(3)
  final Map<String, dynamic> privacy;

  @HiveField(4)
  final Map<String, dynamic> security;

  @HiveField(5)
  final DateTime? updatedAt;

  const UserSettingsModel({
    required this.userId,
    this.notifications = const NotificationSettingsModel(),
    this.preferences = const AppPreferencesModel(),
    this.privacy = const {},
    this.security = const {},
    this.updatedAt,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

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
      notifications: notifications.toEntity(),
      preferences: preferences.toEntity(),
      privacy: privacy,
      security: security,
      updatedAt: updatedAt,
    );
  }
}