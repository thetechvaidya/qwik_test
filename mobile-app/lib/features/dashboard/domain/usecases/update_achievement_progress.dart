import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/achievement.dart';
import '../repositories/dashboard_repository.dart';

class UpdateAchievementProgress implements UseCase<Achievement, UpdateAchievementProgressParams> {
  final DashboardRepository repository;

  UpdateAchievementProgress(this.repository);

  @override
  Future<Either<Failure, Achievement>> call(UpdateAchievementProgressParams params) async {
    return await repository.updateAchievementProgress(
      params.userId,
      params.achievementId,
      params.progress,
    );
  }
}

class UpdateAchievementProgressParams {
  final String userId;
  final String achievementId;
  final int progress;

  UpdateAchievementProgressParams({
    required this.userId,
    required this.achievementId,
    required this.progress,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateAchievementProgressParams &&
        other.userId == userId &&
        other.achievementId == achievementId &&
        other.progress == progress;
  }

  @override
  int get hashCode => Object.hash(userId, achievementId, progress);
}