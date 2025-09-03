/// Base class for all exceptions in the application
abstract class AppException implements Exception {
  final String message;
  final int? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(super.message, {super.code});

  @override
  String toString() => 'ServerException: $message (Code: $code)';
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException(String message, {int? code})
      : super(message, code: code);
}

class ForbiddenException extends ServerException {
  const ForbiddenException(String message, {int? code})
      : super(message, code: code);
}

class NotFoundException extends ServerException {
  const NotFoundException(String message, {int? code})
      : super(message, code: code);
}

class ConflictException extends ServerException {
  const ConflictException(String message, {int? code})
      : super(message, code: code);
}

class BadRequestException extends ServerException {
  const BadRequestException(String message, {int? code})
      : super(message, code: code);
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException(String message, {int? code})
      : super(message, code: code);
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});

  @override
  String toString() => 'NetworkException: $message (Code: $code)';
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException(super.message, {super.code});

  @override
  String toString() => 'CacheException: $message (Code: $code)';
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code});

  @override
  String toString() => 'AuthException: $message (Code: $code)';
}

/// Validation-related exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});

  @override
  String toString() => 'ValidationException: $message (Code: $code)';
}

/// Permission-related exceptions
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code});

  @override
  String toString() => 'PermissionException: $message (Code: $code)';
}

/// Authentication exceptions

/// File operation exceptions
class FileException extends AppException {
  const FileException(super.message, {super.code});

  @override
  String toString() => 'FileException: $message (Code: $code)';
}