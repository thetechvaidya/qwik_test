import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_settings.dart';
import '../entities/app_preferences.dart';

abstract class SettingsRepository {
  Future<Either<Failure, UserSettings>> getUserSettings(String userId);
  Future<Either<Failure, void>> updateUserSettings(UserSettings settings);
  Future<Either<Failure, AppPreferences>> getAppPreferences();
  Future<Either<Failure, void>> updateAppPreferences(AppPreferences preferences);
  Future<Either<Failure, List<String>>> getAvailableLanguages();
  Future<Either<Failure, List<String>>> getAvailableThemes();
}