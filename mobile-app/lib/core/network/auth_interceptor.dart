import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/secure_token_storage.dart';
import '../events/auth_event_bus.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import 'api_endpoints.dart';

/// Dio interceptor for handling authentication tokens
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    Dio? dio,
    required SecureTokenStorage tokenStorage,
    required AuthLocalDataSource authLocalDataSource,
    required AuthRepository authRepository,
    required AuthEventBus eventBus,
  }) : _tokenStorage = tokenStorage,
       _authLocalDataSource = authLocalDataSource,
       _authRepository = authRepository,
       _eventBus = eventBus {
    if (dio != null) {
      _dio = dio;
    }
  }

  late final Dio _dio;

  /// Set the Dio instance after creation
  void setDio(Dio dio) {
    _dio = dio;
  }
  final SecureTokenStorage _tokenStorage;
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRepository _authRepository;
  final AuthEventBus _eventBus;

  // Track ongoing refresh requests to prevent multiple simultaneous refreshes
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];
  Completer<bool>? _refreshCompleter;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Skip adding token for auth endpoints or if explicitly marked to skip
      if (_isAuthEndpoint(options.path) || options.extra['skipAuthInterceptor'] == true) {
        handler.next(options);
        return;
      }

      // Get stored access token
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        
        if (kDebugMode) {
          debugPrint('AuthInterceptor: Added token to request ${options.path}');
        }
      }

      handler.next(options);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AuthInterceptor: Error adding token: $e');
      }
      handler.next(options);
    }
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized errors
    // Handle authentication-related errors: 401 (Unauthorized), 403 (Forbidden), 419 (Authentication Timeout)
    final statusCode = err.response?.statusCode;
    if (statusCode == 401 || statusCode == 403 || statusCode == 419) {
      if (kDebugMode) {
        debugPrint('AuthInterceptor: Authentication error $statusCode detected for ${err.requestOptions.path}');
      }

      // Check if this request has already been retried to prevent infinite loops
      if (err.requestOptions.extra['hasRetried'] == true) {
        if (kDebugMode) {
          debugPrint('AuthInterceptor: Request already retried, clearing tokens and failing');
        }
        // Clear tokens on repeated 401 errors
        await _clearTokensAndNotifyLogout();
        handler.next(err);
        return;
      }

      // Skip refresh for auth endpoints
      if (_isAuthEndpoint(err.requestOptions.path)) {
        handler.next(err);
        return;
      }

      // Check retry count to prevent excessive retries
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
      if (retryCount >= 2) {
        if (kDebugMode) {
          debugPrint('AuthInterceptor: Maximum retry attempts reached');
        }
        await _clearTokensAndNotifyLogout();
        handler.next(err);
        return;
      }

      // If refresh is already in progress, queue this request
      if (_isRefreshing && _refreshCompleter != null) {
        if (kDebugMode) {
          debugPrint('AuthInterceptor: Queueing request while refresh in progress');
        }
        _pendingRequests.add(_PendingRequest(err.requestOptions, handler));
        
        // Wait for refresh to complete
        final refreshed = await _refreshCompleter!.future;
        if (refreshed) {
          // Don't retry here, it will be handled by _retryPendingRequests
          return;
        } else {
          // Refresh failed, fail this request too
          handler.next(err);
          return;
        }
      }

      // Attempt token refresh
      final refreshed = await _attemptTokenRefresh();
      if (refreshed) {
        // Retry this request
        await _retryRequest(err.requestOptions, handler, retryCount);
      } else {
        // Token refresh failed, clear tokens
        await _clearTokensAndNotifyLogout();
        handler.next(err);
      }
      return;
    }

    handler.next(err);
  }

  /// Check if the endpoint is an authentication endpoint
  bool _isAuthEndpoint(String path) {
    final p = path.startsWith('/') ? path : '/$path';
    final authPaths = {
      ApiEndpoints.login,
      ApiEndpoints.register,
      ApiEndpoints.refreshToken,
      ApiEndpoints.logout,
      ApiEndpoints.profile,
      ApiEndpoints.verifyEmail,
      ApiEndpoints.forgotPassword,
      ApiEndpoints.resetPassword,
      ApiEndpoints.changePassword,
      ApiEndpoints.updateProfile
    };
    return authPaths.any((a) => p.startsWith(a));
  }

  /// Attempt to refresh the authentication token
  Future<bool> _attemptTokenRefresh() async {
    // Prevent multiple simultaneous refresh attempts
    if (_isRefreshing) {
      if (kDebugMode) {
        debugPrint('AuthInterceptor: Token refresh already in progress');
      }
      return _refreshCompleter?.future ?? Future.value(false);
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();
    
    try {
      if (kDebugMode) {
        debugPrint('AuthInterceptor: Attempting token refresh');
      }

      // Emit token refresh started event
      _eventBus.emit(const TokenRefreshStarted());

      // Check if we have a refresh token
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        if (kDebugMode) {
          debugPrint('AuthInterceptor: No refresh token available');
        }
        _eventBus.emit(const AuthenticationRequired('No refresh token available'));
        _refreshCompleter!.complete(false);
        await _failPendingRequests('No refresh token available');
        return false;
      }

      // Attempt refresh through repository
      final result = await _authRepository.refreshToken();
      
      return result.fold(
        (failure) {
          if (kDebugMode) {
            debugPrint('AuthInterceptor: Token refresh failed: ${failure.message}');
          }
          _eventBus.emit(TokenRefreshFailed(failure.message));
          _refreshCompleter!.complete(false);
          _failPendingRequests(failure.message);
          return false;
        },
        (newToken) {
          if (kDebugMode) {
            debugPrint('AuthInterceptor: Token refresh successful');
          }
          _eventBus.emit(const TokenRefreshSucceeded());
          _refreshCompleter!.complete(true);
          _retryPendingRequests();
          return true;
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AuthInterceptor: Token refresh error: $e');
      }
      _eventBus.emit(TokenRefreshFailed('Unexpected error: $e'));
      _refreshCompleter!.complete(false);
      await _failPendingRequests('Unexpected error: $e');
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  /// Clear all tokens and notify logout
  Future<void> _clearTokensAndNotifyLogout() async {
    try {
      if (kDebugMode) {
        debugPrint('AuthInterceptor: Clearing tokens due to authentication failure');
      }
      
      // Clear tokens from storage
      await _tokenStorage.clearToken();
      
      // Clear cached user data and auth token
      await _authLocalDataSource.clearAuthToken();
      await _authLocalDataSource.clearCachedUser();
      
      // Emit session expired event
      _eventBus.emit(const SessionExpired('Authentication failed - session expired'));
      
      if (kDebugMode) {
        debugPrint('AuthInterceptor: Tokens and user data cleared successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AuthInterceptor: Error clearing tokens: $e');
      }
    }
  }

  /// Retry a single request with new token
  Future<void> _retryRequest(RequestOptions requestOptions, ErrorInterceptorHandler handler, int retryCount) async {
    try {
      // Mark request as retried and increment retry count
      requestOptions.extra['hasRetried'] = true;
      requestOptions.extra['retryCount'] = retryCount + 1;
      
      final newToken = await _tokenStorage.getAccessToken();
      if (newToken != null && newToken.isNotEmpty) {
        // Rebuild Options with Authorization header
        final newHeaders = Map<String, dynamic>.from(requestOptions.headers);
        newHeaders['Authorization'] = 'Bearer $newToken';
        
        if (kDebugMode) {
          debugPrint('AuthInterceptor: Retrying request with new token (attempt ${retryCount + 1})');
        }
        
        // Clone request data properly
        dynamic clonedData = requestOptions.data;
        if (requestOptions.data is FormData) {
          final originalFormData = requestOptions.data as FormData;
          clonedData = FormData();
          for (final field in originalFormData.fields) {
            clonedData.fields.add(MapEntry(field.key, field.value));
          }
          for (final file in originalFormData.files) {
            clonedData.files.add(file);
          }
        }
        
        final response = await _dio.request(
          requestOptions.path,
          data: clonedData,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            method: requestOptions.method,
            headers: newHeaders,
            responseType: requestOptions.responseType,
            contentType: requestOptions.contentType,
            followRedirects: requestOptions.followRedirects,
            extra: {...requestOptions.extra, 'skipAuthInterceptor': true},
          ),
        );
        handler.resolve(response);
        return;
      }
    } catch (retryError) {
      if (kDebugMode) {
        debugPrint('AuthInterceptor: Retry failed: $retryError');
      }
    }
    
    // If we get here, retry failed
    handler.next(DioException(
      requestOptions: requestOptions,
      message: 'Token refresh succeeded but retry failed',
    ));
  }

  /// Retry all pending requests after successful token refresh
  Future<void> _retryPendingRequests() async {
    final requests = List<_PendingRequest>.from(_pendingRequests);
    _pendingRequests.clear();
    
    if (kDebugMode && requests.isNotEmpty) {
      debugPrint('AuthInterceptor: Retrying ${requests.length} pending requests');
    }
    
    for (final pendingRequest in requests) {
      final retryCount = pendingRequest.requestOptions.extra['retryCount'] ?? 0;
      await _retryRequest(pendingRequest.requestOptions, pendingRequest.handler, retryCount);
    }
  }

  /// Fail all pending requests after token refresh failure
  Future<void> _failPendingRequests(String reason) async {
    final requests = List<_PendingRequest>.from(_pendingRequests);
    _pendingRequests.clear();
    
    if (kDebugMode && requests.isNotEmpty) {
      debugPrint('AuthInterceptor: Failing ${requests.length} pending requests due to: $reason');
    }
    
    for (final pendingRequest in requests) {
      pendingRequest.handler.next(DioException(
        requestOptions: pendingRequest.requestOptions,
        message: 'Token refresh failed: $reason',
      ));
    }
  }
}

/// Helper class to store pending requests during token refresh
class _PendingRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;
  
  _PendingRequest(this.requestOptions, this.handler);
}