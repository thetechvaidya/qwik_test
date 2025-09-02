import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription_info.dart';
import '../repositories/profile_repository.dart';

class GetSubscriptionInfoUseCase implements UseCase<SubscriptionInfo, GetSubscriptionInfoParams> {
  const GetSubscriptionInfoUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, SubscriptionInfo>> call(GetSubscriptionInfoParams params) async {
    return await _repository.getSubscriptionInfo(params.userId);
  }
}

class GetSubscriptionInfoParams extends Equatable {
  const GetSubscriptionInfoParams({
    required this.userId,
  });

  final String userId;

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'GetSubscriptionInfoParams(userId: $userId)';
}