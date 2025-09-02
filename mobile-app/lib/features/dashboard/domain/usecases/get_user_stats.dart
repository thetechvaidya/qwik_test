import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_stats.dart';
import '../repositories/dashboard_repository.dart';

class GetUserStats implements UseCase<UserStats, GetUserStatsParams> {
  final DashboardRepository repository;

  GetUserStats(this.repository);

  @override
  Future<Either<Failure, UserStats>> call(GetUserStatsParams params) async {
    return await repository.getUserStats(params.userId);
  }
}

class GetUserStatsParams {
  final String userId;

  GetUserStatsParams({required this.userId});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetUserStatsParams && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}