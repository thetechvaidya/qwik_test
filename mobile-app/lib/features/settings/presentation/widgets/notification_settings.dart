import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import 'settings_tile.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(
      const NotificationSettingsLoadRequested(userId: 'current_user'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is NotificationSettingsUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification settings updated'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (state is SettingsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.withAlpha((255 * 0.6).round()),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load notification settings',
                            style: theme.textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<SettingsBloc>().add(
                                const NotificationSettingsLoadRequested(
                                  userId: 'current_user',
                                ),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildNotificationSettings(context, state),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notification Settings',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, SettingsState state) {
    if (state is! SettingsLoaded || state.notificationSettings == null) {
      return const SizedBox.shrink();
    }
    
    final notificationSettings = state.notificationSettings!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGeneralSection(context, state, notificationSettings),
        const SizedBox(height: 24),
        _buildExamSection(context, state, notificationSettings),
        const SizedBox(height: 24),
        _buildSocialSection(context, state, notificationSettings),
        const SizedBox(height: 24),
        _buildSystemSection(context, state, notificationSettings),
        const SizedBox(height: 24),
        _buildQuietHoursSection(context, state, notificationSettings),
      ],
    );
  }

  Widget _buildGeneralSection(BuildContext context, SettingsState state, dynamic notificationSettings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('General'),
        const SizedBox(height: 8),
        SettingsTileGroup(
          children: [
            SettingsTile.switchTile(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive notifications on this device',
              value: notificationSettings.pushEnabled ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(pushEnabled: value),
              ),
            ),
            SettingsTile.switchTile(
              icon: Icons.email,
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              value: notificationSettings.emailEnabled ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(emailEnabled: value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExamSection(BuildContext context, SettingsState state, dynamic notificationSettings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Exams & Learning'),
        const SizedBox(height: 8),
        SettingsTileGroup(
          children: [
            SettingsTile.switchTile(
              icon: Icons.quiz,
              title: 'Exam Reminders',
              subtitle: 'Get reminded about upcoming exams',
              value: notificationSettings.examReminders ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(examReminders: value),
              ),
            ),
            SettingsTile.switchTile(
              icon: Icons.school,
              title: 'Study Reminders',
              subtitle: 'Daily reminders to keep studying',
              value: notificationSettings.studyReminders ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(studyReminders: value),
              ),
            ),
            SettingsTile.switchTile(
              icon: Icons.emoji_events,
              title: 'Achievement Notifications',
              subtitle: 'Celebrate your accomplishments',
              value: notificationSettings.achievementNotifications ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(achievementNotifications: value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialSection(BuildContext context, SettingsState state, dynamic notificationSettings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Social'),
        const SizedBox(height: 8),
        SettingsTileGroup(
          children: [
            SettingsTile.switchTile(
              icon: Icons.people,
              title: 'Friend Requests',
              subtitle: 'When someone sends you a friend request',
              value: notificationSettings.friendRequests ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(friendRequests: value),
              ),
            ),
            SettingsTile.switchTile(
              icon: Icons.chat,
              title: 'Messages',
              subtitle: 'New messages from friends',
              value: notificationSettings.messages ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(messages: value),
              ),
            ),
            SettingsTile.switchTile(
              icon: Icons.leaderboard,
              title: 'Leaderboard Updates',
              subtitle: 'Changes in your ranking',
              value: notificationSettings.leaderboardUpdates ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(leaderboardUpdates: value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSystemSection(BuildContext context, SettingsState state, dynamic notificationSettings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('System'),
        const SizedBox(height: 8),
        SettingsTileGroup(
          children: [
            SettingsTile.switchTile(
              icon: Icons.system_update,
              title: 'App Updates',
              subtitle: 'New features and improvements',
              value: notificationSettings.appUpdates ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(appUpdates: value),
              ),
            ),
            SettingsTile.switchTile(
              icon: Icons.security,
              title: 'Security Alerts',
              subtitle: 'Important security notifications',
              value: notificationSettings.securityAlerts ?? true,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(securityAlerts: value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuietHoursSection(BuildContext context, SettingsState state, dynamic notificationSettings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Quiet Hours'),
        const SizedBox(height: 8),
        SettingsTileGroup(
          children: [
            SettingsTile.switchTile(
              icon: Icons.bedtime,
              title: 'Enable Quiet Hours',
              subtitle: 'Pause notifications during specified hours',
              value: notificationSettings.quietHoursEnabled ?? false,
              onChanged: (value) => _updateNotificationSettings(
                state,
                notificationSettings.copyWith(quietHoursEnabled: value),
              ),
            ),
            if (notificationSettings.quietHoursEnabled ?? false) ...[
              SettingsTile(
                icon: Icons.schedule,
                title: 'Start Time',
                subtitle: notificationSettings.quietHoursStart ?? '22:00',
                onTap: () => _selectTime(
                  context,
                  'Select start time',
                  notificationSettings.quietHoursStart ?? '22:00',
                  (time) => _updateNotificationSettings(
                    state,
                    notificationSettings.copyWith(quietHoursStart: time),
                  ),
                ),
              ),
              SettingsTile(
                icon: Icons.schedule,
                title: 'End Time',
                subtitle: notificationSettings.quietHoursEnd ?? '08:00',
                onTap: () => _selectTime(
                  context,
                  'Select end time',
                  notificationSettings.quietHoursEnd ?? '08:00',
                  (time) => _updateNotificationSettings(
                    state,
                    notificationSettings.copyWith(quietHoursEnd: time),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _updateNotificationSettings(SettingsState state, dynamic updatedSettings) {
    context.read<SettingsBloc>().add(
      NotificationSettingsUpdateRequested(
        userId: 'current_user',
        settings: updatedSettings,
      ),
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    String title,
    String currentTime,
    Function(String) onTimeSelected,
  ) async {
    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
    
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: title,
    );
    
    if (selectedTime != null) {
      final formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      onTimeSelected(formattedTime);
    }
  }
}