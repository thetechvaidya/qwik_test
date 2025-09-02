import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/entities/subscription_info.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state when profile feature starts
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// State when loading profile data
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// State when profile data is loaded successfully
class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.profile,
    this.stats,
    this.subscriptionInfo,
  });

  final UserProfile profile;
  final UserStats? stats;
  final SubscriptionInfo? subscriptionInfo;

  @override
  List<Object?> get props => [profile, stats, subscriptionInfo];

  ProfileLoaded copyWith({
    UserProfile? profile,
    UserStats? stats,
    SubscriptionInfo? subscriptionInfo,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      stats: stats ?? this.stats,
      subscriptionInfo: subscriptionInfo ?? this.subscriptionInfo,
    );
  }
}

/// State when updating profile
class ProfileUpdating extends ProfileState {
  const ProfileUpdating({
    required this.currentProfile,
  });

  final UserProfile currentProfile;

  @override
  List<Object?> get props => [currentProfile];
}

/// State when profile update is successful
class ProfileUpdateSuccess extends ProfileState {
  const ProfileUpdateSuccess({
    required this.profile,
  });

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

/// State when uploading avatar
class ProfileAvatarUploading extends ProfileState {
  const ProfileAvatarUploading({
    required this.currentProfile,
  });

  final UserProfile currentProfile;

  @override
  List<Object?> get props => [currentProfile];
}

/// State when avatar upload is successful
class ProfileAvatarUploadSuccess extends ProfileState {
  const ProfileAvatarUploadSuccess({
    required this.profile,
    required this.avatarUrl,
  });

  final UserProfile profile;
  final String avatarUrl;

  @override
  List<Object?> get props => [profile, avatarUrl];
}

/// State when searching users
class ProfileSearchLoading extends ProfileState {
  const ProfileSearchLoading();
}

/// State when user search is successful
class ProfileSearchLoaded extends ProfileState {
  const ProfileSearchLoaded({
    required this.users,
    required this.query,
    required this.hasMore,
  });

  final List<UserProfile> users;
  final String query;
  final bool hasMore;

  @override
  List<Object?> get props => [users, query, hasMore];
}

/// State when profile operation fails
class ProfileError extends ProfileState {
  const ProfileError({
    required this.message,
    this.currentProfile,
  });

  final String message;
  final UserProfile? currentProfile;

  @override
  List<Object?> get props => [message, currentProfile];
}

/// State when refreshing profile data
class ProfileRefreshing extends ProfileState {
  const ProfileRefreshing({
    required this.currentProfile,
  });

  final UserProfile currentProfile;

  @override
  List<Object?> get props => [currentProfile];
}