import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/recent_activity.dart';
import '../../domain/entities/performance_trend.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../datasources/dashboard_local_datasource.dart';
import '../models/dashboard_data_model.dart';
import '../models/user_stats_model.dart';
import '../models/achievement_model.dart';
import '../models/recent_activity_model.dart';
import '../models/performance_trend_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final DashboardLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DashboardData>> getDashboardData(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        // Check if cache is fresh
        final isCacheFresh = await localDataSource.isDashboardDataCacheFresh(userId);
        
        if (isCacheFresh) {
          // Return cached data if fresh
          final cachedData = await localDataSource.getCachedDashboardData(userId);
          if (cachedData != null) {
            return Right(cachedData.toEntity());
          }
        }
        
        // Fetch from remote
        final remoteData = await remoteDataSource.getDashboardData(userId);
        
        // Cache the data
        await localDataSource.cacheDashboardData(remoteData);
        await localDataSource.setDashboardDataCacheTimestamp(userId, DateTime.now());
        
        return Right(remoteData.toEntity());
      } else {
        // No internet, try to get cached data
        final cachedData = await localDataSource.getCachedDashboardData(userId);
        if (cachedData != null) {
          return Right(cachedData.toEntity());
        } else {
          return Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, UserStats>> getUserStats(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        // Check if cache is fresh
        final isCacheFresh = await localDataSource.isUserStatsCacheFresh(userId);
        
        if (isCacheFresh) {
          final cachedStats = await localDataSource.getCachedUserStats(userId);
          if (cachedStats != null) {
            return Right(cachedStats.toEntity());
          }
        }
        
        // Fetch from remote
        final remoteStats = await remoteDataSource.getUserStats(userId);
        
        // Cache the data
        await localDataSource.cacheUserStats(remoteStats);
        await localDataSource.setUserStatsCacheTimestamp(userId, DateTime.now());
        
        return Right(remoteStats.toEntity());
      } else {
        // No internet, try cached data
        final cachedStats = await localDataSource.getCachedUserStats(userId);
        if (cachedStats != null) {
          return Right(cachedStats.toEntity());
        } else {
          return Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAchievements(
    String userId, {
    bool? unlockedOnly,
    String? category,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        // Check if cache is fresh
        final isCacheFresh = await localDataSource.isAchievementsCacheFresh(userId);
        
        if (isCacheFresh) {
          final cachedAchievements = await localDataSource.getCachedAchievements(userId);
          if (cachedAchievements.isNotEmpty) {
            var achievements = cachedAchievements.map((a) => a.toEntity()).toList();
            
            // Apply filters
            if (unlockedOnly == true) {
              achievements = achievements.where((a) => a.isUnlocked).toList();
            }
            if (category != null) {
              achievements = achievements.where((a) => a.category == category).toList();
            }
            
            return Right(achievements);
          }
        }
        
        // Fetch from remote
        final remoteAchievements = await remoteDataSource.getAchievements(
          userId,
          unlockedOnly: unlockedOnly,
          category: category,
        );
        
        // Cache the data
        await localDataSource.cacheAchievements(remoteAchievements);
        await localDataSource.setAchievementsCacheTimestamp(userId, DateTime.now());
        
        return Right(remoteAchievements.map((a) => a.toEntity()).toList());
      } else {
        // No internet, try cached data
        final cachedAchievements = await localDataSource.getCachedAchievements(userId);
        if (cachedAchievements.isNotEmpty) {
          var achievements = cachedAchievements.map((a) => a.toEntity()).toList();
          
          // Apply filters
          if (unlockedOnly == true) {
            achievements = achievements.where((a) => a.isUnlocked).toList();
          }
          if (category != null) {
            achievements = achievements.where((a) => a.category == category).toList();
          }
          
          return Right(achievements);
        } else {
          return Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RecentActivity>>> getRecentActivities(
    String userId, {
    int? limit,
    String? activityType,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        // Check if cache is fresh
        final isCacheFresh = await localDataSource.isRecentActivitiesCacheFresh(userId);
        
        if (isCacheFresh) {
          final cachedActivities = await localDataSource.getCachedRecentActivities(userId);
          if (cachedActivities.isNotEmpty) {
            var activities = cachedActivities.map((a) => a.toEntity()).toList();
            
            // Apply filters
            if (activityType != null) {
              activities = activities.where((a) => a.activityType == activityType).toList();
            }
            if (limit != null) {
              activities = activities.take(limit).toList();
            }
            
            return Right(activities);
          }
        }
        
        // Fetch from remote
        final remoteActivities = await remoteDataSource.getRecentActivities(
          userId,
          limit: limit,
          activityType: activityType,
        );
        
        // Cache the data
        await localDataSource.cacheRecentActivities(remoteActivities);
        await localDataSource.setRecentActivitiesCacheTimestamp(userId, DateTime.now());
        
        return Right(remoteActivities.map((a) => a.toEntity()).toList());
      } else {
        // No internet, try cached data
        final cachedActivities = await localDataSource.getCachedRecentActivities(userId);
        if (cachedActivities.isNotEmpty) {
          var activities = cachedActivities.map((a) => a.toEntity()).toList();
          
          // Apply filters
          if (activityType != null) {
            activities = activities.where((a) => a.activityType == activityType).toList();
          }
          if (limit != null) {
            activities = activities.take(limit).toList();
          }
          
          return Right(activities);
        } else {
          return Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PerformanceTrend>>> getPerformanceTrends(
    String userId, {
    TrendPeriod? period,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        // Check if cache is fresh
        final isCacheFresh = await localDataSource.isPerformanceTrendsCacheFresh(userId);
        
        if (isCacheFresh) {
          final cachedTrends = await localDataSource.getCachedPerformanceTrends(userId);
          if (cachedTrends.isNotEmpty) {
            var trends = cachedTrends.map((t) => t.toEntity()).toList();
            
            // Apply filters
            if (period != null) {
              trends = trends.where((t) => t.period == period).toList();
            }
            if (category != null) {
              trends = trends.where((t) => t.category == category).toList();
            }
            if (startDate != null) {
              trends = trends.where((t) => t.date.isAfter(startDate) || t.date.isAtSameMomentAs(startDate)).toList();
            }
            if (endDate != null) {
              trends = trends.where((t) => t.date.isBefore(endDate) || t.date.isAtSameMomentAs(endDate)).toList();
            }
            
            return Right(trends);
          }
        }
        
        // Fetch from remote
        final remoteTrends = await remoteDataSource.getPerformanceTrends(
          userId,
          period: period,
          category: category,
          startDate: startDate,
          endDate: endDate,
        );
        
        // Cache the data
        await localDataSource.cachePerformanceTrends(remoteTrends);
        await localDataSource.setPerformanceTrendsCacheTimestamp(userId, DateTime.now());
        
        return Right(remoteTrends.map((t) => t.toEntity()).toList());
      } else {
        // No internet, try cached data
        final cachedTrends = await localDataSource.getCachedPerformanceTrends(userId);
        if (cachedTrends.isNotEmpty) {
          var trends = cachedTrends.map((t) => t.toEntity()).toList();
          
          // Apply filters
          if (period != null) {
            trends = trends.where((t) => t.period == period).toList();
          }
          if (category != null) {
            trends = trends.where((t) => t.category == category).toList();
          }
          if (startDate != null) {
            trends = trends.where((t) => t.date.isAfter(startDate) || t.date.isAtSameMomentAs(startDate)).toList();
          }
          if (endDate != null) {
            trends = trends.where((t) => t.date.isBefore(endDate) || t.date.isAtSameMomentAs(endDate)).toList();
          }
          
          return Right(trends);
        } else {
          return Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Achievement>> updateAchievementProgress(
    String achievementId,
    int progress,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final updatedAchievement = await remoteDataSource.updateAchievementProgress(
          achievementId,
          progress,
        );
        
        // Update in cache
        await localDataSource.updateCachedAchievement(updatedAchievement);
        
        return Right(updatedAchievement.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Achievement>> unlockAchievement(String achievementId) async {
    try {
      if (await networkInfo.isConnected) {
        final unlockedAchievement = await remoteDataSource.unlockAchievement(achievementId);
        
        // Update in cache
        await localDataSource.updateCachedAchievement(unlockedAchievement);
        
        return Right(unlockedAchievement.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, RecentActivity>> addRecentActivity(
    RecentActivity activity,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final activityModel = RecentActivityModel.fromEntity(activity);
        final addedActivity = await remoteDataSource.addRecentActivity(activityModel);
        
        // Add to cache
        await localDataSource.addCachedRecentActivity(addedActivity);
        
        return Right(addedActivity.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        final summary = await remoteDataSource.getDashboardSummary(userId);
        return Right(summary.toEntity());
      } else {
        // Try to get cached dashboard data and generate summary
        final cachedData = await localDataSource.getCachedDashboardData(userId);
        if (cachedData != null) {
          return Right(cachedData.summary.toEntity());
        } else {
          return Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, DashboardData>> syncDashboardData(
    String userId,
    DateTime lastSync,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final syncedData = await remoteDataSource.syncDashboardData(userId, lastSync);
        
        // Update cache with synced data
        await localDataSource.cacheDashboardData(syncedData);
        await localDataSource.setDashboardDataCacheTimestamp(userId, DateTime.now());
        
        return Right(syncedData.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, DashboardData>> refreshDashboardData(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        // Force fetch from remote
        final remoteData = await remoteDataSource.getDashboardData(userId);
        
        // Update cache
        await localDataSource.cacheDashboardData(remoteData);
        await localDataSource.setDashboardDataCacheTimestamp(userId, DateTime.now());
        
        return Right(remoteData.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}