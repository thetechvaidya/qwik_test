import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recent_activity.dart';
import '../repositories/dashboard_repository.dart';

class GetRecentActivities implements UseCase<List<RecentActivity>, GetRecentActivitiesParams> {
  final DashboardRepository repository;

  GetRecentActivities(this.repository);

  @override
  Future<Either<Failure, List<RecentActivity>>> call(GetRecentActivitiesParams params) async {
    return await repository.getRecentActivities(
      params.userId,
      limit: params.limit,
      activityType: params.activityType,
    );
  }
}

class GetRecentActivitiesParams {
  final String userId;
  final int? limit;
  final String? activityType;

  GetRecentActivitiesParams({
    required this.userId,
    this.limit,
    this.activityType,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetRecentActivitiesParams &&
        other.userId == userId &&
        other.limit == limit &&
        other.activityType == activityType;
  }

  @override
  int get hashCode => Object.hash(userId, limit, activityType);
}