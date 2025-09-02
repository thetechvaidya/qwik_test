import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_data.dart';
import '../entities/user_stats.dart';
import '../entities/achievement.dart';
import '../entities/recent_activity.dart';
import '../entities/performance_trend.dart';

abstract class DashboardRepository {
  /// Get complete dashboard data for a user
  Future<Either<Failure, DashboardData>> getDashboardData(String userId);

  /// Get user statistics
  Future<Either<Failure, UserStats>> getUserStats(String userId);

  /// Get user achievements
  Future<Either<Failure, List<Achievement>>> getAchievements(String userId, {
    bool? unlockedOnly,
    String? category,
  });

  /// Get recent activities
  Future<Either<Failure, List<RecentActivity>>> getRecentActivities(
    String userId, {
    int? limit,
    String? activityType,
  });

  /// Get performance trends
  Future<Either<Failure, List<PerformanceTrend>>> getPerformanceTrends(
    String userId, {
    TrendPeriod? period,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Update achievement progress
  Future<Either<Failure, Achievement>> updateAchievementProgress(
    String achievementId,
    int progress,
  );

  /// Unlock achievement
  Future<Either<Failure, Achievement>> unlockAchievement(String achievementId);

  /// Add recent activity
  Future<Either<Failure, RecentActivity>> addRecentActivity(
    RecentActivity activity,
  );

  /// Get dashboard summary
  Future<Either<Failure, DashboardSummary>> getDashboardSummary(String userId);

  /// Sync dashboard data
  Future<Either<Failure, DashboardData>> syncDashboardData(
    String userId,
    DateTime lastSync,
  );

  /// Clear cached dashboard data
  Future<Either<Failure, void>> clearCache();

  /// Refresh dashboard data (force fetch from remote)
  Future<Either<Failure, DashboardData>> refreshDashboardData(String userId);
}