import 'package:dio/dio.dart';
import '../models/dashboard_data_model.dart';
import '../models/user_stats_model.dart';
import '../models/achievement_model.dart';
import '../models/recent_activity_model.dart';
import '../models/performance_trend_model.dart';
import '../../domain/entities/performance_trend.dart';

abstract class DashboardRemoteDataSource {
  /// Get complete dashboard data for user
  Future<DashboardDataModel> getDashboardData(String userId);
  
  /// Get user statistics
  Future<UserStatsModel> getUserStats(String userId);
  
  /// Get user achievements
  Future<List<AchievementModel>> getAchievements(String userId);
  
  /// Get recent activities
  Future<List<RecentActivityModel>> getRecentActivities(
    String userId, {
    int limit = 10,
  });
  
  /// Get performance trends
  Future<List<PerformanceTrendModel>> getPerformanceTrends(
    String userId, {
    TrendPeriod period = TrendPeriod.daily,
    int days = 30,
    String? category,
  });
  
  /// Update user achievement progress
  Future<AchievementModel> updateAchievementProgress(
    String userId,
    String achievementId,
    double progress,
  );
  
  /// Mark achievement as unlocked
  Future<AchievementModel> unlockAchievement(
    String userId,
    String achievementId,
  );
  
  /// Add recent activity
  Future<RecentActivityModel> addRecentActivity(
    String userId,
    RecentActivityModel activity,
  );
  
  /// Get dashboard summary
  Future<DashboardSummaryModel> getDashboardSummary(String userId);
  
  /// Sync dashboard data
  Future<void> syncDashboardData(String userId, DashboardDataModel data);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  DashboardRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<DashboardDataModel> getDashboardData(String userId) async {
    try {
      final response = await dio.get(
        '$baseUrl/dashboard/$userId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return DashboardDataModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch dashboard data',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Return sample data if user dashboard not found
        return DashboardDataModel.sample();
      }
      throw _handleDioException(e, 'getDashboardData');
    } catch (e) {
      throw Exception('Unexpected error fetching dashboard data: $e');
    }
  }

  @override
  Future<UserStatsModel> getUserStats(String userId) async {
    try {
      final response = await dio.get(
        '$baseUrl/dashboard/$userId/stats',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserStatsModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch user stats',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return UserStatsModel.empty();
      }
      throw _handleDioException(e, 'getUserStats');
    } catch (e) {
      throw Exception('Unexpected error fetching user stats: $e');
    }
  }

  @override
  Future<List<AchievementModel>> getAchievements(String userId) async {
    try {
      final response = await dio.get(
        '$baseUrl/dashboard/$userId/achievements',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> achievementsJson = response.data as List<dynamic>;
        return achievementsJson
            .map((json) => AchievementModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch achievements',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return AchievementModel.getSampleAchievements();
      }
      throw _handleDioException(e, 'getAchievements');
    } catch (e) {
      throw Exception('Unexpected error fetching achievements: $e');
    }
  }

  @override
  Future<List<RecentActivityModel>> getRecentActivities(
    String userId, {
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/dashboard/$userId/activities',
        queryParameters: {
          'limit': limit,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> activitiesJson = response.data as List<dynamic>;
        return activitiesJson
            .map((json) => RecentActivityModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch recent activities',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return RecentActivityModel.getSampleActivities().take(limit).toList();
      }
      throw _handleDioException(e, 'getRecentActivities');
    } catch (e) {
      throw Exception('Unexpected error fetching recent activities: $e');
    }
  }

  @override
  Future<List<PerformanceTrendModel>> getPerformanceTrends(
    String userId, {
    TrendPeriod period = TrendPeriod.daily,
    int days = 30,
    String? category,
  }) async {
    try {
      final queryParams = {
        'period': period.name,
        'days': days,
        if (category != null) 'category': category,
      };

      final response = await dio.get(
        '$baseUrl/dashboard/$userId/trends',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> trendsJson = response.data as List<dynamic>;
        return trendsJson
            .map((json) => PerformanceTrendModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch performance trends',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return PerformanceTrendModel.getSampleTrends().take(days).toList();
      }
      throw _handleDioException(e, 'getPerformanceTrends');
    } catch (e) {
      throw Exception('Unexpected error fetching performance trends: $e');
    }
  }

  @override
  Future<AchievementModel> updateAchievementProgress(
    String userId,
    String achievementId,
    double progress,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/dashboard/$userId/achievements/$achievementId/progress',
        data: {
          'progress': progress,
          'updatedAt': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return AchievementModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update achievement progress',
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e, 'updateAchievementProgress');
    } catch (e) {
      throw Exception('Unexpected error updating achievement progress: $e');
    }
  }

  @override
  Future<AchievementModel> unlockAchievement(
    String userId,
    String achievementId,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/dashboard/$userId/achievements/$achievementId/unlock',
        data: {
          'unlockedAt': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return AchievementModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to unlock achievement',
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e, 'unlockAchievement');
    } catch (e) {
      throw Exception('Unexpected error unlocking achievement: $e');
    }
  }

  @override
  Future<RecentActivityModel> addRecentActivity(
    String userId,
    RecentActivityModel activity,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/dashboard/$userId/activities',
        data: activity.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        return RecentActivityModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to add recent activity',
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e, 'addRecentActivity');
    } catch (e) {
      throw Exception('Unexpected error adding recent activity: $e');
    }
  }

  @override
  Future<DashboardSummaryModel> getDashboardSummary(String userId) async {
    try {
      final response = await dio.get(
        '$baseUrl/dashboard/$userId/summary',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return DashboardSummaryModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch dashboard summary',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return DashboardSummaryModel.sample();
      }
      throw _handleDioException(e, 'getDashboardSummary');
    } catch (e) {
      throw Exception('Unexpected error fetching dashboard summary: $e');
    }
  }

  @override
  Future<void> syncDashboardData(String userId, DashboardDataModel data) async {
    try {
      final response = await dio.post(
        '$baseUrl/dashboard/$userId/sync',
        data: data.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to sync dashboard data',
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e, 'syncDashboardData');
    } catch (e) {
      throw Exception('Unexpected error syncing dashboard data: $e');
    }
  }

  /// Handle Dio exceptions with proper error messages
  Exception _handleDioException(DioException e, String operation) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout during $operation');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout during $operation');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout during $operation');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        return Exception('HTTP $statusCode: $message during $operation');
      case DioExceptionType.cancel:
        return Exception('Request cancelled during $operation');
      case DioExceptionType.connectionError:
        return Exception('Connection error during $operation. Please check your internet connection.');
      case DioExceptionType.badCertificate:
        return Exception('Certificate error during $operation');
      case DioExceptionType.unknown:
      default:
        return Exception('Unknown error during $operation: ${e.message}');
    }
  }
}