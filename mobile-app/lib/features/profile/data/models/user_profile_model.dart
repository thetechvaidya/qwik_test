import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/user_profile.dart';
import 'user_stats_model.dart';
import 'subscription_info_model.dart';

part 'user_profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 1)
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.name,
    @HiveField(2) required super.email,
    @HiveField(3) super.avatar,
    @HiveField(4) super.bio,
    @HiveField(5) super.location,
    @HiveField(6) super.website,
    @HiveField(7) super.socialLinks = const {},
    @HiveField(8) super.stats,
    @HiveField(9) super.subscription,
    @HiveField(10) super.preferences = const {},
    @HiveField(11) super.createdAt,
    @HiveField(12) super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserProfileModelFromJson(json);
    } catch (e) {
      // Handle malformed JSON by providing fallback values
      return UserProfileModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        avatar: json['avatar']?.toString(),
        bio: json['bio']?.toString(),
        location: json['location']?.toString(),
        website: json['website']?.toString(),
        socialLinks: _parseSocialLinks(json['social_links'] ?? json['socialLinks']),
        stats: _parseStats(json['stats']),
        subscription: _parseSubscription(json['subscription']),
        preferences: _parsePreferences(json['preferences']),
        createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']),
        updatedAt: _parseDateTime(json['updated_at'] ?? json['updatedAt']),
      );
    }
  }

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      avatar: profile.avatar,
      bio: profile.bio,
      location: profile.location,
      website: profile.website,
      socialLinks: profile.socialLinks,
      stats: profile.stats,
      subscription: profile.subscription,
      preferences: profile.preferences,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      bio: bio,
      location: location,
      website: website,
      socialLinks: socialLinks,
      stats: stats,
      subscription: subscription,
      preferences: preferences,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Helper method to parse social links from various formats
  static Map<String, String> _parseSocialLinks(dynamic socialLinksData) {
    if (socialLinksData == null) return {};
    
    if (socialLinksData is Map<String, dynamic>) {
      return socialLinksData.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }
    
    if (socialLinksData is Map) {
      return socialLinksData.map((key, value) => MapEntry(key.toString(), value?.toString() ?? ''));
    }
    
    return {};
  }

  /// Helper method to parse user stats
  static UserStatsModel? _parseStats(dynamic statsData) {
    if (statsData == null) return null;
    
    if (statsData is Map<String, dynamic>) {
      return UserStatsModel.fromJson(statsData);
    }
    
    return null;
  }

  /// Helper method to parse subscription info
  static SubscriptionInfoModel? _parseSubscription(dynamic subscriptionData) {
    if (subscriptionData == null) return null;
    
    if (subscriptionData is Map<String, dynamic>) {
      return SubscriptionInfoModel.fromJson(subscriptionData);
    }
    
    return null;
  }

  /// Helper method to parse preferences
  static Map<String, dynamic> _parsePreferences(dynamic preferencesData) {
    if (preferencesData == null) return {};
    
    if (preferencesData is Map<String, dynamic>) {
      return preferencesData;
    }
    
    if (preferencesData is Map) {
      return preferencesData.map((key, value) => MapEntry(key.toString(), value));
    }
    
    return {};
  }

  /// Helper method to parse DateTime from string or timestamp
  static DateTime? _parseDateTime(dynamic dateData) {
    if (dateData == null) return null;
    
    if (dateData is String) {
      return DateTime.tryParse(dateData);
    }
    
    if (dateData is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateData * 1000);
    }
    
    return null;
  }

  /// Create profile model with current timestamp
  factory UserProfileModel.withCurrentTimestamp({
    required String id,
    required String name,
    required String email,
    String? avatar,
    String? bio,
    String? location,
    String? website,
    Map<String, String> socialLinks = const {},
    UserStatsModel? stats,
    SubscriptionInfoModel? subscription,
    Map<String, dynamic> preferences = const {},
  }) {
    final now = DateTime.now();
    return UserProfileModel(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      bio: bio,
      location: location,
      website: website,
      socialLinks: socialLinks,
      stats: stats,
      subscription: subscription,
      preferences: preferences,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Update profile with new timestamp
  UserProfileModel updateWithTimestamp({
    String? name,
    String? avatar,
    String? bio,
    String? location,
    String? website,
    Map<String, String>? socialLinks,
    UserStatsModel? stats,
    SubscriptionInfoModel? subscription,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfileModel(
      id: id,
      name: name ?? this.name,
      email: email,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
      socialLinks: socialLinks ?? this.socialLinks,
      stats: stats ?? this.stats,
      subscription: subscription ?? this.subscription,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}