import 'package:dartz/dartz.dart';
import '../../domain/entities/user_profile.dart';
// Removed unused imports: user_stats.dart, subscription_info.dart
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
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
  Future<Either<Failure, UserProfile>> getCurrentUserProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.getCurrentUserProfile();
        await localDataSource.cacheUserProfile(remoteProfile);
        return Right(remoteProfile);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProfile = await localDataSource.getCachedUserProfile('current');
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

  // Removed getUserStats implementation

  // Removed getSubscriptionInfo implementation

  // Removed getAchievements implementation

  // Removed getActivityFeed implementation

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
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final searchResults = await remoteDataSource.searchUsers(
          query: query,
          limit: limit,
          offset: (page - 1) * limit,
        );
        return Right(searchResults);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
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