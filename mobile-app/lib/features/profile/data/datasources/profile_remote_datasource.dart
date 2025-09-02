import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_profile_model.dart';
import '../models/user_stats_model.dart';
import '../models/subscription_info_model.dart';

abstract class ProfileRemoteDataSource {
  /// Get user profile by ID
  Future<UserProfileModel> getUserProfile(String userId);

  /// Update user profile
  Future<UserProfileModel> updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? avatar,
    String? bio,
    String? location,
    String? website,
    String? phone,
    DateTime? dateOfBirth,
    Map<String, String>? socialLinks,
    Map<String, dynamic>? preferences,
  });

  /// Upload profile avatar
  Future<String> uploadAvatar(String userId, String imagePath);

  /// Delete profile avatar
  Future<void> deleteAvatar(String userId);

  /// Get user statistics
  Future<UserStatsModel> getUserStats(String userId);

  /// Update user statistics (typically called after exam completion)
  Future<UserStatsModel> updateUserStats({
    required String userId,
    int? totalExamsTaken,
    int? totalPoints,
    double? averageScore,
    int? bestScore,
    int? currentStreak,
    int? longestStreak,
    int? totalStudyHours,
    Map<String, int>? subjectScores,
    Map<String, int>? categoryPerformance,
    DateTime? lastExamDate,
    DateTime? lastActiveDate,
  });

  /// Get subscription information
  Future<SubscriptionInfoModel> getSubscriptionInfo(String userId);

  /// Update subscription (upgrade/downgrade)
  Future<SubscriptionInfoModel> updateSubscription({
    required String userId,
    required String planId,
    required String paymentMethodId,
  });

  /// Cancel subscription
  Future<void> cancelSubscription(String userId);

  /// Reactivate subscription
  Future<SubscriptionInfoModel> reactivateSubscription(String userId);

  /// Get user achievements
  Future<List<Map<String, dynamic>>> getUserAchievements(String userId);

  /// Get user activity feed
  Future<List<Map<String, dynamic>>> getUserActivity({
    required String userId,
    int limit = 20,
    int offset = 0,
  });

  /// Follow/unfollow user
  Future<void> toggleFollowUser({
    required String currentUserId,
    required String targetUserId,
    required bool follow,
  });

  /// Get user followers
  Future<List<Map<String, dynamic>>> getUserFollowers({
    required String userId,
    int limit = 20,
    int offset = 0,
  });

  /// Get user following
  Future<List<Map<String, dynamic>>> getUserFollowing({
    required String userId,
    int limit = 20,
    int offset = 0,
  });

  /// Search users
  Future<List<UserProfileModel>> searchUsers({
    required String query,
    int limit = 20,
    int offset = 0,
  });

  /// Get leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard({
    String period = 'monthly', // daily, weekly, monthly, all-time
    String category = 'overall', // overall, subject-specific
    int limit = 50,
    int offset = 0,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.userProfile}/$userId',
      );

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get user profile with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/$userId'),
        message: 'Unexpected error getting user profile: $e',
      );
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? avatar,
    String? bio,
    String? location,
    String? website,
    String? phone,
    DateTime? dateOfBirth,
    Map<String, String>? socialLinks,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (avatar != null) data['avatar'] = avatar;
      if (bio != null) data['bio'] = bio;
      if (location != null) data['location'] = location;
      if (website != null) data['website'] = website;
      if (phone != null) data['phone'] = phone;
      if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth.toIso8601String();
      if (socialLinks != null) data['social_links'] = socialLinks;
      if (preferences != null) data['preferences'] = preferences;

      final response = await _dio.put(
        '${ApiEndpoints.userProfile}/$userId',
        data: data,
      );

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update user profile with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/$userId'),
        message: 'Unexpected error updating user profile: $e',
      );
    }
  }

  @override
  Future<String> uploadAvatar(String userId, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '${ApiEndpoints.userProfile}/$userId/avatar',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['avatar_url'] as String;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to upload avatar with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/$userId/avatar'),
        message: 'Unexpected error uploading avatar: $e',
      );
    }
  }

  @override
  Future<void> deleteAvatar(String userId) async {
    try {
      final response = await _dio.delete(
        '${ApiEndpoints.userProfile}/$userId/avatar',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete avatar with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/$userId/avatar'),
        message: 'Unexpected error deleting avatar: $e',
      );
    }
  }

  @override
  Future<UserStatsModel> getUserStats(String userId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.userStats}/$userId',
      );

      if (response.statusCode == 200) {
        return UserStatsModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get user stats with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/stats/$userId'),
        message: 'Unexpected error getting user stats: $e',
      );
    }
  }

  @override
  Future<UserStatsModel> updateUserStats({
    required String userId,
    int? totalExamsTaken,
    int? totalPoints,
    double? averageScore,
    int? bestScore,
    int? currentStreak,
    int? longestStreak,
    int? totalStudyHours,
    Map<String, int>? subjectScores,
    Map<String, int>? categoryPerformance,
    DateTime? lastExamDate,
    DateTime? lastActiveDate,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (totalExamsTaken != null) data['total_exams_taken'] = totalExamsTaken;
      if (totalPoints != null) data['total_points'] = totalPoints;
      if (averageScore != null) data['average_score'] = averageScore;
      if (bestScore != null) data['best_score'] = bestScore;
      if (currentStreak != null) data['current_streak'] = currentStreak;
      if (longestStreak != null) data['longest_streak'] = longestStreak;
      if (totalStudyHours != null) data['total_study_hours'] = totalStudyHours;
      if (subjectScores != null) data['subject_scores'] = subjectScores;
      if (categoryPerformance != null) data['category_performance'] = categoryPerformance;
      if (lastExamDate != null) data['last_exam_date'] = lastExamDate.toIso8601String();
      if (lastActiveDate != null) data['last_active_date'] = lastActiveDate.toIso8601String();

      final response = await _dio.put(
        '${ApiEndpoints.userStats}/$userId',
        data: data,
      );

      if (response.statusCode == 200) {
        return UserStatsModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update user stats with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/stats/$userId'),
        message: 'Unexpected error updating user stats: $e',
      );
    }
  }

  @override
  Future<SubscriptionInfoModel> getSubscriptionInfo(String userId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.subscription}/$userId',
      );

      if (response.statusCode == 200) {
        return SubscriptionInfoModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get subscription info with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/subscription/$userId'),
        message: 'Unexpected error getting subscription info: $e',
      );
    }
  }

  @override
  Future<SubscriptionInfoModel> updateSubscription({
    required String userId,
    required String planId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.subscription}/$userId/upgrade',
        data: {
          'plan_id': planId,
          'payment_method_id': paymentMethodId,
        },
      );

      if (response.statusCode == 200) {
        return SubscriptionInfoModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update subscription with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/subscription/$userId/upgrade'),
        message: 'Unexpected error updating subscription: $e',
      );
    }
  }

  @override
  Future<void> cancelSubscription(String userId) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.subscription}/$userId/cancel',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to cancel subscription with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/subscription/$userId/cancel'),
        message: 'Unexpected error canceling subscription: $e',
      );
    }
  }

  @override
  Future<SubscriptionInfoModel> reactivateSubscription(String userId) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.subscription}/$userId/reactivate',
      );

      if (response.statusCode == 200) {
        return SubscriptionInfoModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to reactivate subscription with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/subscription/$userId/reactivate'),
        message: 'Unexpected error reactivating subscription: $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserAchievements(String userId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.userProfile}/$userId/achievements',
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['achievements'] ?? []);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get user achievements with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/$userId/achievements'),
        message: 'Unexpected error getting user achievements: $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserActivity({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.userProfile}/$userId/activity',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['activities'] ?? []);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get user activity with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/$userId/activity'),
        message: 'Unexpected error getting user activity: $e',
      );
    }
  }

  @override
  Future<void> toggleFollowUser({
    required String currentUserId,
    required String targetUserId,
    required bool follow,
  }) async {
    try {
      final endpoint = follow ? 'follow' : 'unfollow';
      final response = await _dio.post(
        '${ApiEndpoints.userProfile}/$currentUserId/$endpoint/$targetUserId',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to $endpoint user with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/$currentUserId/follow/$targetUserId'),
        message: 'Unexpected error following/unfollowing user: $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserFollowers({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.userProfile}/$userId/followers',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['followers'] ?? []);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get user followers with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/$userId/followers'),
        message: 'Unexpected error getting user followers: $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserFollowing({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.userProfile}/$userId/following',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['following'] ?? []);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get user following with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/$userId/following'),
        message: 'Unexpected error getting user following: $e',
      );
    }
  }

  @override
  Future<List<UserProfileModel>> searchUsers({
    required String query,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.userProfile}/search',
        queryParameters: {
          'q': query,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        final users = List<Map<String, dynamic>>.from(response.data['users'] ?? []);
        return users.map((user) => UserProfileModel.fromJson(user)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to search users with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/profile/search'),
        message: 'Unexpected error searching users: $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getLeaderboard({
    String period = 'monthly',
    String category = 'overall',
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.leaderboard}',
        queryParameters: {
          'period': period,
          'category': category,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['leaderboard'] ?? []);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get leaderboard with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/leaderboard'),
        message: 'Unexpected error getting leaderboard: $e',
      );
    }
  }
}