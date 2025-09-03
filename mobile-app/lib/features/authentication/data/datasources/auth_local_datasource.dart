import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import '../../../../core/storage/secure_token_storage.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Get stored auth token
  Future<AuthTokenModel?> getAuthToken();

  /// Store auth token
  Future<void> storeAuthToken(AuthTokenModel token);

  /// Clear stored auth token
  Future<void> clearAuthToken();

  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Cache user data
  Future<void> cacheUser(UserModel user);

  /// Clear cached user
  Future<void> clearCachedUser();

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl({
    required SecureTokenStorage tokenStorage,
    required Box<dynamic> hiveBox,
  })
      : _tokenStorage = tokenStorage,
        _hiveBox = hiveBox;

  final SecureTokenStorage _tokenStorage;
  final Box<dynamic> _hiveBox;

  static const String _userKey = 'cached_user';


  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await getAuthToken();
      if (token == null) return false;
      
      // Check if token is expired
      return !token.isExpired;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) {
    return _hiveBox.put(_userKey, user);
  }

  @override
  Future<void> clearAuthToken() {
    return _tokenStorage.clearToken();
  }

  @override
  Future<void> clearCachedUser() {
    return _hiveBox.delete(_userKey);
  }

  @override
  Future<AuthTokenModel?> getAuthToken() async {
    try {
      // Try to get the full token entity first
      final tokenEntity = await _tokenStorage.getAuthTokenEntity();
      if (tokenEntity != null) {
        return AuthTokenModel.fromEntity(tokenEntity);
      }
      
      // Fallback: reconstruct from individual stored values
      final accessToken = await _tokenStorage.getAccessToken();
      final refreshToken = await _tokenStorage.getRefreshToken();
      
      if (accessToken != null && refreshToken != null) {
        // Get token expiration info if available
        final expirationTime = await _tokenStorage.getTokenExpirationTime();
        
        // Calculate expiresIn and issuedAt based on expiration time
        int expiresIn = 3600; // Default 1 hour
        DateTime? issuedAt;
        
        if (expirationTime != null) {
          final timeUntilExpiration = await _tokenStorage.getTimeUntilExpiration();
          if (timeUntilExpiration != null) {
            expiresIn = timeUntilExpiration.inSeconds;
            issuedAt = expirationTime.subtract(Duration(seconds: expiresIn));
          }
        }
        
        return AuthTokenModel(
          accessToken: accessToken,
          refreshToken: refreshToken,
          tokenType: 'Bearer',
          expiresIn: expiresIn,
          issuedAt: issuedAt,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    return _hiveBox.get(_userKey) as UserModel?;
  }

  @override
  Future<void> storeAuthToken(AuthTokenModel token) async {
    // Store both the entity and raw tokens for backward compatibility
    await _tokenStorage.storeAuthTokenEntity(token.toEntity());
    
    // Also store raw tokens using the backward-compatible method
    await _tokenStorage.storeToken(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      expiresIn: token.expiresIn,
      issuedAt: token.issuedAt,
    );
  }
}