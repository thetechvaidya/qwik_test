import 'package:hive/hive.dart';
import '../models/user_profile_model.dart';
import '../models/user_stats_model.dart';
import '../models/subscription_info_model.dart';

abstract class ProfileLocalDataSource {
  /// Get cached user profile
  Future<UserProfileModel?> getCachedUserProfile(String userId);

  /// Cache user profile
  Future<void> cacheUserProfile(UserProfileModel profile);

  /// Clear cached user profile
  Future<void> clearCachedUserProfile(String userId);

  /// Get cached user stats
  Future<UserStatsModel?> getCachedUserStats(String userId);

  /// Cache user stats
  Future<void> cacheUserStats(UserStatsModel stats);

  /// Clear cached user stats
  Future<void> clearCachedUserStats(String userId);

  /// Get cached subscription info
  Future<SubscriptionInfoModel?> getCachedSubscriptionInfo(String userId);

  /// Cache subscription info
  Future<void> cacheSubscriptionInfo(SubscriptionInfoModel subscription);

  /// Clear cached subscription info
  Future<void> clearCachedSubscriptionInfo(String userId);

  /// Get cached user achievements
  Future<List<Map<String, dynamic>>?> getCachedUserAchievements(String userId);

  /// Cache user achievements
  Future<void> cacheUserAchievements(String userId, List<Map<String, dynamic>> achievements);

  /// Clear cached user achievements
  Future<void> clearCachedUserAchievements(String userId);

  /// Get cached user activity
  Future<List<Map<String, dynamic>>?> getCachedUserActivity(String userId);

  /// Cache user activity
  Future<void> cacheUserActivity(String userId, List<Map<String, dynamic>> activities);

  /// Clear cached user activity
  Future<void> clearCachedUserActivity(String userId);

  /// Get cached search results
  Future<List<UserProfileModel>?> getCachedSearchResults(String query);

  /// Cache search results
  Future<void> cacheSearchResults(String query, List<UserProfileModel> results);

  /// Clear cached search results
  Future<void> clearCachedSearchResults(String query);

  /// Get cached leaderboard
  Future<List<Map<String, dynamic>>?> getCachedLeaderboard({
    required String period,
    required String category,
  });

  /// Cache leaderboard
  Future<void> cacheLeaderboard({
    required String period,
    required String category,
    required List<Map<String, dynamic>> leaderboard,
  });

  /// Clear cached leaderboard
  Future<void> clearCachedLeaderboard({
    required String period,
    required String category,
  });

  /// Clear all cached profile data
  Future<void> clearAllCachedData();

  /// Check if profile data is cached and fresh
  Future<bool> isProfileDataFresh(String userId, {Duration maxAge = const Duration(minutes: 30)});

  /// Check if stats data is cached and fresh
  Future<bool> isStatsDataFresh(String userId, {Duration maxAge = const Duration(minutes: 15)});

  /// Check if subscription data is cached and fresh
  Future<bool> isSubscriptionDataFresh(String userId, {Duration maxAge = const Duration(hours: 1)});
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl({
    required Box<dynamic> hiveBox,
  }) : _hiveBox = hiveBox;

  final Box<dynamic> _hiveBox;

  // Cache keys
  static const String _profilePrefix = 'user_profile_';
  static const String _statsPrefix = 'user_stats_';
  static const String _subscriptionPrefix = 'subscription_';
  static const String _achievementsPrefix = 'achievements_';
  static const String _activityPrefix = 'activity_';
  static const String _searchPrefix = 'search_';
  static const String _leaderboardPrefix = 'leaderboard_';
  static const String _timestampSuffix = '_timestamp';

  @override
  Future<UserProfileModel?> getCachedUserProfile(String userId) async {
    try {
      final key = '$_profilePrefix$userId';
      return _hiveBox.get(key) as UserProfileModel?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUserProfile(UserProfileModel profile) async {
    try {
      final key = '$_profilePrefix${profile.id}';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, profile);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedUserProfile(String userId) async {
    try {
      final key = '$_profilePrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<UserStatsModel?> getCachedUserStats(String userId) async {
    try {
      final key = '$_statsPrefix$userId';
      return _hiveBox.get(key) as UserStatsModel?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUserStats(UserStatsModel stats) async {
    try {
      final key = '$_statsPrefix${stats.userId}';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, stats);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedUserStats(String userId) async {
    try {
      final key = '$_statsPrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<SubscriptionInfoModel?> getCachedSubscriptionInfo(String userId) async {
    try {
      final key = '$_subscriptionPrefix$userId';
      return _hiveBox.get(key) as SubscriptionInfoModel?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheSubscriptionInfo(SubscriptionInfoModel subscription) async {
    try {
      final key = '$_subscriptionPrefix${subscription.userId}';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, subscription);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedSubscriptionInfo(String userId) async {
    try {
      final key = '$_subscriptionPrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<List<Map<String, dynamic>>?> getCachedUserAchievements(String userId) async {
    try {
      final key = '$_achievementsPrefix$userId';
      final cached = _hiveBox.get(key);
      if (cached is List) {
        return List<Map<String, dynamic>>.from(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUserAchievements(String userId, List<Map<String, dynamic>> achievements) async {
    try {
      final key = '$_achievementsPrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, achievements);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedUserAchievements(String userId) async {
    try {
      final key = '$_achievementsPrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<List<Map<String, dynamic>>?> getCachedUserActivity(String userId) async {
    try {
      final key = '$_activityPrefix$userId';
      final cached = _hiveBox.get(key);
      if (cached is List) {
        return List<Map<String, dynamic>>.from(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUserActivity(String userId, List<Map<String, dynamic>> activities) async {
    try {
      final key = '$_activityPrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, activities);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedUserActivity(String userId) async {
    try {
      final key = '$_activityPrefix$userId';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<List<UserProfileModel>?> getCachedSearchResults(String query) async {
    try {
      final key = '$_searchPrefix${query.toLowerCase()}';
      final cached = _hiveBox.get(key);
      if (cached is List) {
        return cached.cast<UserProfileModel>();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheSearchResults(String query, List<UserProfileModel> results) async {
    try {
      final key = '$_searchPrefix${query.toLowerCase()}';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, results);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedSearchResults(String query) async {
    try {
      final key = '$_searchPrefix${query.toLowerCase()}';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<List<Map<String, dynamic>>?> getCachedLeaderboard({
    required String period,
    required String category,
  }) async {
    try {
      final key = '$_leaderboardPrefix${period}_$category';
      final cached = _hiveBox.get(key);
      if (cached is List) {
        return List<Map<String, dynamic>>.from(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheLeaderboard({
    required String period,
    required String category,
    required List<Map<String, dynamic>> leaderboard,
  }) async {
    try {
      final key = '$_leaderboardPrefix${period}_$category';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.put(key, leaderboard);
      await _hiveBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCachedLeaderboard({
    required String period,
    required String category,
  }) async {
    try {
      final key = '$_leaderboardPrefix${period}_$category';
      final timestampKey = '$key$_timestampSuffix';
      
      await _hiveBox.delete(key);
      await _hiveBox.delete(timestampKey);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<void> clearAllCachedData() async {
    try {
      final keysToDelete = <String>[];
      
      for (final key in _hiveBox.keys) {
        if (key is String && (
          key.startsWith(_profilePrefix) ||
          key.startsWith(_statsPrefix) ||
          key.startsWith(_subscriptionPrefix) ||
          key.startsWith(_achievementsPrefix) ||
          key.startsWith(_activityPrefix) ||
          key.startsWith(_searchPrefix) ||
          key.startsWith(_leaderboardPrefix)
        )) {
          keysToDelete.add(key);
        }
      }
      
      await _hiveBox.deleteAll(keysToDelete);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<bool> isProfileDataFresh(String userId, {Duration maxAge = const Duration(minutes: 30)}) async {
    try {
      final key = '$_profilePrefix$userId$_timestampSuffix';
      final timestamp = _hiveBox.get(key) as int?;
      
      if (timestamp == null) return false;
      
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      
      return now.difference(cachedTime) <= maxAge;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isStatsDataFresh(String userId, {Duration maxAge = const Duration(minutes: 15)}) async {
    try {
      final key = '$_statsPrefix$userId$_timestampSuffix';
      final timestamp = _hiveBox.get(key) as int?;
      
      if (timestamp == null) return false;
      
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      
      return now.difference(cachedTime) <= maxAge;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isSubscriptionDataFresh(String userId, {Duration maxAge = const Duration(hours: 1)}) async {
    try {
      final key = '$_subscriptionPrefix$userId$_timestampSuffix';
      final timestamp = _hiveBox.get(key) as int?;
      
      if (timestamp == null) return false;
      
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      
      return now.difference(cachedTime) <= maxAge;
    } catch (e) {
      return false;
    }
  }

  /// Helper method to check if any cached data is fresh
  Future<bool> _isDataFresh(String key, Duration maxAge) async {
    try {
      final timestampKey = '$key$_timestampSuffix';
      final timestamp = _hiveBox.get(timestampKey) as int?;
      
      if (timestamp == null) return false;
      
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      
      return now.difference(cachedTime) <= maxAge;
    } catch (e) {
      return false;
    }
  }

  /// Check if search results are fresh
  Future<bool> isSearchDataFresh(String query, {Duration maxAge = const Duration(minutes: 10)}) async {
    final key = '$_searchPrefix${query.toLowerCase()}';
    return _isDataFresh(key, maxAge);
  }

  /// Check if leaderboard data is fresh
  Future<bool> isLeaderboardDataFresh({
    required String period,
    required String category,
    Duration maxAge = const Duration(minutes: 5),
  }) async {
    final key = '$_leaderboardPrefix${period}_$category';
    return _isDataFresh(key, maxAge);
  }

  /// Check if achievements data is fresh
  Future<bool> isAchievementsDataFresh(String userId, {Duration maxAge = const Duration(hours: 2)}) async {
    final key = '$_achievementsPrefix$userId';
    return _isDataFresh(key, maxAge);
  }

  /// Check if activity data is fresh
  Future<bool> isActivityDataFresh(String userId, {Duration maxAge = const Duration(minutes: 20)}) async {
    final key = '$_activityPrefix$userId';
    return _isDataFresh(key, maxAge);
  }
}