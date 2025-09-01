import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/events/auth_event_bus.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart' as events;
import 'auth_state.dart' as states;

class AuthBloc extends Bloc<events.AuthEvent, states.AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required AuthRepository authRepository,
    required AuthEventBus eventBus,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        _authRepository = authRepository,
        _eventBus = eventBus,
        super(const states.AuthInitial()) {
    on<events.AuthCheckRequested>(_onAuthCheckRequested);
    on<events.AuthLoginRequested>(_onAuthLoginRequested);
    on<events.AuthRegisterRequested>(_onAuthRegisterRequested);
    on<events.AuthLogoutRequested>(_onAuthLogoutRequested);
    on<events.AuthTokenRefreshRequested>(_onAuthTokenRefreshRequested);
    on<events.AuthTokenRefreshFailed>(_onAuthTokenRefreshFailed);
    on<events.AuthSessionExpired>(_onAuthSessionExpired);
    on<events.AuthBiometricAuthRequested>(_onAuthBiometricAuthRequested);
    on<events.AuthEmailVerificationRequested>(_onAuthEmailVerificationRequested);
    on<events.AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<events.AuthPasswordResetConfirmRequested>(_onAuthPasswordResetConfirmRequested);
    on<events.AuthPasswordChangeRequested>(_onAuthPasswordChangeRequested);
    on<events.AuthProfileUpdateRequested>(_onAuthProfileUpdateRequested);
    on<events.AuthCurrentUserRequested>(_onAuthCurrentUserRequested);
    on<events.AuthErrorCleared>(_onAuthErrorCleared);
    
    // Set up event bus subscription to listen for auth events from other layers
    _setupEventBusSubscription();
  }
  
  /// Set up subscription to auth event bus
  void _setupEventBusSubscription() {
    _eventBusSubscription = _eventBus.events.listen((event) {
      switch (event.runtimeType) {
        case TokenRefreshStarted:
          // Optionally emit a loading state or just log
          break;
        case TokenRefreshSucceeded:
          // Token was refreshed successfully by interceptor
          // We might want to update the UI state or just continue
          break;
        case TokenRefreshFailed:
          final failedEvent = event as TokenRefreshFailed;
          add(events.AuthTokenRefreshFailed(failedEvent.reason));
          break;
        case SessionExpired:
          final expiredEvent = event as SessionExpired;
          add(const events.AuthSessionExpired());
          break;
        case AuthenticationRequired:
          final authRequiredEvent = event as AuthenticationRequired;
          add(const events.AuthSessionExpired());
          break;
      }
    });
  }
  
  @override
  Future<void> close() {
    _eventBusSubscription?.cancel();
    return super.close();
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final AuthRepository _authRepository;
  final AuthEventBus _eventBus;
  
  StreamSubscription<AuthBusEvent>? _eventBusSubscription;

  Future<void> _onAuthCheckRequested(
    events.AuthCheckRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(const states.AuthLoading());

    try {
      final result = await _getCurrentUserUseCase();
      
      await result.fold(
        (failure) async => emit(const states.AuthUnauthenticated()),
      (user) async => emit(states.AuthAuthenticated(user: user)),
      );
    } catch (e) {
      emit(states.AuthError(message: 'Failed to check authentication status: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLoginRequested(
    events.AuthLoginRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(const states.AuthLoginLoading());

    final result = await _loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    await result.fold(
      (failure) async {
        emit(states.AuthError(message: failure.message));
      },
      (token) async {
        // Get current user after successful login
        final userResult = await _getCurrentUserUseCase();
        
        await userResult.fold(
          (failure) async {
            emit(states.AuthError(message: 'Login successful but failed to get user data'));
          },
          (user) async {
              emit(states.AuthAuthenticated(user: user));
            },
          );
        },
      );
    }

    Future<void> _onAuthRegisterRequested(
      events.AuthRegisterRequested event,
      Emitter<states.AuthState> emit,
    ) async {
      emit(const states.AuthRegisterLoading());

      final result = await _registerUseCase(RegisterParams(
         name: event.name,
         email: event.email,
         password: event.password,
         passwordConfirmation: event.passwordConfirmation,
       ));

      await result.fold(
        (failure) async {
          emit(states.AuthError(message: failure.message));
        },
        (token) async {
          // Get current user after successful registration
          final userResult = await _getCurrentUserUseCase();
          await userResult.fold(
            (failure) async {
              emit(states.AuthError(message: 'Registration successful but failed to get user data'));
            },
            (user) async {
              emit(states.AuthAuthenticated(user: user));
          },
        );
      },
    );
  }

  Future<void> _onAuthLogoutRequested(
    events.AuthLogoutRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(const states.AuthLogoutLoading());

    final result = await _logoutUseCase();
    
    await result.fold(
        (failure) async {
          emit(states.AuthError(message: failure.message));
        },
        (_) async {
          emit(const states.AuthUnauthenticated());
        },
      );
  }

  Future<void> _onAuthTokenRefreshRequested(
    events.AuthTokenRefreshRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(const states.AuthTokenRefreshLoading());
    
    try {
      final result = await _refreshTokenUseCase(const NoParams());
      
      await result.fold(
        (failure) async {
          emit(states.AuthTokenRefreshFailed(failure.message));
          // If token refresh fails, consider session expired
          add(const events.AuthSessionExpired());
        },
        (newToken) async {
          emit(const states.AuthTokenRefreshSuccess());
          
          // Get current user to maintain authenticated state
          final userResult = await _getCurrentUserUseCase();
          await userResult.fold(
            (failure) async {
              emit(states.AuthError(message: 'Token refreshed but failed to get user data'));
            },
            (user) async {
              emit(states.AuthAuthenticated(user: user));
            },
          );
        },
      );
    } catch (e) {
      emit(states.AuthTokenRefreshFailed('Unexpected error during token refresh: ${e.toString()}'));
      add(const events.AuthSessionExpired());
    }
  }
  
  Future<void> _onAuthTokenRefreshFailed(
    events.AuthTokenRefreshFailed event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(states.AuthTokenRefreshFailed(event.message));
  }
  
  Future<void> _onAuthSessionExpired(
    events.AuthSessionExpired event,
    Emitter<states.AuthState> emit,
  ) async {
    // Clear all tokens and user data
    try {
      await _authRepository.clearAuthToken();
    } catch (e) {
      // Log error but continue with session expiration
    }
    
    emit(const states.AuthSessionExpired());
    
    // After a brief moment, transition to unauthenticated
    await Future.delayed(const Duration(milliseconds: 100));
    emit(const states.AuthUnauthenticated());
  }
  
  Future<void> _onAuthBiometricAuthRequested(
    events.AuthBiometricAuthRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(states.AuthBiometricAuthRequired(reason: event.reason));
  }

  Future<void> _onAuthEmailVerificationRequested(
    events.AuthEmailVerificationRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(const states.AuthEmailVerificationLoading());
    
    // For now, just emit success - in a real implementation,
    // you'd have an email verification use case
    emit(const states.AuthEmailVerificationSuccess());
  }

  Future<void> _onAuthPasswordResetRequested(
    events.AuthPasswordResetRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(const states.AuthPasswordResetLoading());
    
    // For now, just emit success - in a real implementation,
    // you'd have a password reset use case
    emit(const states.AuthPasswordResetSuccess());
  }

  Future<void> _onAuthPasswordResetConfirmRequested(
    events.AuthPasswordResetConfirmRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(const states.AuthPasswordResetConfirmLoading());
    
    // For now, just emit success - in a real implementation,
    // you'd have a password reset confirm use case
    emit(const states.AuthPasswordResetConfirmSuccess());
  }

  Future<void> _onAuthPasswordChangeRequested(
    events.AuthPasswordChangeRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(const states.AuthPasswordChangeLoading());
    
    // For now, just emit success - in a real implementation,
    // you'd have a password change use case
    emit(const states.AuthPasswordChangeSuccess());
  }

  Future<void> _onAuthProfileUpdateRequested(
    events.AuthProfileUpdateRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    emit(const states.AuthProfileUpdateLoading());
    
    final result = await _authRepository.updateProfile(
      name: event.name,
      phone: event.phone,
      avatar: event.avatar,
    );
    
    await result.fold(
      (failure) async {
        emit(states.AuthError(message: failure.message));
      },
      (user) async {
        emit(states.AuthProfileUpdateSuccess(user));
      },
    );
  }

  Future<void> _onAuthCurrentUserRequested(
    events.AuthCurrentUserRequested event,
    Emitter<states.AuthState> emit,
  ) async {
    final result = await _getCurrentUserUseCase();
    
    await result.fold(
        (failure) async {
          emit(states.AuthError(message: failure.message));
        },
      (user) async {
        final currentState = state;
        if (currentState is states.AuthAuthenticated) {
          emit(currentState.copyWith(user: user));
        } else {
          emit(states.AuthAuthenticated(
            user: user,
          ));
        }
      },
    );
  }

  Future<void> _onAuthErrorCleared(
    events.AuthErrorCleared event,
    Emitter<states.AuthState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is states.AuthError) {
      if (currentState.isAuthenticated && currentState.user != null) {
        emit(states.AuthAuthenticated(user: currentState.user!));
      } else {
        emit(const states.AuthUnauthenticated());
      }
    }
  }
}