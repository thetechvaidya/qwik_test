import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_token_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    String? deviceName,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    try {
      final loginRequest = LoginRequestModel(
        email: email,
        password: password,
        deviceName: deviceName,
      );

      final authResponse = await _remoteDataSource.login(loginRequest);
      
      // Store token and user data locally
      await _localDataSource.storeAuthToken(authResponse.token);
      await _localDataSource.cacheUser(authResponse.user);

      return Right(authResponse.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceName,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final registerRequest = RegisterRequestModel(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        deviceName: deviceName,
      );

      final authResponse = await _remoteDataSource.register(registerRequest);
      
      // Store token and user data locally
      await _localDataSource.storeAuthToken(authResponse.token);
      await _localDataSource.cacheUser(authResponse.user);

      return Right(authResponse.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Try to logout from server if connected
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.logout();
        } catch (e) {
          // Continue with local logout even if server logout fails
        }
      }

      // Clear local data
      await _localDataSource.clearAuthToken();
      await _localDataSource.clearCachedUser();

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // First try to get cached user
      final cachedUser = await _localDataSource.getCachedUser();
      
      if (cachedUser != null && !await _networkInfo.isConnected) {
        return Right(cachedUser);
      }

      // If connected, try to get fresh user data
      if (await _networkInfo.isConnected) {
        try {
          final user = await _remoteDataSource.getCurrentUser();
          await _localDataSource.cacheUser(user);
          return Right(user);
        } on ServerException catch (e) {
          // If server fails but we have cached data, return cached
          if (cachedUser != null) {
            return Right(cachedUser);
          }
          return Left(ServerFailure(e.message));
        }
      }

      // No cached user and no connection
      if (cachedUser == null) {
        return Left(CacheFailure('No user data available'));
      }

      return Right(cachedUser);
    } catch (e) {
      return Left(CacheFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> refreshToken() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final currentToken = await _localDataSource.getAuthToken();
      if (currentToken == null) {
        return Left(CacheFailure('No token to refresh'));
      }

      final newToken = await _remoteDataSource.refreshToken(currentToken.refreshToken);
      await _localDataSource.storeAuthToken(newToken);

      return Right(newToken);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Token refresh failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.verifyEmail(token);
      
      // Update cached user if available
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        final updatedUser = cachedUser.copyWith(isEmailVerified: true);
        await _localDataSource.cacheUser(updatedUser);
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Email verification failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.requestPasswordReset(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Password reset request failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.resetPassword(
        token: token,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Password reset failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Password change failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatar,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final updatedUser = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        avatar: avatar,
      );
      
      // Update cached user
      await _localDataSource.cacheUser(updatedUser);

      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Profile update failed: ${e.toString()}'));
    }
  }



  @override
  Future<bool> isAuthenticated() async {
    try {
      return await _localDataSource.isAuthenticated();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthToken?> getAuthToken() async {
    try {
      return await _localDataSource.getAuthToken();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> storeAuthToken(AuthToken token) async {
    try {
      await _localDataSource.storeAuthToken(AuthTokenModel.fromEntity(token));
    } catch (e) {
      throw CacheException('Failed to store auth token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await _localDataSource.clearAuthToken();
    } catch (e) {
      throw CacheException('Failed to clear auth token: ${e.toString()}');
    }
  }

}

// Custom exceptions for the data layer
class ServerException implements Exception {
  const ServerException(this.message);
  final String message;
}

class CacheException implements Exception {
  const CacheException(this.message);
  final String message;
}