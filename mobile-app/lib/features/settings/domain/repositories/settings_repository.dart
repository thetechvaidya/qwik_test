import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_settings.dart';
import '../entities/notification_settings.dart';
import '../entities/app_preferences.dart';
import '../entities/offline_preferences.dart';

abstract class SettingsRepository {
  Future<Either<Failure, UserSettings>> getUserSettings(String userId);
  Future<Either<Failure, void>> updateUserSettings(UserSettings settings);
  Future<Either<Failure, NotificationSettings>> getNotificationSettings(String userId);
  Future<Either<Failure, void>> updateNotificationSettings(NotificationSettings settings);
  Future<Either<Failure, AppPreferences>> getAppPreferences();
  Future<Either<Failure, void>> updateAppPreferences(AppPreferences preferences);
  // Removed offline preferences methods - not needed in simplified settings
  Future<Either<Failure, List<String>>> getAvailableLanguages();
  Future<Either<Failure, List<String>>> getAvailableThemes();
}