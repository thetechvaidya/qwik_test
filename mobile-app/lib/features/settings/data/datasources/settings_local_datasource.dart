import 'package:hive/hive.dart';
import '../models/user_settings_model.dart';
import '../models/notification_settings_model.dart';
import '../models/app_preferences_model.dart';


abstract class SettingsLocalDataSource {
  /// Get cached user settings
  Future<UserSettingsModel?> getCachedUserSettings(String userId);

  /// Cache user settings
  Future<void> cacheUserSettings(UserSettingsModel settings);

  /// Clear cached user settings
  Future<void> clearCachedUserSettings(String userId);



  /// Get cached app preferences
  Future<AppPreferencesModel?> getCachedAppPreferences(String userId);

  /// Cache app preferences
  Future<void> cacheAppPreferences(AppPreferencesModel preferences);

  /// Clear cached app preferences
  Future<void> clearCachedAppPreferences(String userId);



  /// Get cached available themes
  Future<List<Map<String, dynamic>>?> getCachedAvailableThemes();

  /// Cache available themes
  Future<void> cacheAvailableThemes(List<Map<String, dynamic>> themes);

  /// Clear cached available themes
  Future<void> clearCachedAvailableThemes();

  /// Get cached available languages
  Future<List<Map<String, dynamic>>?> getCachedAvailableLanguages();

  /// Cache available languages
  Future<void> cacheAvailableLanguages(List<Map<String, dynamic>> languages);

  /// Clear cached available languages
  Future<void> clearCachedAvailableLanguages();

  /// Get cached privacy policy version
  Future<Map<String, dynamic>?> getCachedPrivacyPolicyVersion();

  /// Cache privacy policy version
  Future<void> cachePrivacyPolicyVersion(Map<String, dynamic> version);

  /// Clear cached privacy policy version
  Future<void> clearCachedPrivacyPolicyVersion();

  /// Get cached terms of service version
  Future<Map<String, dynamic>?> getCachedTermsOfServiceVersion();

  /// Cache terms of service version
  Future<void> cacheTermsOfServiceVersion(Map<String, dynamic> version);

  /// Clear cached terms of service version
  Future<void> clearCachedTermsOfServiceVersion();

  /// Get cached data usage statistics
  Future<Map<String, dynamic>?> getCachedDataUsageStatistics(String userId);

  /// Cache data usage statistics
  Future<void> cacheDataUsageStatistics(String userId, Map<String, dynamic> statistics);

  /// Clear cached data usage statistics
  Future<void> clearCachedDataUsageStatistics(String userId);

  /// Get cached device-specific settings
  Future<Map<String, dynamic>?> getCachedDeviceSpecificSettings(String userId, String deviceId);

  /// Cache device-specific settings
  Future<void> cacheDeviceSpecificSettings(String userId, String deviceId, Map<String, dynamic> settings);

  /// Clear cached device-specific settings
  Future<void> clearCachedDeviceSpecificSettings(String userId, String deviceId);

  /// Clear all cached settings data
  Future<void> clearAllCachedData();

  /// Check if settings data is cached and fresh
  Future<bool> isSettingsDataFresh(String userId, {Duration maxAge = const Duration(hours: 1)});



  /// Check if app preferences data is cached and fresh
  Future<bool> isAppPreferencesDataFresh(String userId, {Duration maxAge = const Duration(hours: 2)});


}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl({
    required Box<dynamic> hiveBox,
  }) : _hiveBox = hiveBox;

  final Box<dynamic> _hiveBox;

  // Cache keys
  static const String _userSettingsPrefix = 'user_settings_';
  static const String _preferencesPrefix = 'app_preferences_';
  static const String _offlinePrefix = 'offline_preferences_';
  static const String _themesKey = 'available_themes';
  static const String _languagesKey = 'available_languages';
  static const String _privacyPolicyKey = 'privacy_policy_version';
  static const String _termsOfServiceKey = 'terms_of_service_version';
  static const String _dataUsagePrefix = 'data_usage_';
  static const String _deviceSettingsPrefix = 'device_settings_';
  static const String _timestampSuffix = '_timestamp';

  @override
  Future<UserSettingsModel?> getCachedUserSettings(String userId) async {
    try {
      final key = '$_userSettingsPrefix$userId';
      return _hiveBox.get(key) as UserSettingsModel?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUserSettings(UserSettingsModel settings) async {
    try {
      final key = '$_userSettingsPrefix${settings.userId}';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, settings);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedUserSettings(String userId) async {
    try {
      final key = '$_userSettingsPrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }



  @override
  Future<AppPreferencesModel?> getCachedAppPreferences(String userId) async {
    try {
      final key = '$_preferencesPrefix$userId';
      return _hiveBox.get(key) as AppPreferencesModel?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheAppPreferences(AppPreferencesModel preferences) async {
    try {
      final key = '$_preferencesPrefix${preferences.userId}';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, preferences);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedAppPreferences(String userId) async {
    try {
      final key = '$_preferencesPrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }



  @override
  Future<List<Map<String, dynamic>>?> getCachedAvailableThemes() async {
    try {
      final cached = _hiveBox.get(_themesKey);
      if (cached is List) {
        return List<Map<String, dynamic>>.from(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheAvailableThemes(List<Map<String, dynamic>> themes) async {
    try {
      final timestampKey = '$_themesKey$_timestampSuffix';
      
      await _hiveBox.put(_themesKey, themes);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedAvailableThemes() async {
    try {
      final timestampKey = '$_themesKey$_timestampSuffix';
      
      await _hiveBox.delete(_themesKey);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<List<Map<String, dynamic>>?> getCachedAvailableLanguages() async {
    try {
      final cached = _hiveBox.get(_languagesKey);
      if (cached is List) {
        return List<Map<String, dynamic>>.from(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheAvailableLanguages(List<Map<String, dynamic>> languages) async {
    try {
      final timestampKey = '$_languagesKey$_timestampSuffix';
      
      await _hiveBox.put(_languagesKey, languages);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedAvailableLanguages() async {
    try {
      final timestampKey = '$_languagesKey$_timestampSuffix';
      
      await _hiveBox.delete(_languagesKey);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedPrivacyPolicyVersion() async {
    try {
      final cached = _hiveBox.get(_privacyPolicyKey);
      if (cached is Map) {
        return Map<String, dynamic>.from(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cachePrivacyPolicyVersion(Map<String, dynamic> version) async {
    try {
      final timestampKey = '$_privacyPolicyKey$_timestampSuffix';
      
      await _hiveBox.put(_privacyPolicyKey, version);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedPrivacyPolicyVersion() async {
    try {
      final timestampKey = '$_privacyPolicyKey$_timestampSuffix';
      
      await _hiveBox.delete(_privacyPolicyKey);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedTermsOfServiceVersion() async {
    try {
      final cached = _hiveBox.get(_termsOfServiceKey);
      if (cached is Map) {
        return Map<String, dynamic>.from(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheTermsOfServiceVersion(Map<String, dynamic> version) async {
    try {
      final timestampKey = '$_termsOfServiceKey$_timestampSuffix';
      
      await _hiveBox.put(_termsOfServiceKey, version);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedTermsOfServiceVersion() async {
    try {
      final timestampKey = '$_termsOfServiceKey$_timestampSuffix';
      
      await _hiveBox.delete(_termsOfServiceKey);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedDataUsageStatistics(String userId) async {
    try {
      final key = '$_dataUsagePrefix$userId';
      final cached = _hiveBox.get(key);
      if (cached is Map) {
        return Map<String, dynamic>.from(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheDataUsageStatistics(String userId, Map<String, dynamic> statistics) async {
    try {
      final key = '$_dataUsagePrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, statistics);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedDataUsageStatistics(String userId) async {
    try {
      final key = '$_dataUsagePrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedDeviceSpecificSettings(String userId, String deviceId) async {
    try {
      final key = '$_deviceSettingsPrefix${userId}_$deviceId';
      final cached = _hiveBox.get(key);
      if (cached is Map) {
        return Map<String, dynamic>.from(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheDeviceSpecificSettings(String userId, String deviceId, Map<String, dynamic> settings) async {
    try {
      final key = '$_deviceSettingsPrefix${userId}_$deviceId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, settings);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedDeviceSpecificSettings(String userId, String deviceId) async {
    try {
      final key = '$_deviceSettingsPrefix${userId}_$deviceId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<void> clearAllCachedData() async {
    try {
      final keysToDelete = <String>[];
      
      for (final key in _hiveBox.keys) {
        if (key is String && (
          key.startsWith(_userSettingsPrefix) ||
          key.startsWith(_preferencesPrefix) ||
          key.startsWith(_offlinePrefix) ||
          key.startsWith(_dataUsagePrefix) ||
          key.startsWith(_deviceSettingsPrefix) ||
          key == _themesKey ||
          key == _languagesKey ||
          key == _privacyPolicyKey ||
          key == _termsOfServiceKey ||
          key.endsWith(_timestampSuffix)
        )) {
          keysToDelete.add(key);
        }
      }
      
      await _hiveBox.deleteAll(keysToDelete);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<bool> isSettingsDataFresh(String userId, {Duration maxAge = const Duration(hours: 1)}) async {
    try {
      final key = '$_userSettingsPrefix$userId$_timestampSuffix';
      final timestamp = _hiveBox.get(key) as int?;
      
      if (timestamp == null) return false;
      
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      
      return now.difference(cachedTime) <= maxAge;
    } catch (e) {
      return false;
    }
  }



  @override
  Future<bool> isAppPreferencesDataFresh(String userId, {Duration maxAge = const Duration(hours: 2)}) async {
    try {
      final key = '$_preferencesPrefix$userId$_timestampSuffix';
      final timestamp = _hiveBox.get(key) as int?;
      
      if (timestamp == null) return false;
      
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      
      return now.difference(cachedTime) <= maxAge;
    } catch (e) {
      return false;
    }
  }



  /// Helper method to check if any cached data is fresh
  Future<bool> _isDataFresh(String key, Duration maxAge) async {
    try {
      final timestampKey = '$key$_timestampSuffix';
      final timestamp = _hiveBox.get(timestampKey) as int?;
      
      if (timestamp == null) return false;
      
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      
      return now.difference(cachedTime) <= maxAge;
    } catch (e) {
      return false;
    }
  }

  /// Check if themes data is fresh
  Future<bool> isThemesDataFresh({Duration maxAge = const Duration(days: 1)}) async {
    return _isDataFresh(_themesKey, maxAge);
  }

  /// Check if languages data is fresh
  Future<bool> isLanguagesDataFresh({Duration maxAge = const Duration(days: 1)}) async {
    return _isDataFresh(_languagesKey, maxAge);
  }

  /// Check if privacy policy version data is fresh
  Future<bool> isPrivacyPolicyDataFresh({Duration maxAge = const Duration(hours: 6)}) async {
    return _isDataFresh(_privacyPolicyKey, maxAge);
  }

  /// Check if terms of service version data is fresh
  Future<bool> isTermsOfServiceDataFresh({Duration maxAge = const Duration(hours: 6)}) async {
    return _isDataFresh(_termsOfServiceKey, maxAge);
  }

  /// Check if data usage statistics are fresh
  Future<bool> isDataUsageStatisticsFresh(String userId, {Duration maxAge = const Duration(hours: 1)}) async {
    final key = '$_dataUsagePrefix$userId';
    return _isDataFresh(key, maxAge);
  }

  /// Check if device-specific settings are fresh
  Future<bool> isDeviceSpecificSettingsFresh(String userId, String deviceId, {Duration maxAge = const Duration(hours: 2)}) async {
    final key = '$_deviceSettingsPrefix${userId}_$deviceId';
    return _isDataFresh(key, maxAge);
  }
}