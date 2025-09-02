import 'package:equatable/equatable.dart';
import '../../domain/entities/recent_activity.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  final String userId;

  const LoadDashboardData({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshDashboardData extends DashboardEvent {
  final String userId;

  const RefreshDashboardData({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadUserStats extends DashboardEvent {
  final String userId;

  const LoadUserStats({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadAchievements extends DashboardEvent {
  final String userId;
  final bool? unlockedOnly;
  final String? category;

  const LoadAchievements({
    required this.userId,
    this.unlockedOnly,
    this.category,
  });

  @override
  List<Object?> get props => [userId, unlockedOnly, category];
}

class LoadRecentActivities extends DashboardEvent {
  final String userId;
  final int? limit;
  final String? activityType;

  const LoadRecentActivities({
    required this.userId,
    this.limit,
    this.activityType,
  });

  @override
  List<Object?> get props => [userId, limit, activityType];
}

class LoadPerformanceTrends extends DashboardEvent {
  final String userId;
  final String? period;
  final String? subject;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadPerformanceTrends({
    required this.userId,
    this.period,
    this.subject,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, period, subject, startDate, endDate];
}

class UpdateAchievementProgressEvent extends DashboardEvent {
  final String userId;
  final String achievementId;
  final int progress;

  const UpdateAchievementProgressEvent({
    required this.userId,
    required this.achievementId,
    required this.progress,
  });

  @override
  List<Object?> get props => [userId, achievementId, progress];
}

class UnlockAchievementEvent extends DashboardEvent {
  final String userId;
  final String achievementId;

  const UnlockAchievementEvent({
    required this.userId,
    required this.achievementId,
  });

  @override
  List<Object?> get props => [userId, achievementId];
}

class AddRecentActivityEvent extends DashboardEvent {
  final String userId;
  final RecentActivity activity;

  const AddRecentActivityEvent({
    required this.userId,
    required this.activity,
  });

  @override
  List<Object?> get props => [userId, activity];
}

class ClearDashboardCache extends DashboardEvent {
  const ClearDashboardCache();
}