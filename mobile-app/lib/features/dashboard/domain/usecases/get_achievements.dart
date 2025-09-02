import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/achievement.dart';
import '../repositories/dashboard_repository.dart';

class GetAchievements implements UseCase<List<Achievement>, GetAchievementsParams> {
  final DashboardRepository repository;

  GetAchievements(this.repository);

  @override
  Future<Either<Failure, List<Achievement>>> call(GetAchievementsParams params) async {
    return await repository.getAchievements(
      params.userId,
      unlockedOnly: params.unlockedOnly,
      category: params.category,
    );
  }
}

class GetAchievementsParams {
  final String userId;
  final bool? unlockedOnly;
  final String? category;

  GetAchievementsParams({
    required this.userId,
    this.unlockedOnly,
    this.category,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetAchievementsParams &&
        other.userId == userId &&
        other.unlockedOnly == unlockedOnly &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(userId, unlockedOnly, category);
}