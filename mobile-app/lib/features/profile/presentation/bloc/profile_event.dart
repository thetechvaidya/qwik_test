import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user profile
class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Event to update user profile
class ProfileUpdateRequested extends ProfileEvent {
  const ProfileUpdateRequested({
    required this.userId,
    required this.updates,
  });

  final String userId;
  final Map<String, dynamic> updates;

  @override
  List<Object?> get props => [userId, updates];
}

/// Event to upload avatar
class ProfileAvatarUploadRequested extends ProfileEvent {
  const ProfileAvatarUploadRequested({
    required this.userId,
    required this.imagePath,
  });

  final String userId;
  final String imagePath;

  @override
  List<Object?> get props => [userId, imagePath];
}

/// Event to delete avatar
class ProfileAvatarDeleteRequested extends ProfileEvent {
  const ProfileAvatarDeleteRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Event to load user stats
class ProfileStatsLoadRequested extends ProfileEvent {
  const ProfileStatsLoadRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Event to load subscription info
class ProfileSubscriptionLoadRequested extends ProfileEvent {
  const ProfileSubscriptionLoadRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Event to search users
class ProfileSearchRequested extends ProfileEvent {
  const ProfileSearchRequested({
    required this.query,
    this.page = 1,
    this.limit = 20,
  });

  final String query;
  final int page;
  final int limit;

  @override
  List<Object?> get props => [query, page, limit];
}

/// Event to clear profile error
class ProfileErrorCleared extends ProfileEvent {
  const ProfileErrorCleared();
}

/// Event to refresh profile data
class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}