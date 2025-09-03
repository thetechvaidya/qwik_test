import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/notification_settings.dart';

part 'notification_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 3)
class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({
    @HiveField(0) super.emailNotifications = true,
    @HiveField(1) super.pushNotifications = true,
    @HiveField(2) super.examReminders = true,
    @HiveField(3) super.achievementAlerts = true,
    @HiveField(4) super.studyReminders = true,
    @HiveField(5) super.socialUpdates = false,
    @HiveField(6) super.marketingEmails = false,
    @HiveField(7) super.weeklyReports = true,
    @HiveField(8) super.friendActivity = false,
    @HiveField(9) super.systemUpdates = true,
    @HiveField(10) super.quietHoursEnabled = false,
    @HiveField(11) super.quietHoursStart = const TimeOfDay(hour: 22, minute: 0),
    @HiveField(12) super.quietHoursEnd = const TimeOfDay(hour: 8, minute: 0),
    @HiveField(13) super.soundEnabled = true,
    @HiveField(14) super.vibrationEnabled = true,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$NotificationSettingsModelFromJson(json);
    } catch (e) {
      // Handle malformed JSON by providing fallback values
      return NotificationSettingsModel(
        emailNotifications: _parseBool(json['email_notifications'] ?? json['emailNotifications']),
        pushNotifications: _parseBool(json['push_notifications'] ?? json['pushNotifications']),
        examReminders: _parseBool(json['exam_reminders'] ?? json['examReminders']),
        achievementAlerts: _parseBool(json['achievement_alerts'] ?? json['achievementAlerts']),
        studyReminders: _parseBool(json['study_reminders'] ?? json['studyReminders']),
        socialUpdates: _parseBool(json['social_updates'] ?? json['socialUpdates'], defaultValue: false),
        marketingEmails: _parseBool(json['marketing_emails'] ?? json['marketingEmails'], defaultValue: false),
        weeklyReports: _parseBool(json['weekly_reports'] ?? json['weeklyReports']),
        friendActivity: _parseBool(json['friend_activity'] ?? json['friendActivity'], defaultValue: false),
        systemUpdates: _parseBool(json['system_updates'] ?? json['systemUpdates']),
        quietHoursEnabled: _parseBool(json['quiet_hours_enabled'] ?? json['quietHoursEnabled'], defaultValue: false),
        quietHoursStart: _parseTimeOfDay(json['quiet_hours_start'] ?? json['quietHoursStart'], const TimeOfDay(hour: 22, minute: 0)),
        quietHoursEnd: _parseTimeOfDay(json['quiet_hours_end'] ?? json['quietHoursEnd'], const TimeOfDay(hour: 8, minute: 0)),
        soundEnabled: _parseBool(json['sound_enabled'] ?? json['soundEnabled']),
        vibrationEnabled: _parseBool(json['vibration_enabled'] ?? json['vibrationEnabled']),
      );
    }
  }

  Map<String, dynamic> toJson() => _$NotificationSettingsModelToJson(this);

  factory NotificationSettingsModel.fromEntity(NotificationSettings settings) {
    return NotificationSettingsModel(
      emailNotifications: settings.emailNotifications,
      pushNotifications: settings.pushNotifications,
      examReminders: settings.examReminders,
      achievementAlerts: settings.achievementAlerts,
      studyReminders: settings.studyReminders,
      socialUpdates: settings.socialUpdates,
      marketingEmails: settings.marketingEmails,
      weeklyReports: settings.weeklyReports,
      friendActivity: settings.friendActivity,
      systemUpdates: settings.systemUpdates,
      quietHoursEnabled: settings.quietHoursEnabled,
      quietHoursStart: settings.quietHoursStart,
      quietHoursEnd: settings.quietHoursEnd,
      soundEnabled: settings.soundEnabled,
      vibrationEnabled: settings.vibrationEnabled,
    );
  }

  NotificationSettings toEntity() {
    return NotificationSettings(
      emailNotifications: emailNotifications,
      pushNotifications: pushNotifications,
      examReminders: examReminders,
      achievementAlerts: achievementAlerts,
      studyReminders: studyReminders,
      socialUpdates: socialUpdates,
      marketingEmails: marketingEmails,
      weeklyReports: weeklyReports,
      friendActivity: friendActivity,
      systemUpdates: systemUpdates,
      quietHoursEnabled: quietHoursEnabled,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
    );
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

  /// Helper method to parse TimeOfDay from various formats
  static TimeOfDay _parseTimeOfDay(dynamic value, TimeOfDay defaultValue) {
    if (value == null) return defaultValue;
    
    if (value is Map<String, dynamic>) {
      final hour = value['hour'] ?? value['h'] ?? defaultValue.hour;
      final minute = value['minute'] ?? value['m'] ?? defaultValue.minute;
      return TimeOfDay(hour: hour is int ? hour : int.tryParse(hour.toString()) ?? defaultValue.hour,
                      minute: minute is int ? minute : int.tryParse(minute.toString()) ?? defaultValue.minute);
    }
    
    if (value is String) {
      // Parse "HH:MM" format
      final parts = value.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    }
    
    return defaultValue;
  }

  /// Create notification settings with all notifications enabled
  factory NotificationSettingsModel.allEnabled() {
    return const NotificationSettingsModel(
      emailNotifications: true,
      pushNotifications: true,
      examReminders: true,
      achievementAlerts: true,
      studyReminders: true,
      socialUpdates: true,
      marketingEmails: true,
      weeklyReports: true,
      friendActivity: true,
      systemUpdates: true,
      quietHoursEnabled: false,
      soundEnabled: true,
      vibrationEnabled: true,
    );
  }

  /// Create notification settings with all notifications disabled
  factory NotificationSettingsModel.allDisabled() {
    return const NotificationSettingsModel(
      emailNotifications: false,
      pushNotifications: false,
      examReminders: false,
      achievementAlerts: false,
      studyReminders: false,
      socialUpdates: false,
      marketingEmails: false,
      weeklyReports: false,
      friendActivity: false,
      systemUpdates: false,
      quietHoursEnabled: false,
      soundEnabled: false,
      vibrationEnabled: false,
    );
  }

  /// Create notification settings with only essential notifications
  factory NotificationSettingsModel.essentialOnly() {
    return const NotificationSettingsModel(
      emailNotifications: false,
      pushNotifications: true,
      examReminders: true,
      achievementAlerts: false,
      studyReminders: true,
      socialUpdates: false,
      marketingEmails: false,
      weeklyReports: false,
      friendActivity: false,
      systemUpdates: true,
      quietHoursEnabled: true,
      quietHoursStart: TimeOfDay(hour: 22, minute: 0),
      quietHoursEnd: TimeOfDay(hour: 8, minute: 0),
      soundEnabled: true,
      vibrationEnabled: true,
    );
  }

  /// Toggle a specific notification type
  NotificationSettingsModel toggleNotification(String notificationType) {
    switch (notificationType.toLowerCase()) {
      case 'email':
        return NotificationSettingsModel.fromEntity(copyWith(emailNotifications: !emailNotifications));
      case 'push':
        return NotificationSettingsModel.fromEntity(copyWith(pushNotifications: !pushNotifications));
      case 'exam_reminders':
        return NotificationSettingsModel.fromEntity(copyWith(examReminders: !examReminders));
      case 'achievement_alerts':
        return NotificationSettingsModel.fromEntity(copyWith(achievementAlerts: !achievementAlerts));
      case 'study_reminders':
        return NotificationSettingsModel.fromEntity(copyWith(studyReminders: !studyReminders));
      case 'social_updates':
        return NotificationSettingsModel.fromEntity(copyWith(socialUpdates: !socialUpdates));
      case 'marketing_emails':
        return NotificationSettingsModel.fromEntity(copyWith(marketingEmails: !marketingEmails));
      case 'weekly_reports':
        return NotificationSettingsModel.fromEntity(copyWith(weeklyReports: !weeklyReports));
      case 'friend_activity':
        return NotificationSettingsModel.fromEntity(copyWith(friendActivity: !friendActivity));
      case 'system_updates':
        return NotificationSettingsModel.fromEntity(copyWith(systemUpdates: !systemUpdates));
      case 'sound':
        return NotificationSettingsModel.fromEntity(copyWith(soundEnabled: !soundEnabled));
      case 'vibration':
        return NotificationSettingsModel.fromEntity(copyWith(vibrationEnabled: !vibrationEnabled));
      default:
        return this;
    }
  }

  /// Update quiet hours settings
  NotificationSettingsModel updateQuietHours({
    bool? enabled,
    TimeOfDay? start,
    TimeOfDay? end,
  }) {
    return NotificationSettingsModel.fromEntity(copyWith(
      quietHoursEnabled: enabled ?? quietHoursEnabled,
      quietHoursStart: start ?? quietHoursStart,
      quietHoursEnd: end ?? quietHoursEnd,
    ));
  }
}

/// Custom TimeOfDay JSON converter
class TimeOfDayConverter implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int);
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay timeOfDay) {
    return {'hour': timeOfDay.hour, 'minute': timeOfDay.minute};
  }
}