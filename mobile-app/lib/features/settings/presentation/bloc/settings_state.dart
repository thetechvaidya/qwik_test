import 'package:equatable/equatable.dart';
import '../../domain/entities/user_settings.dart';
// Removed imports for notification_settings and app_preferences

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
    this.availableThemes = const [],
    this.availableLanguages = const [],
  });

  final UserSettings userSettings;
  final List<String> availableThemes;
  final List<String> availableLanguages;

  @override
  List<Object?> get props => [
        userSettings,
        availableThemes,
        availableLanguages,
      ];

  SettingsLoaded copyWith({
    UserSettings? userSettings,
    List<String>? availableThemes,
    List<String>? availableLanguages,
  }) {
    return SettingsLoaded(
      userSettings: userSettings ?? this.userSettings,
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

// Removed notification and app preferences related states

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