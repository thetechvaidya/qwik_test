import 'dart:async';

/// Event bus for authentication-related events that need to be communicated
/// across different layers of the application (e.g., from network layer to BLoC layer)
class AuthEventBus {
  static final AuthEventBus _instance = AuthEventBus._internal();
  factory AuthEventBus() => _instance;
  AuthEventBus._internal();

  final StreamController<AuthBusEvent> _controller = StreamController<AuthBusEvent>.broadcast();

  /// Stream of authentication events
  Stream<AuthBusEvent> get events => _controller.stream;

  /// Emit an authentication event
  void emit(AuthBusEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Close the event bus (typically called when app is disposed)
  void dispose() {
    _controller.close();
  }
}

/// Base class for authentication bus events
abstract class AuthBusEvent {
  const AuthBusEvent();
}

/// Event emitted when token refresh starts
class TokenRefreshStarted extends AuthBusEvent {
  const TokenRefreshStarted();
}

/// Event emitted when token refresh succeeds
class TokenRefreshSucceeded extends AuthBusEvent {
  const TokenRefreshSucceeded();
}

/// Event emitted when token refresh fails
class TokenRefreshFailed extends AuthBusEvent {
  const TokenRefreshFailed(this.reason);
  
  final String reason;
}

/// Event emitted when session expires and user needs to re-authenticate
class SessionExpired extends AuthBusEvent {
  const SessionExpired(this.reason);
  
  final String reason;
}

/// Event emitted when authentication is required (e.g., 401 without refresh token)
class AuthenticationRequired extends AuthBusEvent {
  const AuthenticationRequired(this.reason);
  
  final String reason;
}