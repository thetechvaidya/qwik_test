import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when checking authentication status
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({
    required this.user,
  });

  final User user;

  @override
  List<Object?> get props => [user];

  AuthAuthenticated copyWith({
    User? user,
  }) {
    return AuthAuthenticated(
      user: user ?? this.user,
    );
  }
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when authentication operation fails
class AuthError extends AuthState {
  const AuthError({
    required this.message,
    this.isAuthenticated = false,
    this.user,
  });

  final String message;
  final bool isAuthenticated;
  final User? user;

  @override
  List<Object?> get props => [
        message,
        isAuthenticated,
        user,
      ];
}

/// State when login is in progress
class AuthLoginLoading extends AuthState {
  const AuthLoginLoading();
}

/// State when registration is in progress
class AuthRegisterLoading extends AuthState {
  const AuthRegisterLoading();
}

/// State when logout is in progress
class AuthLogoutLoading extends AuthState {
  const AuthLogoutLoading();
}

/// State when token refresh is in progress
class AuthTokenRefreshLoading extends AuthState {
  const AuthTokenRefreshLoading();
}

/// State when email verification is in progress
class AuthEmailVerificationLoading extends AuthState {
  const AuthEmailVerificationLoading();
}

/// State when email verification is successful
class AuthEmailVerificationSuccess extends AuthState {
  const AuthEmailVerificationSuccess();
}

/// State when password reset request is in progress
class AuthPasswordResetLoading extends AuthState {
  const AuthPasswordResetLoading();
}

/// State when password reset request is successful
class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

/// State when password reset confirmation is in progress
class AuthPasswordResetConfirmLoading extends AuthState {
  const AuthPasswordResetConfirmLoading();
}

/// State when password reset confirmation is successful
class AuthPasswordResetConfirmSuccess extends AuthState {
  const AuthPasswordResetConfirmSuccess();
}

/// State when password change is in progress
class AuthPasswordChangeLoading extends AuthState {
  const AuthPasswordChangeLoading();
}

/// State when password change is successful
class AuthPasswordChangeSuccess extends AuthState {
  const AuthPasswordChangeSuccess();
}

/// State when profile update is in progress
class AuthProfileUpdateLoading extends AuthState {
  const AuthProfileUpdateLoading();
}

/// State when profile update is successful
class AuthProfileUpdateSuccess extends AuthState {
  const AuthProfileUpdateSuccess(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

/// State when token refresh is successful
class AuthTokenRefreshSuccess extends AuthState {
  const AuthTokenRefreshSuccess();
}

/// State when token refresh fails
class AuthTokenRefreshFailed extends AuthState {
  const AuthTokenRefreshFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// State when session expires
class AuthSessionExpired extends AuthState {
  const AuthSessionExpired();
}

/// State when biometric authentication is required
class AuthBiometricAuthRequired extends AuthState {
  const AuthBiometricAuthRequired({
    this.reason = 'Please authenticate to continue',
  });

  final String reason;

  @override
  List<Object?> get props => [reason];
}