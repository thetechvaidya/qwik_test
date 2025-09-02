import 'package:equatable/equatable.dart';

class NotificationSettings extends Equatable {
  const NotificationSettings({
    this.email = true,
    this.push = true,
    this.examReminders = true,
    this.achievementAlerts = true,
    this.studyReminders = true,
    this.weeklyProgress = true,
    this.newContent = false,
    this.promotions = false,
    this.systemUpdates = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '08:00',
  });

  final bool email;
  final bool push;
  final bool examReminders;
  final bool achievementAlerts;
  final bool studyReminders;
  final bool weeklyProgress;
  final bool newContent;
  final bool promotions;
  final bool systemUpdates;
  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;

  @override
  List<Object?> get props => [
        email,
        push,
        examReminders,
        achievementAlerts,
        studyReminders,
        weeklyProgress,
        newContent,
        promotions,
        systemUpdates,
        quietHoursEnabled,
        quietHoursStart,
        quietHoursEnd,
      ];

  /// Checks if a specific notification type is enabled
  bool isEnabled(String type) {
    switch (type.toLowerCase()) {
      case 'email':
        return email;
      case 'push':
        return push;
      case 'exam_reminders':
      case 'examreminders':
        return examReminders;
      case 'achievement_alerts':
      case 'achievementalerts':
        return achievementAlerts;
      case 'study_reminders':
      case 'studyreminders':
        return studyReminders;
      case 'weekly_progress':
      case 'weeklyprogress':
        return weeklyProgress;
      case 'new_content':
      case 'newcontent':
        return newContent;
      case 'promotions':
        return promotions;
      case 'system_updates':
      case 'systemupdates':
        return systemUpdates;
      default:
        return false;
    }
  }

  /// Gets FCM topics to subscribe to based on enabled notifications
  List<String> getFCMTopics() {
    final topics = <String>[];
    
    if (examReminders) topics.add('exam_reminders');
    if (achievementAlerts) topics.add('achievements');
    if (studyReminders) topics.add('study_reminders');
    if (weeklyProgress) topics.add('weekly_progress');
    if (newContent) topics.add('new_content');
    if (promotions) topics.add('promotions');
    if (systemUpdates) topics.add('system_updates');
    
    return topics;
  }

  /// Checks if currently in quiet hours
  bool isInQuietHours() {
    if (!quietHoursEnabled) return false;
    
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    // Simple time comparison (assumes same day)
    final startHour = int.parse(quietHoursStart.split(':')[0]);
    final endHour = int.parse(quietHoursEnd.split(':')[0]);
    final currentHour = now.hour;
    
    if (startHour < endHour) {
      // Same day quiet hours (e.g., 14:00 to 18:00)
      return currentHour >= startHour && currentHour < endHour;
    } else {
      // Overnight quiet hours (e.g., 22:00 to 08:00)
      return currentHour >= startHour || currentHour < endHour;
    }
  }

  /// Gets notification categories that are enabled
  List<String> getEnabledCategories() {
    final enabled = <String>[];
    
    if (email) enabled.add('Email');
    if (push) enabled.add('Push');
    if (examReminders) enabled.add('Exam Reminders');
    if (achievementAlerts) enabled.add('Achievements');
    if (studyReminders) enabled.add('Study Reminders');
    if (weeklyProgress) enabled.add('Weekly Progress');
    if (newContent) enabled.add('New Content');
    if (promotions) enabled.add('Promotions');
    if (systemUpdates) enabled.add('System Updates');
    
    return enabled;
  }

  NotificationSettings copyWith({
    bool? email,
    bool? push,
    bool? examReminders,
    bool? achievementAlerts,
    bool? studyReminders,
    bool? weeklyProgress,
    bool? newContent,
    bool? promotions,
    bool? systemUpdates,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return NotificationSettings(
      email: email ?? this.email,
      push: push ?? this.push,
      examReminders: examReminders ?? this.examReminders,
      achievementAlerts: achievementAlerts ?? this.achievementAlerts,
      studyReminders: studyReminders ?? this.studyReminders,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      newContent: newContent ?? this.newContent,
      promotions: promotions ?? this.promotions,
      systemUpdates: systemUpdates ?? this.systemUpdates,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  @override
  String toString() {
    return 'NotificationSettings(email: $email, push: $push, examReminders: $examReminders, achievementAlerts: $achievementAlerts, studyReminders: $studyReminders, weeklyProgress: $weeklyProgress, newContent: $newContent, promotions: $promotions, systemUpdates: $systemUpdates, quietHoursEnabled: $quietHoursEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd)';
  }
}