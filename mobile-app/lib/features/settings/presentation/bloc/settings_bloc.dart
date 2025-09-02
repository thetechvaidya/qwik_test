import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_user_settings_usecase.dart';
import '../../domain/usecases/update_user_settings_usecase.dart';
import '../../domain/usecases/get_notification_settings_usecase.dart';
import '../../domain/usecases/get_app_preferences_usecase.dart';
import '../../domain/usecases/get_available_themes_usecase.dart';
import '../../domain/usecases/get_available_languages_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetUserSettingsUseCase getUserSettingsUseCase,
    required UpdateUserSettingsUseCase updateUserSettingsUseCase,
    required GetNotificationSettingsUseCase getNotificationSettingsUseCase,
    required GetAppPreferencesUseCase getAppPreferencesUseCase,
    required GetAvailableThemesUseCase getAvailableThemesUseCase,
    required GetAvailableLanguagesUseCase getAvailableLanguagesUseCase,
  })  : _getUserSettingsUseCase = getUserSettingsUseCase,
        _updateUserSettingsUseCase = updateUserSettingsUseCase,
        _getNotificationSettingsUseCase = getNotificationSettingsUseCase,
        _getAppPreferencesUseCase = getAppPreferencesUseCase,
        _getAvailableThemesUseCase = getAvailableThemesUseCase,
        _getAvailableLanguagesUseCase = getAvailableLanguagesUseCase,
        super(const SettingsInitial()) {
    on<SettingsLoadRequested>(_onSettingsLoadRequested);
    on<SettingsUpdateRequested>(_onSettingsUpdateRequested);
    on<NotificationSettingsLoadRequested>(_onNotificationSettingsLoadRequested);
    on<NotificationSettingsUpdateRequested>(_onNotificationSettingsUpdateRequested);
    on<AppPreferencesLoadRequested>(_onAppPreferencesLoadRequested);
    on<AppPreferencesUpdateRequested>(_onAppPreferencesUpdateRequested);
    on<AvailableThemesLoadRequested>(_onAvailableThemesLoadRequested);
    on<AvailableLanguagesLoadRequested>(_onAvailableLanguagesLoadRequested);
    on<SettingsErrorCleared>(_onSettingsErrorCleared);
    on<SettingsRefreshRequested>(_onSettingsRefreshRequested);
    on<SettingsResetRequested>(_onSettingsResetRequested);
  }

  final GetUserSettingsUseCase _getUserSettingsUseCase;
  final UpdateUserSettingsUseCase _updateUserSettingsUseCase;
  final GetNotificationSettingsUseCase _getNotificationSettingsUseCase;
  final GetAppPreferencesUseCase _getAppPreferencesUseCase;
  final GetAvailableThemesUseCase _getAvailableThemesUseCase;
  final GetAvailableLanguagesUseCase _getAvailableLanguagesUseCase;

  Future<void> _onSettingsLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await _getUserSettingsUseCase(
      GetUserSettingsParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(SettingsError(message: _mapFailureToMessage(failure))),
      (userSettings) => emit(SettingsLoaded(userSettings: userSettings)),
    );
  }

  Future<void> _onSettingsUpdateRequested(
    SettingsUpdateRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(SettingsUpdating(currentSettings: currentState.userSettings));
    }

    final result = await _updateUserSettingsUseCase(
      UpdateUserSettingsParams(
        userId: event.userId,
        updates: event.updates,
      ),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: _mapFailureToMessage(failure),
        currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
      )),
      (userSettings) => emit(SettingsUpdateSuccess(
        userSettings: userSettings,
        message: 'Settings updated successfully',
      )),
    );
  }

  Future<void> _onNotificationSettingsLoadRequested(
    NotificationSettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    
    final result = await _getNotificationSettingsUseCase(
      GetNotificationSettingsParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: _mapFailureToMessage(failure),
        currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
      )),
      (notificationSettings) {
        if (currentState is SettingsLoaded) {
          emit(currentState.copyWith(notificationSettings: notificationSettings));
        } else {
          emit(SettingsError(
            message: 'Settings not loaded',
            currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
          ));
        }
      },
    );
  }

  Future<void> _onNotificationSettingsUpdateRequested(
    NotificationSettingsUpdateRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettingsLoaded && currentState.notificationSettings != null) {
      emit(NotificationSettingsUpdating(currentSettings: currentState.notificationSettings!));
    }

    // Create updated notification settings
    final updatedSettings = currentState is SettingsLoaded && currentState.notificationSettings != null
        ? currentState.notificationSettings!.copyWith(
            pushNotifications: event.pushNotifications,
            emailNotifications: event.emailNotifications,
            examReminders: event.examReminders,
            resultNotifications: event.resultNotifications,
            marketingEmails: event.marketingEmails,
          )
        : null;

    if (updatedSettings != null) {
      emit(NotificationSettingsUpdateSuccess(notificationSettings: updatedSettings));
    } else {
      emit(SettingsError(
        message: 'Notification settings not loaded',
        currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
      ));
    }
  }

  Future<void> _onAppPreferencesLoadRequested(
    AppPreferencesLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    
    final result = await _getAppPreferencesUseCase(
      GetAppPreferencesParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: _mapFailureToMessage(failure),
        currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
      )),
      (appPreferences) {
        if (currentState is SettingsLoaded) {
          emit(currentState.copyWith(appPreferences: appPreferences));
        } else {
          emit(SettingsError(
            message: 'Settings not loaded',
            currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
          ));
        }
      },
    );
  }

  Future<void> _onAppPreferencesUpdateRequested(
    AppPreferencesUpdateRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettingsLoaded && currentState.appPreferences != null) {
      emit(AppPreferencesUpdating(currentPreferences: currentState.appPreferences!));
    }

    // Create updated app preferences
    final updatedPreferences = currentState is SettingsLoaded && currentState.appPreferences != null
        ? currentState.appPreferences!.copyWith(
            theme: event.theme,
            language: event.language,
            fontSize: event.fontSize,
            autoSync: event.autoSync,
            biometricAuth: event.biometricAuth,
          )
        : null;

    if (updatedPreferences != null) {
      emit(AppPreferencesUpdateSuccess(appPreferences: updatedPreferences));
    } else {
      emit(SettingsError(
        message: 'App preferences not loaded',
        currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
      ));
    }
  }

  Future<void> _onAvailableThemesLoadRequested(
    AvailableThemesLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    
    final result = await _getAvailableThemesUseCase();

    result.fold(
      (failure) => emit(SettingsError(
        message: _mapFailureToMessage(failure),
        currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
      )),
      (themes) {
        if (currentState is SettingsLoaded) {
          emit(currentState.copyWith(availableThemes: themes));
        } else {
          emit(SettingsError(
            message: 'Settings not loaded',
            currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
          ));
        }
      },
    );
  }

  Future<void> _onAvailableLanguagesLoadRequested(
    AvailableLanguagesLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    
    final result = await _getAvailableLanguagesUseCase();

    result.fold(
      (failure) => emit(SettingsError(
        message: _mapFailureToMessage(failure),
        currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
      )),
      (languages) {
        if (currentState is SettingsLoaded) {
          emit(currentState.copyWith(availableLanguages: languages));
        } else {
          emit(SettingsError(
            message: 'Settings not loaded',
            currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
          ));
        }
      },
    );
  }

  Future<void> _onSettingsErrorCleared(
    SettingsErrorCleared event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettingsError && currentState.currentSettings != null) {
      emit(SettingsLoaded(userSettings: currentState.currentSettings!));
    } else {
      emit(const SettingsInitial());
    }
  }

  Future<void> _onSettingsRefreshRequested(
    SettingsRefreshRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(SettingsRefreshing(currentSettings: currentState.userSettings));
    }

    final result = await _getUserSettingsUseCase(
      GetUserSettingsParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: _mapFailureToMessage(failure),
        currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
      )),
      (userSettings) => emit(SettingsLoaded(userSettings: userSettings)),
    );
  }

  Future<void> _onSettingsResetRequested(
    SettingsResetRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(SettingsResetting(currentSettings: currentState.userSettings));
    }

    // Reset to default settings
    final defaultSettings = currentState is SettingsLoaded
        ? currentState.userSettings.copyWith(
            // Reset to default values
            theme: 'light',
            language: 'en',
            fontSize: 'medium',
            autoSync: true,
            biometricAuth: false,
          )
        : null;

    if (defaultSettings != null) {
      emit(SettingsResetSuccess(userSettings: defaultSettings));
    } else {
      emit(SettingsError(
        message: 'Settings not loaded',
        currentSettings: currentState is SettingsLoaded ? currentState.userSettings : null,
      ));
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