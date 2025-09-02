import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateUserSettingsUseCase implements UseCase<UserSettings, UpdateUserSettingsParams> {
  const UpdateUserSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, UserSettings>> call(UpdateUserSettingsParams params) async {
    return await _repository.updateUserSettings(params.userId, params.updates);
  }
}

class UpdateUserSettingsParams extends Equatable {
  const UpdateUserSettingsParams({
    required this.userId,
    required this.updates,
  });

  final String userId;
  final Map<String, dynamic> updates;

  @override
  List<Object> get props => [userId, updates];

  @override
  String toString() => 'UpdateUserSettingsParams(userId: $userId, updates: $updates)';
}