import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_preferences.dart';
import '../repositories/settings_repository.dart';

class GetAppPreferencesUseCase implements UseCase<AppPreferences, GetAppPreferencesParams> {
  const GetAppPreferencesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, AppPreferences>> call(GetAppPreferencesParams params) async {
    return await _repository.getAppPreferences(params.userId);
  }
}

class GetAppPreferencesParams extends Equatable {
  const GetAppPreferencesParams({
    required this.userId,
  });

  final String userId;

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'GetAppPreferencesParams(userId: $userId)';
}