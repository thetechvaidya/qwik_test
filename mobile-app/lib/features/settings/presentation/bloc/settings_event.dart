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

// Removed notification and app preferences related events

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