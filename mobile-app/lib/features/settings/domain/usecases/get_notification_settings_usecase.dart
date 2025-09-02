import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_settings.dart';
import '../repositories/settings_repository.dart';

class GetNotificationSettingsUseCase implements UseCase<NotificationSettings, GetNotificationSettingsParams> {
  const GetNotificationSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, NotificationSettings>> call(GetNotificationSettingsParams params) async {
    return await _repository.getNotificationSettings(params.userId);
  }
}

class GetNotificationSettingsParams extends Equatable {
  const GetNotificationSettingsParams({
    required this.userId,
  });

  final String userId;

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'GetNotificationSettingsParams(userId: $userId)';
}