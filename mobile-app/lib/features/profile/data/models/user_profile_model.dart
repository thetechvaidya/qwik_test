import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/user_profile.dart';
import 'user_stats_model.dart';
import '../../domain/entities/user_stats.dart';

part 'user_profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 1)
class UserProfileModel extends UserProfile {
  @override
  @HiveField(8)
  final UserStatsModel? stats;

  // Removed subscription field - not needed in simplified profile

  const UserProfileModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.name,
    @HiveField(2) required super.email,
    @HiveField(3) super.avatar,
    @HiveField(4) super.bio,
    @HiveField(5) super.location,
    @HiveField(6) super.website,
    @HiveField(7) super.socialLinks = const {},
    this.stats,
    // Removed subscription parameter - not needed in simplified profile
    @HiveField(10) super.preferences = const {},
    @HiveField(11) super.createdAt,
    @HiveField(12) super.updatedAt,
  }) : super(stats: stats);

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

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
      stats: profile.stats != null
          ? (profile.stats is UserStatsModel ? profile.stats as UserStatsModel : UserStatsModel.fromEntity(profile.stats!))
          : null,
      // Removed subscription handling - not needed in simplified profile
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
      stats: stats?.toEntity(),
      // Removed subscription conversion - not needed in simplified profile
      preferences: preferences,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
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

      preferences: preferences ?? this.preferences,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}