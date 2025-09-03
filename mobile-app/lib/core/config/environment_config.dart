import 'package:flutter/foundation.dart';

/// Environment configuration for the application
class EnvironmentConfig {
  static const String _defaultBaseUrl = 'https://api.qwiktest.com';
  static const String _devBaseUrl = 'https://dev-api.qwiktest.com';
  static const String _stagingBaseUrl = 'https://staging-api.qwiktest.com';
  
  /// Get the base URL based on the current environment
  static String get baseUrl {
    // Check for environment variable first
    const envBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }
    
    // Fallback to build mode detection
    if (kDebugMode) {
      return _devBaseUrl;
    } else if (kProfileMode) {
      return _stagingBaseUrl;
    } else {
      return _defaultBaseUrl;
    }
  }
  
  /// Check if running in development environment
  static bool get isDevelopment => kDebugMode;
  
  /// Check if running in staging environment
  static bool get isStaging => kProfileMode;
  
  /// Check if running in production environment
  static bool get isProduction => kReleaseMode;
  
  /// Get environment name
  static String get environmentName {
    if (isDevelopment) return 'development';
    if (isStaging) return 'staging';
    return 'production';
  }
  
  /// Enable debug logging based on environment
  static bool get enableDebugLogging => isDevelopment || isStaging;
  
  /// API timeout configuration based on environment
  static Duration get apiTimeout {
    if (isDevelopment) {
      return const Duration(seconds: 60); // Longer timeout for development
    }
    return const Duration(seconds: 30);
  }
}