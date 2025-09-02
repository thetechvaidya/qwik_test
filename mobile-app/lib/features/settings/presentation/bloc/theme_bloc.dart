import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_available_themes_usecase.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({
    required GetAvailableThemesUseCase getAvailableThemesUseCase,
  })  : _getAvailableThemesUseCase = getAvailableThemesUseCase,
        super(const ThemeInitial()) {
    on<ThemeLoadRequested>(_onThemeLoadRequested);
    on<ThemeChangeRequested>(_onThemeChangeRequested);
    on<ThemeToggleRequested>(_onThemeToggleRequested);
    on<ThemeSystemRequested>(_onThemeSystemRequested);
    on<ThemeAvailableLoadRequested>(_onThemeAvailableLoadRequested);
    on<ThemeResetRequested>(_onThemeResetRequested);
  }

  final GetAvailableThemesUseCase _getAvailableThemesUseCase;
  
  static const String _defaultTheme = 'light';
  static const String _darkTheme = 'dark';
  static const String _systemTheme = 'system';

  Future<void> _onThemeLoadRequested(
    ThemeLoadRequested event,
    Emitter<ThemeState> emit,
  ) async {
    emit(const ThemeLoading());

    try {
      // Load current theme from local storage or preferences
      // For now, we'll use a default theme
      const currentTheme = _defaultTheme;
      
      // Load available themes
      final result = await _getAvailableThemesUseCase();
      
      result.fold(
        (failure) => emit(ThemeError(message: _mapFailureToMessage(failure))),
        (availableThemes) => emit(ThemeLoaded(
          currentTheme: currentTheme,
          availableThemes: availableThemes,
          isSystemTheme: currentTheme == _systemTheme,
        )),
      );
    } catch (e) {
      emit(ThemeError(message: 'Failed to load theme: ${e.toString()}'));
    }
  }

  Future<void> _onThemeChangeRequested(
    ThemeChangeRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final currentState = state;
    String? currentTheme;
    
    if (currentState is ThemeLoaded) {
      currentTheme = currentState.currentTheme;
      emit(ThemeChanging(
        currentTheme: currentTheme,
        newTheme: event.theme,
      ));
    }

    try {
      // Here you would typically save the theme to local storage
      // For now, we'll just emit the success state
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate async operation
      
      emit(ThemeChangeSuccess(
        theme: event.theme,
        message: 'Theme changed to ${event.theme}',
      ));
      
      // Update the loaded state with new theme
      if (currentState is ThemeLoaded) {
        emit(currentState.copyWith(
          currentTheme: event.theme,
          isSystemTheme: event.theme == _systemTheme,
        ));
      }
    } catch (e) {
      emit(ThemeError(
        message: 'Failed to change theme: ${e.toString()}',
        currentTheme: currentTheme,
      ));
    }
  }

  Future<void> _onThemeToggleRequested(
    ThemeToggleRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is ThemeLoaded) {
      final newTheme = currentState.currentTheme == _defaultTheme 
          ? _darkTheme 
          : _defaultTheme;
      
      emit(ThemeChanging(
        currentTheme: currentState.currentTheme,
        newTheme: newTheme,
      ));

      try {
        // Save the new theme
        await Future.delayed(const Duration(milliseconds: 300));
        
        emit(ThemeChangeSuccess(
          theme: newTheme,
          message: 'Theme toggled to $newTheme',
        ));
        
        emit(currentState.copyWith(
          currentTheme: newTheme,
          isSystemTheme: false,
        ));
      } catch (e) {
        emit(ThemeError(
          message: 'Failed to toggle theme: ${e.toString()}',
          currentTheme: currentState.currentTheme,
        ));
      }
    } else {
      emit(const ThemeError(message: 'Theme not loaded'));
    }
  }

  Future<void> _onThemeSystemRequested(
    ThemeSystemRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is ThemeLoaded) {
      emit(ThemeChanging(
        currentTheme: currentState.currentTheme,
        newTheme: _systemTheme,
      ));

      try {
        // Enable system theme following
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Determine current system theme (this would typically check device settings)
        const systemTheme = _defaultTheme; // Placeholder
        
        emit(ThemeSystemEnabled(systemTheme: systemTheme));
        
        emit(currentState.copyWith(
          currentTheme: _systemTheme,
          isSystemTheme: true,
        ));
      } catch (e) {
        emit(ThemeError(
          message: 'Failed to enable system theme: ${e.toString()}',
          currentTheme: currentState.currentTheme,
        ));
      }
    } else {
      emit(const ThemeError(message: 'Theme not loaded'));
    }
  }

  Future<void> _onThemeAvailableLoadRequested(
    ThemeAvailableLoadRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final currentState = state;
    
    final result = await _getAvailableThemesUseCase();
    
    result.fold(
      (failure) => emit(ThemeError(
        message: _mapFailureToMessage(failure),
        currentTheme: currentState is ThemeLoaded ? currentState.currentTheme : null,
      )),
      (availableThemes) {
        if (currentState is ThemeLoaded) {
          emit(currentState.copyWith(availableThemes: availableThemes));
        } else {
          emit(ThemeLoaded(
            currentTheme: _defaultTheme,
            availableThemes: availableThemes,
          ));
        }
      },
    );
  }

  Future<void> _onThemeResetRequested(
    ThemeResetRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is ThemeLoaded) {
      emit(ThemeChanging(
        currentTheme: currentState.currentTheme,
        newTheme: _defaultTheme,
      ));

      try {
        // Reset to default theme
        await Future.delayed(const Duration(milliseconds: 300));
        
        emit(ThemeResetSuccess(defaultTheme: _defaultTheme));
        
        emit(currentState.copyWith(
          currentTheme: _defaultTheme,
          isSystemTheme: false,
        ));
      } catch (e) {
        emit(ThemeError(
          message: 'Failed to reset theme: ${e.toString()}',
          currentTheme: currentState.currentTheme,
        ));
      }
    } else {
      emit(const ThemeError(message: 'Theme not loaded'));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case CacheFailure:
        return 'Local data error occurred.';
      case NetworkFailure:
        return 'Network error. Please check your connection.';
      case ValidationFailure:
        return 'Invalid data provided.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}