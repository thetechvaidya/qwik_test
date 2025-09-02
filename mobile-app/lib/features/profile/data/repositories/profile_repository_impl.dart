import 'package:dartz/dartz.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/entities/subscription_info.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';
import '../models/user_stats_model.dart';
import '../models/subscription_info_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.getUserProfile(userId);
        await localDataSource.cacheUserProfile(remoteProfile);
        return Right(remoteProfile);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProfile = await localDataSource.getCachedUserProfile(userId);
        return Right(localProfile);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedProfile = await remoteDataSource.updateUserProfile(userId, updates);
        await localDataSource.cacheUserProfile(updatedProfile);
        return Right(updatedProfile);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(
    String userId,
    String imagePath,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final avatarUrl = await remoteDataSource.uploadAvatar(userId, imagePath);
        return Right(avatarUrl);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAvatar(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAvatar(userId);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserStats>> getUserStats(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteStats = await remoteDataSource.getUserStats(userId);
        await localDataSource.cacheUserStats(remoteStats);
        return Right(remoteStats);
      } on ServerException {
        try {
          final localStats = await localDataSource.getCachedUserStats(userId);
          return Right(localStats);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localStats = await localDataSource.getCachedUserStats(userId);
        return Right(localStats);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, UserStats>> updateUserStats(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedStats = await remoteDataSource.updateUserStats(userId, updates);
        await localDataSource.cacheUserStats(updatedStats);
        return Right(updatedStats);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SubscriptionInfo>> getSubscriptionInfo(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSubscription = await remoteDataSource.getSubscriptionInfo(userId);
        await localDataSource.cacheSubscriptionInfo(remoteSubscription);
        return Right(remoteSubscription);
      } on ServerException {
        try {
          final localSubscription = await localDataSource.getCachedSubscriptionInfo(userId);
          return Right(localSubscription);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localSubscription = await localDataSource.getCachedSubscriptionInfo(userId);
        return Right(localSubscription);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, SubscriptionInfo>> updateSubscription(
    String userId,
    String planId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedSubscription = await remoteDataSource.updateSubscription(userId, planId);
        await localDataSource.cacheSubscriptionInfo(updatedSubscription);
        return Right(updatedSubscription);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelSubscription(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.cancelSubscription(userId);
        await localDataSource.clearSubscriptionCache(userId);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> reactivateSubscription(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.reactivateSubscription(userId);
        await localDataSource.clearSubscriptionCache(userId);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAchievements(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAchievements = await remoteDataSource.getAchievements(userId);
        await localDataSource.cacheAchievements(userId, remoteAchievements);
        return Right(remoteAchievements);
      } on ServerException {
        try {
          final localAchievements = await localDataSource.getCachedAchievements(userId);
          return Right(localAchievements);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localAchievements = await localDataSource.getCachedAchievements(userId);
        return Right(localAchievements);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getActivityFeed(
    String userId,
    int page,
    int limit,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteActivity = await remoteDataSource.getActivityFeed(userId, page, limit);
        await localDataSource.cacheActivityFeed(userId, page, remoteActivity);
        return Right(remoteActivity);
      } on ServerException {
        try {
          final localActivity = await localDataSource.getCachedActivityFeed(userId, page);
          return Right(localActivity);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localActivity = await localDataSource.getCachedActivityFeed(userId, page);
        return Right(localActivity);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> followUser(String userId, String targetUserId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.followUser(userId, targetUserId);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String userId, String targetUserId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.unfollowUser(userId, targetUserId);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> getFollowers(
    String userId,
    int page,
    int limit,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFollowers = await remoteDataSource.getFollowers(userId, page, limit);
        return Right(remoteFollowers);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> getFollowing(
    String userId,
    int page,
    int limit,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFollowing = await remoteDataSource.getFollowing(userId, page, limit);
        return Right(remoteFollowing);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> searchUsers(
    String query,
    int page,
    int limit,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final searchResults = await remoteDataSource.searchUsers(query, page, limit);
        await localDataSource.cacheSearchResults(query, page, searchResults);
        return Right(searchResults);
      } on ServerException {
        try {
          final cachedResults = await localDataSource.getCachedSearchResults(query, page);
          return Right(cachedResults);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedResults = await localDataSource.getCachedSearchResults(query, page);
        return Right(cachedResults);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> getLeaderboard(
    String category,
    int page,
    int limit,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final leaderboard = await remoteDataSource.getLeaderboard(category, page, limit);
        await localDataSource.cacheLeaderboard(category, page, leaderboard);
        return Right(leaderboard);
      } on ServerException {
        try {
          final cachedLeaderboard = await localDataSource.getCachedLeaderboard(category, page);
          return Right(cachedLeaderboard);
        } on CacheException {
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final cachedLeaderboard = await localDataSource.getCachedLeaderboard(category, page);
        return Right(cachedLeaderboard);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> clearProfileCache(String userId) async {
    try {
      await localDataSource.clearProfileCache(userId);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearAllCache() async {
    try {
      await localDataSource.clearAllCache();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}