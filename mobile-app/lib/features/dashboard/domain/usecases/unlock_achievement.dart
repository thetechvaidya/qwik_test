import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/achievement.dart';
import '../repositories/dashboard_repository.dart';

class UnlockAchievement implements UseCase<Achievement, UnlockAchievementParams> {
  final DashboardRepository repository;

  UnlockAchievement(this.repository);

  @override
  Future<Either<Failure, Achievement>> call(UnlockAchievementParams params) async {
    return await repository.unlockAchievement(
      params.userId,
      params.achievementId,
    );
  }
}

class UnlockAchievementParams {
  final String userId;
  final String achievementId;

  UnlockAchievementParams({
    required this.userId,
    required this.achievementId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UnlockAchievementParams &&
        other.userId == userId &&
        other.achievementId == achievementId;
  }

  @override
  int get hashCode => Object.hash(userId, achievementId);
}