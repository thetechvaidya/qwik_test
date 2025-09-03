import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_profile_model.dart';
// Removed unused imports: user_stats_model.dart, subscription_info_model.dart

abstract class ProfileRemoteDataSource {
  /// Get user profile by ID
  Future<UserProfileModel> getUserProfile(String userId);
  
  /// Get current user profile (without ID)
  Future<UserProfileModel> getCurrentUserProfile();

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

  // Removed unused methods:
  // - getUserStats, updateUserStats (user statistics)
  // - getSubscriptionInfo, updateSubscription, cancelSubscription, reactivateSubscription (subscription)
  // - getUserAchievements, getUserActivity (achievements/activity)

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
        '${ApiEndpoints.profile}/$userId',
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
  Future<UserProfileModel> getCurrentUserProfile() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.profile,
      );

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get current user profile with status code: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.profile),
        message: 'Unexpected error getting current user profile: $e',
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
        '${ApiEndpoints.updateProfile}',
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
        '${ApiEndpoints.uploadAvatar}',
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
        '${ApiEndpoints.uploadAvatar}',
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

  // Removed getUserStats implementation

  // Removed updateUserStats implementation

  // Removed getSubscriptionInfo implementation

  // Removed updateSubscription implementation

  // Removed cancelSubscription implementation

  // Removed reactivateSubscription implementation

  // Removed getUserAchievements implementation

  // Removed getUserActivity implementation

  @override
  Future<void> toggleFollowUser({
    required String currentUserId,
    required String targetUserId,
    required bool follow,
  }) async {
    try {
      final endpoint = follow ? 'follow' : 'unfollow';
      final response = await _dio.post(
        '${ApiEndpoints.profile}/$currentUserId/$endpoint/$targetUserId',
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
        '${ApiEndpoints.profile}/$userId/followers',
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
        '${ApiEndpoints.profile}/$userId/following',
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
        '${ApiEndpoints.profile}/search',
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