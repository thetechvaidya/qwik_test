import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_dashboard_data.dart';
import '../../domain/usecases/get_user_stats.dart';
import '../../domain/usecases/get_achievements.dart';
import '../../domain/usecases/get_recent_activities.dart';
import '../../domain/usecases/get_performance_trends.dart';
import '../../domain/usecases/update_achievement_progress.dart';
import '../../domain/usecases/unlock_achievement.dart';
import '../../domain/usecases/add_recent_activity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardData getDashboardData;
  final GetUserStats getUserStats;
  final GetAchievements getAchievements;
  final GetRecentActivities getRecentActivities;
  final GetPerformanceTrends getPerformanceTrends;
  final UpdateAchievementProgress updateAchievementProgress;
  final UnlockAchievement unlockAchievement;
  final AddRecentActivity addRecentActivity;
  final DashboardRepository dashboardRepository;

  DashboardBloc({
    required this.getDashboardData,
    required this.getUserStats,
    required this.getAchievements,
    required this.getRecentActivities,
    required this.getPerformanceTrends,
    required this.updateAchievementProgress,
    required this.unlockAchievement,
    required this.addRecentActivity,
    required this.dashboardRepository,
  }) : super(const DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
    on<LoadUserStats>(_onLoadUserStats);
    on<LoadAchievements>(_onLoadAchievements);
    on<LoadRecentActivities>(_onLoadRecentActivities);
    on<LoadPerformanceTrends>(_onLoadPerformanceTrends);
    on<UpdateAchievementProgressEvent>(_onUpdateAchievementProgress);
    on<UnlockAchievementEvent>(_onUnlockAchievement);
    on<AddRecentActivityEvent>(_onAddRecentActivity);
    on<ClearDashboardCache>(_onClearDashboardCache);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    final result = await getDashboardData(
      GetDashboardDataParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(DashboardError(message: _mapFailureToMessage(failure))),
      (dashboardData) => emit(DashboardLoaded(dashboardData: dashboardData)),
    );
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(const DashboardLoading());
    }

    // Clear cache and refresh data
    await dashboardRepository.clearCache();
    
    final result = await getDashboardData(
      GetDashboardDataParams(userId: event.userId),
    );

    result.fold(
      (failure) {
        if (state is DashboardLoaded) {
          final currentState = state as DashboardLoaded;
          emit(currentState.copyWith(isRefreshing: false));
          emit(DashboardError(
            message: _mapFailureToMessage(failure),
            previousData: currentState.dashboardData,
          ));
        } else {
          emit(DashboardError(message: _mapFailureToMessage(failure)));
        }
      },
      (dashboardData) => emit(DashboardLoaded(
        dashboardData: dashboardData,
        isRefreshing: false,
      )),
    );
  }

  Future<void> _onLoadUserStats(
    LoadUserStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const UserStatsLoading());

    final result = await getUserStats(
      GetUserStatsParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(UserStatsError(message: _mapFailureToMessage(failure))),
      (userStats) => emit(UserStatsLoaded(userStats: userStats)),
    );
  }

  Future<void> _onLoadAchievements(
    LoadAchievements event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const AchievementsLoading());

    final result = await getAchievements(
      GetAchievementsParams(
        userId: event.userId,
        unlockedOnly: event.unlockedOnly,
        category: event.category,
      ),
    );

    result.fold(
      (failure) => emit(AchievementsError(message: _mapFailureToMessage(failure))),
      (achievements) => emit(AchievementsLoaded(achievements: achievements)),
    );
  }

  Future<void> _onLoadRecentActivities(
    LoadRecentActivities event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const RecentActivitiesLoading());

    final result = await getRecentActivities(
      GetRecentActivitiesParams(
        userId: event.userId,
        limit: event.limit,
        activityType: event.activityType,
      ),
    );

    result.fold(
      (failure) => emit(RecentActivitiesError(message: _mapFailureToMessage(failure))),
      (activities) => emit(RecentActivitiesLoaded(activities: activities)),
    );
  }

  Future<void> _onLoadPerformanceTrends(
    LoadPerformanceTrends event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const PerformanceTrendsLoading());

    final result = await getPerformanceTrends(
      GetPerformanceTrendsParams(
        userId: event.userId,
        period: event.period,
        subject: event.subject,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    result.fold(
      (failure) => emit(PerformanceTrendsError(message: _mapFailureToMessage(failure))),
      (trends) => emit(PerformanceTrendsLoaded(trends: trends)),
    );
  }

  Future<void> _onUpdateAchievementProgress(
    UpdateAchievementProgressEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await updateAchievementProgress(
      UpdateAchievementProgressParams(
        userId: event.userId,
        achievementId: event.achievementId,
        progress: event.progress,
      ),
    );

    result.fold(
      (failure) => emit(AchievementsError(message: _mapFailureToMessage(failure))),
      (achievement) => emit(AchievementUpdated(achievement: achievement)),
    );
  }

  Future<void> _onUnlockAchievement(
    UnlockAchievementEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await unlockAchievement(
      UnlockAchievementParams(
        userId: event.userId,
        achievementId: event.achievementId,
      ),
    );

    result.fold(
      (failure) => emit(AchievementsError(message: _mapFailureToMessage(failure))),
      (achievement) => emit(AchievementUpdated(achievement: achievement)),
    );
  }

  Future<void> _onAddRecentActivity(
    AddRecentActivityEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await addRecentActivity(
      AddRecentActivityParams(
        userId: event.userId,
        activity: event.activity,
      ),
    );

    result.fold(
      (failure) => emit(RecentActivitiesError(message: _mapFailureToMessage(failure))),
      (activity) => emit(ActivityAdded(activity: activity)),
    );
  }

  Future<void> _onClearDashboardCache(
    ClearDashboardCache event,
    Emitter<DashboardState> emit,
  ) async {
    await dashboardRepository.clearCache();
    emit(const DashboardCacheCleared());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case CacheFailure:
        return 'Cache error occurred. Please refresh the data.';
      case NetworkFailure:
        return 'Network error. Please check your internet connection.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}