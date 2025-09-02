import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recent_activity.dart';
import '../repositories/dashboard_repository.dart';

class AddRecentActivity implements UseCase<RecentActivity, AddRecentActivityParams> {
  final DashboardRepository repository;

  AddRecentActivity(this.repository);

  @override
  Future<Either<Failure, RecentActivity>> call(AddRecentActivityParams params) async {
    return await repository.addRecentActivity(
      params.userId,
      params.activity,
    );
  }
}

class AddRecentActivityParams {
  final String userId;
  final RecentActivity activity;

  AddRecentActivityParams({
    required this.userId,
    required this.activity,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddRecentActivityParams &&
        other.userId == userId &&
        other.activity == activity;
  }

  @override
  int get hashCode => Object.hash(userId, activity);
}