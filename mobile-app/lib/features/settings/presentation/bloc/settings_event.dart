import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user settings
class SettingsLoadRequested extends SettingsEvent {
  const SettingsLoadRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Event to update user settings
class SettingsUpdateRequested extends SettingsEvent {
  const SettingsUpdateRequested({
    required this.userId,
    required this.updates,
  });

  final String userId;
  final Map<String, dynamic> updates;

  @override
  List<Object?> get props => [userId, updates];
}

/// Event to load notification settings
class NotificationSettingsLoadRequested extends SettingsEvent {
  const NotificationSettingsLoadRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Event to update notification settings
class NotificationSettingsUpdateRequested extends SettingsEvent {
  const NotificationSettingsUpdateRequested({
    required this.userId,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.examReminders,
    required this.resultNotifications,
    required this.marketingEmails,
  });

  final String userId;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool examReminders;
  final bool resultNotifications;
  final bool marketingEmails;

  @override
  List<Object?> get props => [
        userId,
        pushNotifications,
        emailNotifications,
        examReminders,
        resultNotifications,
        marketingEmails,
      ];
}

/// Event to load app preferences
class AppPreferencesLoadRequested extends SettingsEvent {
  const AppPreferencesLoadRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Event to update app preferences
class AppPreferencesUpdateRequested extends SettingsEvent {
  const AppPreferencesUpdateRequested({
    required this.userId,
    required this.theme,
    required this.language,
    required this.fontSize,
    required this.autoSync,
    required this.biometricAuth,
  });

  final String userId;
  final String theme;
  final String language;
  final String fontSize;
  final bool autoSync;
  final bool biometricAuth;

  @override
  List<Object?> get props => [
        userId,
        theme,
        language,
        fontSize,
        autoSync,
        biometricAuth,
      ];
}

/// Event to load available themes
class AvailableThemesLoadRequested extends SettingsEvent {
  const AvailableThemesLoadRequested();
}

/// Event to load available languages
class AvailableLanguagesLoadRequested extends SettingsEvent {
  const AvailableLanguagesLoadRequested();
}

/// Event to clear settings error
class SettingsErrorCleared extends SettingsEvent {
  const SettingsErrorCleared();
}

/// Event to refresh settings data
class SettingsRefreshRequested extends SettingsEvent {
  const SettingsRefreshRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Event to reset settings to default
class SettingsResetRequested extends SettingsEvent {
  const SettingsResetRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}