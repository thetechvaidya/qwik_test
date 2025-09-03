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
        final isCacheFresh = await localDataSource.isDashboardDataFresh(userId);
        
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
        await localDataSource.cacheDashboardData(userId, remoteData);
        await localDataSource.setCacheTimestamp(userId, 'dashboard', DateTime.now());
        
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
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, UserStats>> getUserStats(String userId) async {
    try {
      // Try fetching from remote first
      if (await networkInfo.isConnected) {
        final remoteStats = await remoteDataSource.getUserStats(userId);
        await localDataSource.cacheUserStats(userId, remoteStats);
        return Right(remoteStats.toEntity());
      }
      
      // If remote fails or disconnected, try cache
      final localStats = await localDataSource.getCachedUserStats(userId);
      if (localStats != null) {
        return Right(localStats.toEntity());
      } else {
        return Left(NetworkFailure("No internet connection and no cached data"));
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
      return Left(ServerFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAchievements(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteAchievements = await remoteDataSource.getAchievements(userId);
        await localDataSource.cacheAchievements(userId, remoteAchievements);
        return Right(remoteAchievements.map((e) => e.toEntity()).toList());
      }
      
      final localAchievements = await localDataSource.getCachedAchievements(userId);
      if (localAchievements != null) {
        return Right(localAchievements.map((e) => e.toEntity()).toList());
      } else {
        return Left(NetworkFailure("No internet connection and no cached data"));
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
      return Left(ServerFailure("An unexpected error occurred: ${e.toString()}"));
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
        final isCacheFresh = await localDataSource.isDashboardDataFresh(userId);
        
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
        await localDataSource.cacheRecentActivities(userId, remoteActivities);
        await localDataSource.setCacheTimestamp(userId, 'recent_activities', DateTime.now());
        
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
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PerformanceTrend>>> getPerformanceTrends(
    String userId,
    TrendPeriod period,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteTrends = await remoteDataSource.getPerformanceTrends(userId, period: period);
        await localDataSource.cachePerformanceTrends(userId, remoteTrends, period);
        return Right(remoteTrends.map((t) => t.toEntity()).toList());
      } else {
        final localTrends = await localDataSource.getCachedPerformanceTrends(userId, period);
        if (localTrends != null) {
          return Right(localTrends.map((t) => t.toEntity()).toList());
        } else {
          return Left(NetworkFailure("No internet connection and no cached data"));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure("An unexpected error occurred: ${e.toString()}"));
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
      return Left(ServerFailure('Unexpected error: $e'));
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
      return Left(ServerFailure('Unexpected error: $e'));
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
      return Left(ServerFailure('Unexpected error: $e'));
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
      return Left(ServerFailure('Unexpected error: $e'));
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
        await localDataSource.cacheDashboardData(userId, syncedData);
        await localDataSource.setCacheTimestamp(userId, 'dashboard', DateTime.now());
        
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
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearAllCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, DashboardData>> refreshDashboardData(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        // Force fetch from remote
        final remoteData = await remoteDataSource.getDashboardData(userId);
        
        // Update cache
        await localDataSource.cacheDashboardData(userId, remoteData);
        await localDataSource.setCacheTimestamp(userId, 'dashboard', DateTime.now());
        
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