import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../constants/app_constants.dart';
import '../utils/auth_utils.dart';
import '../../features/authentication/data/models/auth_token_model.dart';
import '../../features/authentication/domain/entities/auth_token.dart';
/// Enhanced secure token storage service with biometric authentication support
class SecureTokenStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _tokenExpirationKey = 'token_expiration';
  static const String _authTokenEntityKey = 'auth_token_json';
  
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Store raw token strings with expiration (backward-compatible method)
  Future<void> storeToken({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    DateTime? issuedAt,
    bool enableBiometric = false,
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
      
      // Enable biometric protection if requested and available
      if (enableBiometric) {
        await enableBiometricProtection();
      }
    } catch (e) {
      throw Exception('Failed to store token: $e');
    }
  }

  /// Store authentication token entity with optional biometric protection
  Future<void> storeAuthTokenEntity(AuthToken token, {bool enableBiometric = false}) async {
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
      
      // Enable biometric protection if requested and available
      if (enableBiometric) {
        await enableBiometricProtection();
      }
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

  /// Retrieve authentication token entity with biometric verification if enabled
  Future<AuthToken?> getAuthTokenEntity({bool requireBiometric = true}) async {
    try {
      // Check if biometric protection is enabled
      final biometricEnabled = await isBiometricProtectionEnabled();
      
      // Perform biometric authentication if enabled and required
      if (biometricEnabled && requireBiometric) {
        final authenticated = await _authenticateWithBiometrics();
        if (!authenticated) {
          throw Exception('Biometric authentication failed');
        }
      }
      
      final tokenJson = await _storage.read(key: _authTokenEntityKey);
      if (tokenJson == null) return null;
      
      final tokenData = jsonDecode(tokenJson) as Map<String, dynamic>;
      final token = AuthTokenModel.fromJson(tokenData);
      
      return token.toEntity();
    } catch (e) {
      throw Exception('Failed to retrieve token entity: $e');
    }
  }

  /// Retrieve authentication token with biometric verification if enabled (deprecated - use getAuthTokenEntity)
  @deprecated
  Future<AuthToken?> getToken({bool requireBiometric = true}) async {
    try {
      // Check if biometric protection is enabled
      final biometricEnabled = await isBiometricProtectionEnabled();
      
      // Perform biometric authentication if enabled and required
      if (biometricEnabled && requireBiometric) {
        final authenticated = await _authenticateWithBiometrics();
        if (!authenticated) {
          throw Exception('Biometric authentication failed');
        }
      }
      
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
          issuedAt = DateTime.now();
          expiresIn = expirationTime.difference(issuedAt).inSeconds;
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

  /// Clear all stored tokens and biometric settings
  Future<void> clearToken() async {
    try {
      await _storage.delete(key: AppConstants.accessTokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
      await _storage.delete(key: _authTokenEntityKey);
      await _storage.delete(key: _tokenExpirationKey);
      await _storage.delete(key: _biometricEnabledKey);
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

  /// Enable biometric protection for token access
  Future<bool> enableBiometricProtection() async {
    try {
      // Check if biometric authentication is available
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) return false;
      
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) return false;
      
      // Test biometric authentication
      final authenticated = await _authenticateWithBiometrics();
      if (!authenticated) return false;
      
      // Store biometric enabled flag
      await _storage.write(key: _biometricEnabledKey, value: 'true');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Disable biometric protection
  Future<void> disableBiometricProtection() async {
    try {
      await _storage.delete(key: _biometricEnabledKey);
    } catch (e) {
      throw Exception('Failed to disable biometric protection: $e');
    }
  }

  /// Check if biometric protection is enabled
  Future<bool> isBiometricProtectionEnabled() async {
    try {
      final enabled = await _storage.read(key: _biometricEnabledKey);
      return enabled == 'true';
    } catch (e) {
      return false;
    }
  }

  /// Check if biometric authentication is available on device
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) return false;
      
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Perform biometric authentication
  Future<bool> _authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
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