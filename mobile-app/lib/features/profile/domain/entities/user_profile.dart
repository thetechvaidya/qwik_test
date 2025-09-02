import 'package:equatable/equatable.dart';
import 'user_stats.dart';
import 'subscription_info.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    this.location,
    this.website,
    this.socialLinks = const {},
    this.stats,
    this.subscription,
    this.preferences = const {},
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;
  final String? location;
  final String? website;
  final Map<String, String> socialLinks;
  final UserStats? stats;
  final SubscriptionInfo? subscription;
  final Map<String, dynamic> preferences;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatar,
        bio,
        location,
        website,
        socialLinks,
        stats,
        subscription,
        preferences,
        createdAt,
        updatedAt,
      ];

  /// Returns the display name, preferring name over email
  String getDisplayName() {
    return name.isNotEmpty ? name : email.split('@').first;
  }

  /// Checks if user has an avatar
  bool hasAvatar() {
    return avatar != null && avatar!.isNotEmpty;
  }

  /// Returns the avatar URL or null if not available
  String? getAvatarUrl() {
    return hasAvatar() ? avatar : null;
  }

  /// Gets a social media link by platform name
  String? getSocialLink(String platform) {
    return socialLinks[platform.toLowerCase()];
  }

  /// Checks if user has premium subscription
  bool isPremiumUser() {
    return subscription?.isPremium() ?? false;
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? bio,
    String? location,
    String? website,
    Map<String, String>? socialLinks,
    UserStats? stats,
    SubscriptionInfo? subscription,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
      socialLinks: socialLinks ?? this.socialLinks,
      stats: stats ?? this.stats,
      subscription: subscription ?? this.subscription,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, avatar: $avatar, bio: $bio, location: $location, website: $website, socialLinks: $socialLinks, stats: $stats, subscription: $subscription, preferences: $preferences, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}