import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}

/// Authentication failures

/// File operation failures
class FileFailure extends Failure {
  const FileFailure(super.message, {super.code});
}