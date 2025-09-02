import 'package:dio/dio.dart';
import '../models/user_settings_model.dart';
import '../models/notification_settings_model.dart';
import '../models/app_preferences_model.dart';
import '../models/offline_preferences_model.dart';

abstract class SettingsRemoteDataSource {
  /// Get user settings
  Future<UserSettingsModel> getUserSettings(String userId);

  /// Update user settings
  Future<UserSettingsModel> updateUserSettings(UserSettingsModel settings);

  /// Get notification settings
  Future<NotificationSettingsModel> getNotificationSettings(String userId);

  /// Update notification settings
  Future<NotificationSettingsModel> updateNotificationSettings(NotificationSettingsModel settings);

  /// Get app preferences
  Future<AppPreferencesModel> getAppPreferences(String userId);

  /// Update app preferences
  Future<AppPreferencesModel> updateAppPreferences(AppPreferencesModel preferences);

  /// Get offline preferences
  Future<OfflinePreferencesModel> getOfflinePreferences(String userId);

  /// Update offline preferences
  Future<OfflinePreferencesModel> updateOfflinePreferences(OfflinePreferencesModel preferences);

  /// Reset settings to default
  Future<UserSettingsModel> resetSettingsToDefault(String userId);

  /// Export user settings
  Future<Map<String, dynamic>> exportUserSettings(String userId);

  /// Import user settings
  Future<UserSettingsModel> importUserSettings(String userId, Map<String, dynamic> settingsData);

  /// Get available themes
  Future<List<Map<String, dynamic>>> getAvailableThemes();

  /// Get available languages
  Future<List<Map<String, dynamic>>> getAvailableLanguages();

  /// Get privacy policy version
  Future<Map<String, dynamic>> getPrivacyPolicyVersion();

  /// Get terms of service version
  Future<Map<String, dynamic>> getTermsOfServiceVersion();

  /// Update privacy consent
  Future<void> updatePrivacyConsent(String userId, Map<String, bool> consents);

  /// Get data usage statistics
  Future<Map<String, dynamic>> getDataUsageStatistics(String userId);

  /// Request data export
  Future<Map<String, dynamic>> requestDataExport(String userId);

  /// Request account deletion
  Future<void> requestAccountDeletion(String userId, String reason);

  /// Sync settings across devices
  Future<UserSettingsModel> syncSettingsAcrossDevices(String userId);

  /// Get device-specific settings
  Future<Map<String, dynamic>> getDeviceSpecificSettings(String userId, String deviceId);

  /// Update device-specific settings
  Future<void> updateDeviceSpecificSettings(String userId, String deviceId, Map<String, dynamic> settings);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  const SettingsRemoteDataSourceImpl({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  @override
  Future<UserSettingsModel> getUserSettings(String userId) async {
    try {
      final response = await _dio.get('/api/v1/users/$userId/settings');
      
      if (response.statusCode == 200) {
        return UserSettingsModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get user settings',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/settings'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<UserSettingsModel> updateUserSettings(UserSettingsModel settings) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/${settings.userId}/settings',
        data: settings.toJson(),
      );
      
      if (response.statusCode == 200) {
        return UserSettingsModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update user settings',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/${settings.userId}/settings'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<NotificationSettingsModel> getNotificationSettings(String userId) async {
    try {
      final response = await _dio.get('/api/v1/users/$userId/settings/notifications');
      
      if (response.statusCode == 200) {
        return NotificationSettingsModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get notification settings',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/settings/notifications'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<NotificationSettingsModel> updateNotificationSettings(NotificationSettingsModel settings) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/${settings.userId}/settings/notifications',
        data: settings.toJson(),
      );
      
      if (response.statusCode == 200) {
        return NotificationSettingsModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update notification settings',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/${settings.userId}/settings/notifications'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<AppPreferencesModel> getAppPreferences(String userId) async {
    try {
      final response = await _dio.get('/api/v1/users/$userId/settings/preferences');
      
      if (response.statusCode == 200) {
        return AppPreferencesModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get app preferences',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/settings/preferences'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<AppPreferencesModel> updateAppPreferences(AppPreferencesModel preferences) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/${preferences.userId}/settings/preferences',
        data: preferences.toJson(),
      );
      
      if (response.statusCode == 200) {
        return AppPreferencesModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update app preferences',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/${preferences.userId}/settings/preferences'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<OfflinePreferencesModel> getOfflinePreferences(String userId) async {
    try {
      final response = await _dio.get('/api/v1/users/$userId/settings/offline');
      
      if (response.statusCode == 200) {
        return OfflinePreferencesModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get offline preferences',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/settings/offline'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<OfflinePreferencesModel> updateOfflinePreferences(OfflinePreferencesModel preferences) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/${preferences.userId}/settings/offline',
        data: preferences.toJson(),
      );
      
      if (response.statusCode == 200) {
        return OfflinePreferencesModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update offline preferences',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/${preferences.userId}/settings/offline'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<UserSettingsModel> resetSettingsToDefault(String userId) async {
    try {
      final response = await _dio.post('/api/v1/users/$userId/settings/reset');
      
      if (response.statusCode == 200) {
        return UserSettingsModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to reset settings to default',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/settings/reset'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> exportUserSettings(String userId) async {
    try {
      final response = await _dio.get('/api/v1/users/$userId/settings/export');
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to export user settings',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/settings/export'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<UserSettingsModel> importUserSettings(String userId, Map<String, dynamic> settingsData) async {
    try {
      final response = await _dio.post(
        '/api/v1/users/$userId/settings/import',
        data: settingsData,
      );
      
      if (response.statusCode == 200) {
        return UserSettingsModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to import user settings',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/settings/import'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableThemes() async {
    try {
      final response = await _dio.get('/api/v1/settings/themes');
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get available themes',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/settings/themes'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableLanguages() async {
    try {
      final response = await _dio.get('/api/v1/settings/languages');
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get available languages',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/settings/languages'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getPrivacyPolicyVersion() async {
    try {
      final response = await _dio.get('/api/v1/legal/privacy-policy/version');
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get privacy policy version',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/legal/privacy-policy/version'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getTermsOfServiceVersion() async {
    try {
      final response = await _dio.get('/api/v1/legal/terms-of-service/version');
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get terms of service version',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/legal/terms-of-service/version'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<void> updatePrivacyConsent(String userId, Map<String, bool> consents) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/$userId/privacy/consent',
        data: {'consents': consents},
      );
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update privacy consent',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/privacy/consent'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getDataUsageStatistics(String userId) async {
    try {
      final response = await _dio.get('/api/v1/users/$userId/data-usage');
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get data usage statistics',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/data-usage'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> requestDataExport(String userId) async {
    try {
      final response = await _dio.post('/api/v1/users/$userId/data-export');
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to request data export',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/data-export'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<void> requestAccountDeletion(String userId, String reason) async {
    try {
      final response = await _dio.post(
        '/api/v1/users/$userId/delete-account',
        data: {'reason': reason},
      );
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to request account deletion',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/delete-account'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<UserSettingsModel> syncSettingsAcrossDevices(String userId) async {
    try {
      final response = await _dio.post('/api/v1/users/$userId/settings/sync');
      
      if (response.statusCode == 200) {
        return UserSettingsModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to sync settings across devices',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/settings/sync'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getDeviceSpecificSettings(String userId, String deviceId) async {
    try {
      final response = await _dio.get('/api/v1/users/$userId/devices/$deviceId/settings');
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get device-specific settings',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/devices/$deviceId/settings'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<void> updateDeviceSpecificSettings(String userId, String deviceId, Map<String, dynamic> settings) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/$userId/devices/$deviceId/settings',
        data: settings,
      );
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update device-specific settings',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/$userId/devices/$deviceId/settings'),
        message: 'Unexpected error: $e',
      );
    }
  }
}