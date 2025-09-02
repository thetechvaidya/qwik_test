import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_stats.dart';
import '../repositories/profile_repository.dart';

class GetUserStatsUseCase implements UseCase<UserStats, GetUserStatsParams> {
  const GetUserStatsUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, UserStats>> call(GetUserStatsParams params) async {
    return await _repository.getUserStats(params.userId);
  }
}

class GetUserStatsParams extends Equatable {
  const GetUserStatsParams({
    required this.userId,
  });

  final String userId;

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'GetUserStatsParams(userId: $userId)';
}