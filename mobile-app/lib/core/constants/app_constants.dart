import '../config/environment_config.dart';

/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'QwikTest';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static String get baseUrl => EnvironmentConfig.baseUrl;
  static const String apiVersion = 'v1';
  static const String mobileApiPrefix = '/mobile';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  

  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 48.0;
  
  // Exam Constants
  static const int defaultExamTimeMinutes = 60;
  static const int questionsPerPage = 1;
  static const int maxRetryAttempts = 3;
  
  // Network
  static Duration get connectionTimeout => EnvironmentConfig.apiTimeout;
  static Duration get receiveTimeout => EnvironmentConfig.apiTimeout;
  static Duration get sendTimeout => EnvironmentConfig.apiTimeout;
}