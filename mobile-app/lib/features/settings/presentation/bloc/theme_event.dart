import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load current theme
class ThemeLoadRequested extends ThemeEvent {
  const ThemeLoadRequested();
}

/// Event to change theme
class ThemeChangeRequested extends ThemeEvent {
  const ThemeChangeRequested({
    required this.theme,
  });

  final String theme;

  @override
  List<Object?> get props => [theme];
}

/// Event to toggle between light and dark theme
class ThemeToggleRequested extends ThemeEvent {
  const ThemeToggleRequested();
}

/// Event to set system theme (follows device settings)
class ThemeSystemRequested extends ThemeEvent {
  const ThemeSystemRequested();
}

/// Event to load available themes
class ThemeAvailableLoadRequested extends ThemeEvent {
  const ThemeAvailableLoadRequested();
}

/// Event to reset theme to default
class ThemeResetRequested extends ThemeEvent {
  const ThemeResetRequested();
}