import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';
// Removed imports for user_stats and subscription_info

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
  });

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];

  ProfileLoaded copyWith({
    UserProfile? profile,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
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

// Removed ProfileSearchLoading and ProfileSearchLoaded states

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