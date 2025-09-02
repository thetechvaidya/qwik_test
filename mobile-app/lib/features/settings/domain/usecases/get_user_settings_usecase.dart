import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_settings.dart';
import '../repositories/settings_repository.dart';

class GetUserSettingsUseCase implements UseCase<UserSettings, GetUserSettingsParams> {
  const GetUserSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, UserSettings>> call(GetUserSettingsParams params) async {
    return await _repository.getUserSettings(params.userId);
  }
}

class GetUserSettingsParams extends Equatable {
  const GetUserSettingsParams({
    required this.userId,
  });

  final String userId;

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'GetUserSettingsParams(userId: $userId)';
}