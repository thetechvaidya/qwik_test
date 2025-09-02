import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/profile_actions.dart';
import '../widgets/subscription_info_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    context.read<ProfileBloc>().add(
      ProfileLoadRequested(userId: widget.userId),
    );
    context.read<ProfileBloc>().add(
      ProfileStatsLoadRequested(userId: widget.userId),
    );
    context.read<ProfileBloc>().add(
      ProfileSubscriptionLoadRequested(userId: widget.userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshProfile(),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: _loadProfile,
                ),
              ),
            );
          } else if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileAvatarUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Avatar updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProfileError && state.currentProfile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load profile',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded ||
              state is ProfileUpdating ||
              state is ProfileAvatarUploading ||
              state is ProfileRefreshing ||
              (state is ProfileError && state.currentProfile != null)) {
            final profile = state is ProfileLoaded
                ? state.profile
                : state is ProfileUpdating
                    ? state.currentProfile
                    : state is ProfileAvatarUploading
                        ? state.currentProfile
                        : state is ProfileRefreshing
                            ? state.currentProfile
                            : (state as ProfileError).currentProfile!;

            final stats = state is ProfileLoaded ? state.stats : null;
            final subscriptionInfo = state is ProfileLoaded ? state.subscriptionInfo : null;
            final isLoading = state is ProfileUpdating ||
                state is ProfileAvatarUploading ||
                state is ProfileRefreshing;

            return RefreshIndicator(
              onRefresh: () async => _refreshProfile(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(
                      profile: profile,
                      isLoading: isLoading,
                      onAvatarTap: _showAvatarOptions,
                    ),
                    const SizedBox(height: 24),
                    if (stats != null) ..[
                      ProfileStatsCard(stats: stats),
                      const SizedBox(height: 16),
                    ],
                    if (subscriptionInfo != null) ..[
                      SubscriptionInfoCard(subscriptionInfo: subscriptionInfo),
                      const SizedBox(height: 16),
                    ],
                    ProfileActions(
                      profile: profile,
                      onEditProfile: _navigateToEditProfile,
                      onViewAchievements: _navigateToAchievements,
                      onViewActivity: _navigateToActivity,
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _refreshProfile() {
    context.read<ProfileBloc>().add(
      ProfileRefreshRequested(userId: widget.userId),
    );
  }

  void _navigateToEditProfile() {
    // Navigate to edit profile page
    // Navigator.of(context).pushNamed('/profile/edit', arguments: widget.userId);
  }

  void _navigateToAchievements() {
    // Navigate to achievements page
    // Navigator.of(context).pushNamed('/profile/achievements', arguments: widget.userId);
  }

  void _navigateToActivity() {
    // Navigate to activity page
    // Navigator.of(context).pushNamed('/profile/activity', arguments: widget.userId);
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _chooseFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove Avatar'),
              onTap: () {
                Navigator.pop(context);
                _removeAvatar();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _takePhoto() {
    // Implement camera functionality
    // This would typically use image_picker package
  }

  void _chooseFromGallery() {
    // Implement gallery selection
    // This would typically use image_picker package
  }

  void _removeAvatar() {
    context.read<ProfileBloc>().add(
      ProfileAvatarDeleteRequested(userId: widget.userId),
    );
  }
}