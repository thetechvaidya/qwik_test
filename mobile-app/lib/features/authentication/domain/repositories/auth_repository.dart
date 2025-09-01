import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/auth_token.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  /// Logout the current user
  Future<Either<Failure, void>> logout();

  /// Get the current authenticated user
  Future<Either<Failure, User>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get stored auth token
  Future<AuthToken?> getAuthToken();

  /// Store auth token
  Future<void> storeAuthToken(AuthToken token);

  /// Clear stored auth token
  Future<void> clearAuthToken();

  /// Refresh auth token
  Future<Either<Failure, AuthToken>> refreshToken();

  /// Verify email
  Future<Either<Failure, void>> verifyEmail(String token);

  /// Request password reset
  Future<Either<Failure, void>> requestPasswordReset(String email);

  /// Reset password
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  });

}