import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../utils/auth_utils.dart';
import '../../features/authentication/data/models/auth_token_model.dart';
import '../../features/authentication/domain/entities/auth_token.dart';
/// Secure token storage service
class SecureTokenStorage {
  final FlutterSecureStorage _storage;

  SecureTokenStorage({required FlutterSecureStorage storage}) : _storage = storage;

  static const String _tokenExpirationKey = 'token_expiration';
  static const String _authTokenEntityKey = 'auth_token_json';

  /// Store raw token strings with expiration (backward-compatible method)
  Future<void> storeToken({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    DateTime? issuedAt,
  }) async {
    try {
      // Calculate expiration timestamp
      final expirationTime = (issuedAt ?? DateTime.now())
          .add(Duration(seconds: expiresIn));
      
      // Store raw access token string
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: accessToken,
      );
      
      // Store refresh token
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: refreshToken,
      );
      
      // Store expiration timestamp
      await _storage.write(
        key: _tokenExpirationKey,
        value: expirationTime.millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      throw Exception('Failed to store token: $e');
    }
  }

  /// Store authentication token entity
  Future<void> storeAuthTokenEntity(AuthToken token) async {
    try {
      final tokenModel = AuthTokenModel.fromEntity(token);
      final tokenJson = jsonEncode(tokenModel.toJson());
      
      // Calculate expiration timestamp
      final expirationTime = (token.issuedAt ?? DateTime.now())
          .add(Duration(seconds: token.expiresIn));
      
      // Store entity as JSON
      await _storage.write(
        key: _authTokenEntityKey,
        value: tokenJson,
      );
      
      // Also store raw tokens for backward compatibility
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: token.accessToken,
      );
      
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: token.refreshToken,
      );
      
      // Store expiration timestamp
      await _storage.write(
        key: _tokenExpirationKey,
        value: expirationTime.millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      throw Exception('Failed to store token: $e');
    }
  }

  /// Get raw access token string
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: AppConstants.accessTokenKey);
    } catch (e) {
      throw Exception('Failed to retrieve access token: $e');
    }
  }

  /// Retrieve authentication token entity
  Future<AuthToken?> getAuthTokenEntity() async {
    try {
      final tokenJson = await _storage.read(key: _authTokenEntityKey);
      if (tokenJson == null) return null;
      
      final tokenData = jsonDecode(tokenJson) as Map<String, dynamic>;
      final token = AuthTokenModel.fromJson(tokenData);
      
      return token.toEntity();
    } catch (e) {
      throw Exception('Failed to retrieve token entity: $e');
    }
  }

  /// Retrieve authentication token (deprecated - use getAuthTokenEntity)
  @deprecated
  Future<AuthToken?> getToken() async {
    try {
      // Try to get from entity storage first, fallback to legacy method
      final tokenJson = await _storage.read(key: _authTokenEntityKey);
      if (tokenJson != null) {
        final tokenData = jsonDecode(tokenJson) as Map<String, dynamic>;
        final token = AuthTokenModel.fromJson(tokenData);
        return token.toEntity();
      }
      
      // Fallback: try to reconstruct from individual stored values
      final accessToken = await _storage.read(key: AppConstants.accessTokenKey);
      final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
      final expirationString = await _storage.read(key: _tokenExpirationKey);
      
      if (accessToken == null || refreshToken == null) return null;
      
      // Calculate expiresIn from stored expiration time
      int expiresIn = 3600; // Default 1 hour
      DateTime? issuedAt;
      
      if (expirationString != null) {
        try {
          final expirationTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(expirationString),
          );
          final now = DateTime.now();
          
          // For backward compatibility, estimate original issue time
          // by subtracting a reasonable token lifetime from expiration
          issuedAt = expirationTime.subtract(Duration(seconds: 3600)); // Assume 1 hour lifetime
          
          // Calculate remaining time until expiration
          final remainingTime = expirationTime.difference(now).inSeconds;
          expiresIn = remainingTime > 0 ? remainingTime : 0;
        } catch (e) {
          // Use default values if parsing fails
        }
      }
      
      return AuthToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: 'Bearer',
        expiresIn: expiresIn,
        issuedAt: issuedAt ?? DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to retrieve token: $e');
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: AppConstants.refreshTokenKey);
    } catch (e) {
      throw Exception('Failed to retrieve refresh token: $e');
    }
  }

  /// Clear all stored tokens
  Future<void> clearToken() async {
    try {
      await _storage.delete(key: AppConstants.accessTokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
      await _storage.delete(key: _authTokenEntityKey);
      await _storage.delete(key: _tokenExpirationKey);
    } catch (e) {
      throw Exception('Failed to clear tokens: $e');
    }
  }

  /// Check if stored token is valid (not expired)
  Future<bool> isTokenValid() async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null || accessToken.isEmpty) return false;
      
      // First try to use stored expiration timestamp
      final storedExpiration = await getTokenExpirationTime();
      if (storedExpiration != null) {
        return DateTime.now().isBefore(storedExpiration);
      }
      
      // Fallback to JWT decoding for opaque tokens
      return !AuthUtils.isTokenExpired(accessToken);
    } catch (e) {
      return false;
    }
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    try {
      final token = await _storage.read(key: AppConstants.accessTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }



  /// Get token expiration time
  Future<DateTime?> getTokenExpirationTime() async {
    try {
      final expirationString = await _storage.read(key: _tokenExpirationKey);
      if (expirationString == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(
        int.parse(expirationString),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get time until token expires
  Future<Duration?> getTimeUntilExpiration() async {
    try {
      final expirationTime = await getTokenExpirationTime();
      if (expirationTime == null) return null;
      
      final now = DateTime.now();
      if (expirationTime.isBefore(now)) return Duration.zero;
      
      return expirationTime.difference(now);
    } catch (e) {
      return null;
    }
  }

  /// Check if token needs refresh (within 10 minutes of expiration)
  Future<bool> needsRefresh() async {
    try {
      // First check if we have a token at all
      final hasToken = await this.hasToken();
      if (!hasToken) {
        return true; // No token means refresh is needed
      }
      
      final accessToken = await getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        return true; // No token means refresh is needed
      }
      
      // First try to use stored expiration timestamp
      final storedExpiration = await getTokenExpirationTime();
      if (storedExpiration != null) {
        final now = DateTime.now();
        final timeUntilExpiration = storedExpiration.difference(now);
        return timeUntilExpiration <= const Duration(minutes: 10);
      }
      
      // Fallback to JWT decoding for opaque tokens
      return AuthUtils.needsRefresh(accessToken, threshold: const Duration(minutes: 10));
    } catch (e) {
      // Any error in checking expiration should default to requiring refresh
      // This is safer than assuming the token is still valid
      return true;
    }
  }
}