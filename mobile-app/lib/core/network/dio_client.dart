import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';
import '../storage/secure_token_storage.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import 'auth_interceptor.dart';

/// Dio client configuration for API requests
class DioClient {
  late final Dio _dio;
  final AuthInterceptor? _authInterceptor;

  DioClient({
    AuthInterceptor? authInterceptor,
  }) : _authInterceptor = authInterceptor {
    _dio = Dio();
    _configureDio();
    _addInterceptors();
  }

  Dio get dio => _dio;

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: '${AppConstants.baseUrl}${AppConstants.mobileApiPrefix}',
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout, // Add sendTimeout for v5 compatibility
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Version': AppConstants.apiVersion,
      },
    );
  }

  void _addInterceptors() {
    // Authentication interceptor
    if (_authInterceptor != null) {
      _dio.interceptors.add(_authInterceptor!);
    }

    // Logging interceptor for development
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          // Only log in debug mode
          assert(() {
            print(object);
            return true;
          }());
        },
      ),
    );
  }



  /// Handle Dio errors and convert them to app exceptions
  Exception handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response?.data, statusCode);
        return ServerException(message, code: statusCode);
      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');
      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');
      case DioExceptionType.badCertificate:
        return const NetworkException('Certificate error');
      case DioExceptionType.unknown:
      default:
        return NetworkException('Unknown error: ${error.message}');
    }
  }

  /// Extract error message from response data with type checking
  String _extractErrorMessage(dynamic data, int? statusCode) {
    // Handle Map response (most common API error format)
    if (data is Map<String, dynamic>) {
      // Try common error message fields
      if (data.containsKey('message') && data['message'] is String) {
        return data['message'] as String;
      }
      if (data.containsKey('error') && data['error'] is String) {
        return data['error'] as String;
      }
      if (data.containsKey('detail') && data['detail'] is String) {
        return data['detail'] as String;
      }
      // Handle nested error objects
      if (data.containsKey('error') && data['error'] is Map) {
        final errorObj = data['error'] as Map;
        if (errorObj.containsKey('message') && errorObj['message'] is String) {
          return errorObj['message'] as String;
        }
      }
      // Handle validation errors (array of errors)
      if (data.containsKey('errors') && data['errors'] is List) {
        final errors = data['errors'] as List;
        if (errors.isNotEmpty) {
          final firstError = errors.first;
          if (firstError is String) {
            return firstError;
          }
          if (firstError is Map && firstError.containsKey('message')) {
            return firstError['message'].toString();
          }
        }
      }
    }
    
    // Handle String response
    if (data is String && data.isNotEmpty) {
      return data;
    }
    
    // Fallback to generic messages based on status code
    return _getGenericErrorMessage(statusCode);
  }

  /// Get generic error message based on HTTP status code
  String _getGenericErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request - please check your input';
      case 401:
        return 'Authentication required';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 409:
        return 'Conflict - resource already exists';
      case 422:
        return 'Validation failed';
      case 429:
        return 'Too many requests - please try again later';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      case 504:
        return 'Gateway timeout';
      default:
        return 'Server error occurred';
    }
  }
}