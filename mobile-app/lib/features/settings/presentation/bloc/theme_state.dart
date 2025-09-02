import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

/// Initial state when theme feature starts
class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

/// State when loading theme data
class ThemeLoading extends ThemeState {
  const ThemeLoading();
}

/// State when theme is loaded successfully
class ThemeLoaded extends ThemeState {
  const ThemeLoaded({
    required this.currentTheme,
    this.availableThemes = const [],
    this.isSystemTheme = false,
  });

  final String currentTheme;
  final List<String> availableThemes;
  final bool isSystemTheme;

  @override
  List<Object?> get props => [currentTheme, availableThemes, isSystemTheme];

  ThemeLoaded copyWith({
    String? currentTheme,
    List<String>? availableThemes,
    bool? isSystemTheme,
  }) {
    return ThemeLoaded(
      currentTheme: currentTheme ?? this.currentTheme,
      availableThemes: availableThemes ?? this.availableThemes,
      isSystemTheme: isSystemTheme ?? this.isSystemTheme,
    );
  }
}

/// State when changing theme
class ThemeChanging extends ThemeState {
  const ThemeChanging({
    required this.currentTheme,
    required this.newTheme,
  });

  final String currentTheme;
  final String newTheme;

  @override
  List<Object?> get props => [currentTheme, newTheme];
}

/// State when theme change is successful
class ThemeChangeSuccess extends ThemeState {
  const ThemeChangeSuccess({
    required this.theme,
    this.message,
  });

  final String theme;
  final String? message;

  @override
  List<Object?> get props => [theme, message];
}

/// State when theme operation fails
class ThemeError extends ThemeState {
  const ThemeError({
    required this.message,
    this.currentTheme,
  });

  final String message;
  final String? currentTheme;

  @override
  List<Object?> get props => [message, currentTheme];
}

/// State when theme is set to follow system
class ThemeSystemEnabled extends ThemeState {
  const ThemeSystemEnabled({
    required this.systemTheme,
  });

  final String systemTheme;

  @override
  List<Object?> get props => [systemTheme];
}

/// State when theme is reset to default
class ThemeResetSuccess extends ThemeState {
  const ThemeResetSuccess({
    required this.defaultTheme,
  });

  final String defaultTheme;

  @override
  List<Object?> get props => [defaultTheme];
}