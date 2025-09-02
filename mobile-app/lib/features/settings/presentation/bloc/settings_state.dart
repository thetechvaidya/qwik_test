import 'package:equatable/equatable.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/entities/app_preferences.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state when settings feature starts
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// State when loading settings data
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// State when settings data is loaded successfully
class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    required this.userSettings,
    this.notificationSettings,
    this.appPreferences,
    this.availableThemes = const [],
    this.availableLanguages = const [],
  });

  final UserSettings userSettings;
  final NotificationSettings? notificationSettings;
  final AppPreferences? appPreferences;
  final List<String> availableThemes;
  final List<String> availableLanguages;

  @override
  List<Object?> get props => [
        userSettings,
        notificationSettings,
        appPreferences,
        availableThemes,
        availableLanguages,
      ];

  SettingsLoaded copyWith({
    UserSettings? userSettings,
    NotificationSettings? notificationSettings,
    AppPreferences? appPreferences,
    List<String>? availableThemes,
    List<String>? availableLanguages,
  }) {
    return SettingsLoaded(
      userSettings: userSettings ?? this.userSettings,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      appPreferences: appPreferences ?? this.appPreferences,
      availableThemes: availableThemes ?? this.availableThemes,
      availableLanguages: availableLanguages ?? this.availableLanguages,
    );
  }
}

/// State when updating settings
class SettingsUpdating extends SettingsState {
  const SettingsUpdating({
    required this.currentSettings,
  });

  final UserSettings currentSettings;

  @override
  List<Object?> get props => [currentSettings];
}

/// State when settings update is successful
class SettingsUpdateSuccess extends SettingsState {
  const SettingsUpdateSuccess({
    required this.userSettings,
    this.message,
  });

  final UserSettings userSettings;
  final String? message;

  @override
  List<Object?> get props => [userSettings, message];
}

/// State when updating notification settings
class NotificationSettingsUpdating extends SettingsState {
  const NotificationSettingsUpdating({
    required this.currentSettings,
  });

  final NotificationSettings currentSettings;

  @override
  List<Object?> get props => [currentSettings];
}

/// State when notification settings update is successful
class NotificationSettingsUpdateSuccess extends SettingsState {
  const NotificationSettingsUpdateSuccess({
    required this.notificationSettings,
  });

  final NotificationSettings notificationSettings;

  @override
  List<Object?> get props => [notificationSettings];
}

/// State when updating app preferences
class AppPreferencesUpdating extends SettingsState {
  const AppPreferencesUpdating({
    required this.currentPreferences,
  });

  final AppPreferences currentPreferences;

  @override
  List<Object?> get props => [currentPreferences];
}

/// State when app preferences update is successful
class AppPreferencesUpdateSuccess extends SettingsState {
  const AppPreferencesUpdateSuccess({
    required this.appPreferences,
  });

  final AppPreferences appPreferences;

  @override
  List<Object?> get props => [appPreferences];
}

/// State when settings operation fails
class SettingsError extends SettingsState {
  const SettingsError({
    required this.message,
    this.currentSettings,
  });

  final String message;
  final UserSettings? currentSettings;

  @override
  List<Object?> get props => [message, currentSettings];
}

/// State when refreshing settings data
class SettingsRefreshing extends SettingsState {
  const SettingsRefreshing({
    required this.currentSettings,
  });

  final UserSettings currentSettings;

  @override
  List<Object?> get props => [currentSettings];
}

/// State when resetting settings
class SettingsResetting extends SettingsState {
  const SettingsResetting({
    required this.currentSettings,
  });

  final UserSettings currentSettings;

  @override
  List<Object?> get props => [currentSettings];
}

/// State when settings reset is successful
class SettingsResetSuccess extends SettingsState {
  const SettingsResetSuccess({
    required this.userSettings,
  });

  final UserSettings userSettings;

  @override
  List<Object?> get props => [userSettings];
}