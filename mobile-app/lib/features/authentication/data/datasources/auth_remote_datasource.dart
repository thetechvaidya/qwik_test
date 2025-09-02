import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/user_model.dart';
import '../models/auth_token_model.dart';

abstract class AuthRemoteDataSource {
  /// Login with email and password
  Future<AuthResponseModel> login(LoginRequestModel request);

  /// Register a new user
  Future<AuthResponseModel> register(RegisterRequestModel request);

  /// Logout the current user
  Future<void> logout();

  /// Get the current authenticated user
  Future<UserModel> getCurrentUser();

  /// Refresh auth token
  Future<AuthTokenModel> refreshToken(String refreshToken);

  /// Verify email
  Future<void> verifyEmail(String token);

  /// Request password reset
  Future<void> requestPasswordReset(String email);

  /// Reset password
  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });

  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Login failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        message: 'Unexpected error during login: $e',
      );
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Registration failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/register'),
        message: 'Unexpected error during registration: $e',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dio.post(ApiEndpoints.logout);

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Logout failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/logout'),
        message: 'Unexpected error during logout: $e',
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('data')) {
          return UserModel.fromJson(data['data'] as Map<String, dynamic>);
        } else {
          return UserModel.fromJson(data);
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Get user failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/user'),
        message: 'Unexpected error getting user: $e',
      );
    }
  }

  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('data')) {
          return AuthTokenModel.fromJson(data['data'] as Map<String, dynamic>);
        } else {
          return AuthTokenModel.fromJson(data);
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Token refresh failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        message: 'Unexpected error refreshing token: $e',
      );
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyEmail,
        data: {'token': token},
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Email verification failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/verify-email'),
        message: 'Unexpected error verifying email: $e',
      );
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Password reset request failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/password/reset-request'),
        message: 'Unexpected error requesting password reset: $e',
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Password reset failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/password/reset'),
        message: 'Unexpected error resetting password: $e',
      );
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Password change failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/password/change'),
        message: 'Unexpected error changing password: $e',
      );
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (avatar != null) data['avatar'] = avatar;

      final response = await _dio.put(
        ApiEndpoints.updateProfile,
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData.containsKey('data')) {
          return UserModel.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          return UserModel.fromJson(responseData);
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Profile update failed with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/profile'),
        message: 'Unexpected error updating profile: $e',
      );
    }
  }
}