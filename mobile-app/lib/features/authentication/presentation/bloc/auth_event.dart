import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication status on app start
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event to login with email and password
class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.deviceName,
  });

  final String email;
  final String password;
  final String? deviceName;

  @override
  List<Object?> get props => [email, password, deviceName];
}

/// Event to register a new user
class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.deviceName,
  });

  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? deviceName;

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        passwordConfirmation,
        deviceName,
      ];
}

/// Event to logout user
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event to refresh authentication token
class AuthTokenRefreshRequested extends AuthEvent {
  const AuthTokenRefreshRequested();
}

/// Event to verify email
class AuthEmailVerificationRequested extends AuthEvent {
  const AuthEmailVerificationRequested(this.token);

  final String token;

  @override
  List<Object?> get props => [token];
}

/// Event to request password reset
class AuthPasswordResetRequested extends AuthEvent {
  const AuthPasswordResetRequested(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Event to reset password with token
class AuthPasswordResetConfirmRequested extends AuthEvent {
  const AuthPasswordResetConfirmRequested({
    required this.token,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  final String token;
  final String email;
  final String password;
  final String passwordConfirmation;

  @override
  List<Object?> get props => [token, email, password, passwordConfirmation];
}

/// Event to change password
class AuthPasswordChangeRequested extends AuthEvent {
  const AuthPasswordChangeRequested({
    required this.currentPassword,
    required this.newPassword,
    required this.passwordConfirmation,
  });

  final String currentPassword;
  final String newPassword;
  final String passwordConfirmation;

  @override
  List<Object?> get props => [currentPassword, newPassword, passwordConfirmation];
}

/// Event to update user profile
class AuthProfileUpdateRequested extends AuthEvent {
  const AuthProfileUpdateRequested({
    this.name,
    this.email,
    this.phone,
    this.avatar,
  });

  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;

  @override
  List<Object?> get props => [name, email, phone, avatar];
}

/// Event to get current user data
class AuthCurrentUserRequested extends AuthEvent {
  const AuthCurrentUserRequested();
}

/// Event to clear authentication errors
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}

/// Event when token refresh fails
class AuthTokenRefreshFailed extends AuthEvent {
  const AuthTokenRefreshFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Event when session expires
class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}