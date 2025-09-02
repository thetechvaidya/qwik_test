import 'package:hive/hive.dart';
import '../models/dashboard_data_model.dart';
import '../models/user_stats_model.dart';
import '../models/achievement_model.dart';
import '../models/recent_activity_model.dart';
import '../models/performance_trend_model.dart';
import '../../domain/entities/performance_trend.dart';

abstract class DashboardLocalDataSource {
  /// Cache complete dashboard data
  Future<void> cacheDashboardData(String userId, DashboardDataModel data);
  
  /// Get cached dashboard data
  Future<DashboardDataModel?> getCachedDashboardData(String userId);
  
  /// Cache user statistics
  Future<void> cacheUserStats(String userId, UserStatsModel stats);
  
  /// Get cached user statistics
  Future<UserStatsModel?> getCachedUserStats(String userId);
  
  /// Cache achievements
  Future<void> cacheAchievements(String userId, List<AchievementModel> achievements);
  
  /// Get cached achievements
  Future<List<AchievementModel>?> getCachedAchievements(String userId);
  
  /// Cache recent activities
  Future<void> cacheRecentActivities(String userId, List<RecentActivityModel> activities);
  
  /// Get cached recent activities
  Future<List<RecentActivityModel>?> getCachedRecentActivities(String userId);
  
  /// Cache performance trends
  Future<void> cachePerformanceTrends(
    String userId,
    List<PerformanceTrendModel> trends,
    TrendPeriod period,
  );
  
  /// Get cached performance trends
  Future<List<PerformanceTrendModel>?> getCachedPerformanceTrends(
    String userId,
    TrendPeriod period,
  );
  
  /// Update cached achievement
  Future<void> updateCachedAchievement(String userId, AchievementModel achievement);
  
  /// Add cached recent activity
  Future<void> addCachedRecentActivity(String userId, RecentActivityModel activity);
  
  /// Clear all cached dashboard data for user
  Future<void> clearCachedDashboardData(String userId);
  
  /// Clear all cached data
  Future<void> clearAllCache();
  
  /// Check if dashboard data is cached and fresh
  Future<bool> isDashboardDataFresh(String userId, {Duration maxAge = const Duration(minutes: 30)});
  
  /// Get cache timestamp
  Future<DateTime?> getCacheTimestamp(String userId, String dataType);
  
  /// Set cache timestamp
  Future<void> setCacheTimestamp(String userId, String dataType, DateTime timestamp);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  static const String _dashboardBoxName = 'dashboard_cache';
  static const String _userStatsBoxName = 'user_stats_cache';
  static const String _achievementsBoxName = 'achievements_cache';
  static const String _activitiesBoxName = 'activities_cache';
  static const String _trendsBoxName = 'trends_cache';
  static const String _timestampsBoxName = 'cache_timestamps';

  late Box<Map> _dashboardBox;
  late Box<Map> _userStatsBox;
  late Box<List> _achievementsBox;
  late Box<List> _activitiesBox;
  late Box<List> _trendsBox;
  late Box<String> _timestampsBox;

  bool _isInitialized = false;

  /// Initialize Hive boxes
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _dashboardBox = await Hive.openBox<Map>(_dashboardBoxName);
      _userStatsBox = await Hive.openBox<Map>(_userStatsBoxName);
      _achievementsBox = await Hive.openBox<List>(_achievementsBoxName);
      _activitiesBox = await Hive.openBox<List>(_activitiesBoxName);
      _trendsBox = await Hive.openBox<List>(_trendsBoxName);
      _timestampsBox = await Hive.openBox<String>(_timestampsBoxName);
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize dashboard local data source: $e');
    }
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception('DashboardLocalDataSource not initialized. Call init() first.');
    }
  }

  @override
  Future<void> cacheDashboardData(String userId, DashboardDataModel data) async {
    _ensureInitialized();
    try {
      await _dashboardBox.put(userId, data.toJson());
      await setCacheTimestamp(userId, 'dashboard', DateTime.now());
    } catch (e) {
      throw Exception('Failed to cache dashboard data: $e');
    }
  }

  @override
  Future<DashboardDataModel?> getCachedDashboardData(String userId) async {
    _ensureInitialized();
    try {
      final cachedData = _dashboardBox.get(userId);
      if (cachedData != null) {
        return DashboardDataModel.fromJson(
          Map<String, dynamic>.from(cachedData),
        );
      }
      return null;
    } catch (e) {
      // Return null if there's an error reading cache
      return null;
    }
  }

  @override
  Future<void> cacheUserStats(String userId, UserStatsModel stats) async {
    _ensureInitialized();
    try {
      await _userStatsBox.put(userId, stats.toJson());
      await setCacheTimestamp(userId, 'user_stats', DateTime.now());
    } catch (e) {
      throw Exception('Failed to cache user stats: $e');
    }
  }

  @override
  Future<UserStatsModel?> getCachedUserStats(String userId) async {
    _ensureInitialized();
    try {
      final cachedStats = _userStatsBox.get(userId);
      if (cachedStats != null) {
        return UserStatsModel.fromJson(
          Map<String, dynamic>.from(cachedStats),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheAchievements(String userId, List<AchievementModel> achievements) async {
    _ensureInitialized();
    try {
      final achievementsJson = achievements.map((a) => a.toJson()).toList();
      await _achievementsBox.put(userId, achievementsJson);
      await setCacheTimestamp(userId, 'achievements', DateTime.now());
    } catch (e) {
      throw Exception('Failed to cache achievements: $e');
    }
  }

  @override
  Future<List<AchievementModel>?> getCachedAchievements(String userId) async {
    _ensureInitialized();
    try {
      final cachedAchievements = _achievementsBox.get(userId);
      if (cachedAchievements != null) {
        return cachedAchievements
            .map((json) => AchievementModel.fromJson(
                  Map<String, dynamic>.from(json as Map),
                ))
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheRecentActivities(String userId, List<RecentActivityModel> activities) async {
    _ensureInitialized();
    try {
      final activitiesJson = activities.map((a) => a.toJson()).toList();
      await _activitiesBox.put(userId, activitiesJson);
      await setCacheTimestamp(userId, 'activities', DateTime.now());
    } catch (e) {
      throw Exception('Failed to cache recent activities: $e');
    }
  }

  @override
  Future<List<RecentActivityModel>?> getCachedRecentActivities(String userId) async {
    _ensureInitialized();
    try {
      final cachedActivities = _activitiesBox.get(userId);
      if (cachedActivities != null) {
        return cachedActivities
            .map((json) => RecentActivityModel.fromJson(
                  Map<String, dynamic>.from(json as Map),
                ))
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cachePerformanceTrends(
    String userId,
    List<PerformanceTrendModel> trends,
    TrendPeriod period,
  ) async {
    _ensureInitialized();
    try {
      final trendsJson = trends.map((t) => t.toJson()).toList();
      final key = '${userId}_${period.name}';
      await _trendsBox.put(key, trendsJson);
      await setCacheTimestamp(userId, 'trends_${period.name}', DateTime.now());
    } catch (e) {
      throw Exception('Failed to cache performance trends: $e');
    }
  }

  @override
  Future<List<PerformanceTrendModel>?> getCachedPerformanceTrends(
    String userId,
    TrendPeriod period,
  ) async {
    _ensureInitialized();
    try {
      final key = '${userId}_${period.name}';
      final cachedTrends = _trendsBox.get(key);
      if (cachedTrends != null) {
        return cachedTrends
            .map((json) => PerformanceTrendModel.fromJson(
                  Map<String, dynamic>.from(json as Map),
                ))
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateCachedAchievement(String userId, AchievementModel achievement) async {
    _ensureInitialized();
    try {
      final cachedAchievements = await getCachedAchievements(userId);
      if (cachedAchievements != null) {
        final updatedAchievements = cachedAchievements.map((a) {
          return a.id == achievement.id ? achievement : a;
        }).toList();
        await cacheAchievements(userId, updatedAchievements);
      }
    } catch (e) {
      throw Exception('Failed to update cached achievement: $e');
    }
  }

  @override
  Future<void> addCachedRecentActivity(String userId, RecentActivityModel activity) async {
    _ensureInitialized();
    try {
      final cachedActivities = await getCachedRecentActivities(userId) ?? [];
      final updatedActivities = [activity, ...cachedActivities]
          .take(50) // Keep only the most recent 50 activities
          .toList();
      await cacheRecentActivities(userId, updatedActivities);
    } catch (e) {
      throw Exception('Failed to add cached recent activity: $e');
    }
  }

  @override
  Future<void> clearCachedDashboardData(String userId) async {
    _ensureInitialized();
    try {
      await Future.wait([
        _dashboardBox.delete(userId),
        _userStatsBox.delete(userId),
        _achievementsBox.delete(userId),
        _activitiesBox.delete(userId),
      ]);
      
      // Clear trend data for all periods
      for (final period in TrendPeriod.values) {
        await _trendsBox.delete('${userId}_${period.name}');
      }
      
      // Clear timestamps
      final timestampKeys = _timestampsBox.keys
          .where((key) => key.toString().startsWith(userId))
          .toList();
      
      for (final key in timestampKeys) {
        await _timestampsBox.delete(key);
      }
    } catch (e) {
      throw Exception('Failed to clear cached dashboard data: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    _ensureInitialized();
    try {
      await Future.wait([
        _dashboardBox.clear(),
        _userStatsBox.clear(),
        _achievementsBox.clear(),
        _activitiesBox.clear(),
        _trendsBox.clear(),
        _timestampsBox.clear(),
      ]);
    } catch (e) {
      throw Exception('Failed to clear all cache: $e');
    }
  }

  @override
  Future<bool> isDashboardDataFresh(
    String userId, {
    Duration maxAge = const Duration(minutes: 30),
  }) async {
    _ensureInitialized();
    try {
      final timestamp = await getCacheTimestamp(userId, 'dashboard');
      if (timestamp == null) return false;
      
      final age = DateTime.now().difference(timestamp);
      return age <= maxAge;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp(String userId, String dataType) async {
    _ensureInitialized();
    try {
      final key = '${userId}_$dataType';
      final timestampString = _timestampsBox.get(key);
      if (timestampString != null) {
        return DateTime.parse(timestampString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setCacheTimestamp(String userId, String dataType, DateTime timestamp) async {
    _ensureInitialized();
    try {
      final key = '${userId}_$dataType';
      await _timestampsBox.put(key, timestamp.toIso8601String());
    } catch (e) {
      throw Exception('Failed to set cache timestamp: $e');
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    _ensureInitialized();
    try {
      return {
        'dashboardEntries': _dashboardBox.length,
        'userStatsEntries': _userStatsBox.length,
        'achievementsEntries': _achievementsBox.length,
        'activitiesEntries': _activitiesBox.length,
        'trendsEntries': _trendsBox.length,
        'timestampEntries': _timestampsBox.length,
        'totalSize': _dashboardBox.length +
            _userStatsBox.length +
            _achievementsBox.length +
            _activitiesBox.length +
            _trendsBox.length +
            _timestampsBox.length,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Clean up old cache entries
  Future<void> cleanupOldCache({Duration maxAge = const Duration(days: 7)}) async {
    _ensureInitialized();
    try {
      final cutoffTime = DateTime.now().subtract(maxAge);
      final keysToDelete = <String>[];
      
      // Check all timestamp entries
      for (final key in _timestampsBox.keys) {
        final timestampString = _timestampsBox.get(key);
        if (timestampString != null) {
          final timestamp = DateTime.parse(timestampString);
          if (timestamp.isBefore(cutoffTime)) {
            keysToDelete.add(key.toString());
          }
        }
      }
      
      // Delete old entries
      for (final key in keysToDelete) {
        final parts = key.split('_');
        if (parts.length >= 2) {
          final userId = parts[0];
          await clearCachedDashboardData(userId);
        }
      }
    } catch (e) {
      throw Exception('Failed to cleanup old cache: $e');
    }
  }

  /// Close all boxes
  Future<void> close() async {
    if (!_isInitialized) return;
    
    try {
      await Future.wait([
        _dashboardBox.close(),
        _userStatsBox.close(),
        _achievementsBox.close(),
        _activitiesBox.close(),
        _trendsBox.close(),
        _timestampsBox.close(),
      ]);
      _isInitialized = false;
    } catch (e) {
      throw Exception('Failed to close dashboard local data source: $e');
    }
  }
}