import 'package:dartz/dartz.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/entities/app_preferences.dart';
import '../../domain/entities/offline_preferences.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../datasources/settings_remote_datasource.dart';
import '../models/user_settings_model.dart';
import '../models/notification_settings_model.dart';
import '../models/app_preferences_model.dart';
import '../models/offline_preferences_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserSettings>> getUserSettings(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSettings = await remoteDataSource.getUserSettings(userId);
        await localDataSource.cacheUserSettings(remoteSettings);
        return Right(remoteSettings);
      } on ServerException {
        try {
          final localSettings = await localDataSource.getCachedUserSettings(userId);
          return Right(localSettings);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localSettings = await localDataSource.getCachedUserSettings(userId);
        return Right(localSettings);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, UserSettings>> updateUserSettings(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedSettings = await remoteDataSource.updateUserSettings(userId, updates);
        await localDataSource.cacheUserSettings(updatedSettings);
        return Right(updatedSettings);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> getNotificationSettings(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNotifications = await remoteDataSource.getNotificationSettings(userId);
        await localDataSource.cacheNotificationSettings(remoteNotifications);
        return Right(remoteNotifications);
      } on ServerException {
        try {
          final localNotifications = await localDataSource.getCachedNotificationSettings(userId);
          return Right(localNotifications);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localNotifications = await localDataSource.getCachedNotificationSettings(userId);
        return Right(localNotifications);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedNotifications = await remoteDataSource.updateNotificationSettings(userId, updates);
        await localDataSource.cacheNotificationSettings(updatedNotifications);
        return Right(updatedNotifications);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AppPreferences>> getAppPreferences(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePreferences = await remoteDataSource.getAppPreferences(userId);
        await localDataSource.cacheAppPreferences(remotePreferences);
        return Right(remotePreferences);
      } on ServerException {
        try {
          final localPreferences = await localDataSource.getCachedAppPreferences(userId);
          return Right(localPreferences);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localPreferences = await localDataSource.getCachedAppPreferences(userId);
        return Right(localPreferences);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, AppPreferences>> updateAppPreferences(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedPreferences = await remoteDataSource.updateAppPreferences(userId, updates);
        await localDataSource.cacheAppPreferences(updatedPreferences);
        return Right(updatedPreferences);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, OfflinePreferences>> getOfflinePreferences(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOfflinePrefs = await remoteDataSource.getOfflinePreferences(userId);
        await localDataSource.cacheOfflinePreferences(remoteOfflinePrefs);
        return Right(remoteOfflinePrefs);
      } on ServerException {
        try {
          final localOfflinePrefs = await localDataSource.getCachedOfflinePreferences(userId);
          return Right(localOfflinePrefs);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localOfflinePrefs = await localDataSource.getCachedOfflinePreferences(userId);
        return Right(localOfflinePrefs);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, OfflinePreferences>> updateOfflinePreferences(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedOfflinePrefs = await remoteDataSource.updateOfflinePreferences(userId, updates);
        await localDataSource.cacheOfflinePreferences(updatedOfflinePrefs);
        return Right(updatedOfflinePrefs);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetToDefault(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetToDefault(userId);
        await localDataSource.clearAllCache();
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> exportSettings(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final exportedSettings = await remoteDataSource.exportSettings(userId);
        return Right(exportedSettings);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> importSettings(
    String userId,
    Map<String, dynamic> settings,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.importSettings(userId, settings);
        await localDataSource.clearAllCache();
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableThemes() async {
    if (await networkInfo.isConnected) {
      try {
        final themes = await remoteDataSource.getAvailableThemes();
        await localDataSource.cacheAvailableThemes(themes);
        return Right(themes);
      } on ServerException {
        try {
          final cachedThemes = await localDataSource.getCachedAvailableThemes();
          return Right(cachedThemes);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedThemes = await localDataSource.getCachedAvailableThemes();
        return Right(cachedThemes);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableLanguages() async {
    if (await networkInfo.isConnected) {
      try {
        final languages = await remoteDataSource.getAvailableLanguages();
        await localDataSource.cacheAvailableLanguages(languages);
        return Right(languages);
      } on ServerException {
        try {
          final cachedLanguages = await localDataSource.getCachedAvailableLanguages();
          return Right(cachedLanguages);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedLanguages = await localDataSource.getCachedAvailableLanguages();
        return Right(cachedLanguages);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String>> getPrivacyPolicyVersion() async {
    if (await networkInfo.isConnected) {
      try {
        final version = await remoteDataSource.getPrivacyPolicyVersion();
        await localDataSource.cachePrivacyPolicyVersion(version);
        return Right(version);
      } on ServerException {
        try {
          final cachedVersion = await localDataSource.getCachedPrivacyPolicyVersion();
          return Right(cachedVersion);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedVersion = await localDataSource.getCachedPrivacyPolicyVersion();
        return Right(cachedVersion);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String>> getTermsOfServiceVersion() async {
    if (await networkInfo.isConnected) {
      try {
        final version = await remoteDataSource.getTermsOfServiceVersion();
        await localDataSource.cacheTermsOfServiceVersion(version);
        return Right(version);
      } on ServerException {
        try {
          final cachedVersion = await localDataSource.getCachedTermsOfServiceVersion();
          return Right(cachedVersion);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedVersion = await localDataSource.getCachedTermsOfServiceVersion();
        return Right(cachedVersion);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateConsentStatus(
    String userId,
    Map<String, bool> consents,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateConsentStatus(userId, consents);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDataUsageStatistics(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getDataUsageStatistics(userId);
        await localDataSource.cacheDataUsageStatistics(userId, stats);
        return Right(stats);
      } on ServerException {
        try {
          final cachedStats = await localDataSource.getCachedDataUsageStatistics(userId);
          return Right(cachedStats);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedStats = await localDataSource.getCachedDataUsageStatistics(userId);
        return Right(cachedStats);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> requestDataExport(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.requestDataExport(userId);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> requestAccountDeletion(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.requestAccountDeletion(userId);
        await localDataSource.clearAllCache();
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> syncSettingsAcrossDevices(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.syncSettingsAcrossDevices(userId);
        await localDataSource.clearAllCache();
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDeviceSpecificSettings(
    String userId,
    String deviceId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final deviceSettings = await remoteDataSource.getDeviceSpecificSettings(userId, deviceId);
        await localDataSource.cacheDeviceSpecificSettings(userId, deviceId, deviceSettings);
        return Right(deviceSettings);
      } on ServerException {
        try {
          final cachedSettings = await localDataSource.getCachedDeviceSpecificSettings(userId, deviceId);
          return Right(cachedSettings);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedSettings = await localDataSource.getCachedDeviceSpecificSettings(userId, deviceId);
        return Right(cachedSettings);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateDeviceSpecificSettings(
    String userId,
    String deviceId,
    Map<String, dynamic> settings,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateDeviceSpecificSettings(userId, deviceId, settings);
        await localDataSource.cacheDeviceSpecificSettings(userId, deviceId, settings);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearSettingsCache(String userId) async {
    try {
      await localDataSource.clearSettingsCache(userId);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearAllCache() async {
    try {
      await localDataSource.clearAllCache();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}