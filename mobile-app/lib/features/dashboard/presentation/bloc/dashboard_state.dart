import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/recent_activity.dart';
import '../../domain/entities/performance_trend.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final DashboardData dashboardData;
  final UserStats? userStats;
  final List<Achievement>? achievements;
  final List<RecentActivity>? recentActivities;
  final List<PerformanceTrend>? performanceTrends;
  final bool isRefreshing;

  const DashboardLoaded({
    required this.dashboardData,
    this.userStats,
    this.achievements,
    this.recentActivities,
    this.performanceTrends,
    this.isRefreshing = false,
  });

  DashboardLoaded copyWith({
    DashboardData? dashboardData,
    UserStats? userStats,
    List<Achievement>? achievements,
    List<RecentActivity>? recentActivities,
    List<PerformanceTrend>? performanceTrends,
    bool? isRefreshing,
  }) {
    return DashboardLoaded(
      dashboardData: dashboardData ?? this.dashboardData,
      userStats: userStats ?? this.userStats,
      achievements: achievements ?? this.achievements,
      recentActivities: recentActivities ?? this.recentActivities,
      performanceTrends: performanceTrends ?? this.performanceTrends,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        dashboardData,
        userStats,
        achievements,
        recentActivities,
        performanceTrends,
        isRefreshing,
      ];
}

class DashboardError extends DashboardState {
  final String message;
  final DashboardData? previousData;

  const DashboardError({
    required this.message,
    this.previousData,
  });

  @override
  List<Object?> get props => [message, previousData];
}

class UserStatsLoading extends DashboardState {
  const UserStatsLoading();
}

class UserStatsLoaded extends DashboardState {
  final UserStats userStats;

  const UserStatsLoaded({required this.userStats});

  @override
  List<Object?> get props => [userStats];
}

class UserStatsError extends DashboardState {
  final String message;

  const UserStatsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AchievementsLoading extends DashboardState {
  const AchievementsLoading();
}

class AchievementsLoaded extends DashboardState {
  final List<Achievement> achievements;

  const AchievementsLoaded({required this.achievements});

  @override
  List<Object?> get props => [achievements];
}

class AchievementsError extends DashboardState {
  final String message;

  const AchievementsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AchievementUpdated extends DashboardState {
  final Achievement achievement;

  const AchievementUpdated({required this.achievement});

  @override
  List<Object?> get props => [achievement];
}

class RecentActivitiesLoading extends DashboardState {
  const RecentActivitiesLoading();
}

class RecentActivitiesLoaded extends DashboardState {
  final List<RecentActivity> activities;

  const RecentActivitiesLoaded({required this.activities});

  @override
  List<Object?> get props => [activities];
}

class RecentActivitiesError extends DashboardState {
  final String message;

  const RecentActivitiesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ActivityAdded extends DashboardState {
  final RecentActivity activity;

  const ActivityAdded({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class PerformanceTrendsLoading extends DashboardState {
  const PerformanceTrendsLoading();
}

class PerformanceTrendsLoaded extends DashboardState {
  final List<PerformanceTrend> trends;

  const PerformanceTrendsLoaded({required this.trends});

  @override
  List<Object?> get props => [trends];
}

class PerformanceTrendsError extends DashboardState {
  final String message;

  const PerformanceTrendsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class DashboardCacheCleared extends DashboardState {
  const DashboardCacheCleared();
}