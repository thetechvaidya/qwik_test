import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_selector.dart';
import '../widgets/notification_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    context.read<SettingsBloc>().add(
      const SettingsLoadRequested(userId: 'current_user'),
    );
    context.read<ThemeBloc>().add(ThemeLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: _showResetDialog,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is SettingsUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is SettingsResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings reset to defaults'),
                backgroundColor: Colors.blue,
              ),
            );
          }
        },
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
                      size: 64,
                      color: Colors.red.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadSettings,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SettingsBloc>().add(
                  const SettingsRefreshRequested(userId: 'current_user'),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppearanceSection(context),
                    const SizedBox(height: 24),
                    _buildNotificationSection(context),
                    const SizedBox(height: 24),
                    _buildPreferencesSection(context),
                    const SizedBox(height: 24),
                    _buildDataSection(context),
                    const SizedBox(height: 24),
                    _buildAboutSection(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return SettingsSection(
      title: 'Appearance',
      children: [
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return SettingsTile(
              icon: Icons.palette,
              title: 'Theme',
              subtitle: _getThemeDescription(themeState),
              onTap: () => _showThemeSelector(context),
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoaded) {
              return SettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: state.settings.language,
                onTap: () => _showLanguageSelector(context),
              );
            }
            return const SettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Loading...',
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    return SettingsSection(
      title: 'Notifications',
      children: [
        SettingsTile(
          icon: Icons.notifications,
          title: 'Notification Settings',
          subtitle: 'Manage your notification preferences',
          onTap: () => _showNotificationSettings(context),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoaded) {
          return const SizedBox.shrink();
        }
        
        return SettingsSection(
          title: 'Preferences',
          children: [
            SettingsTile.switchTile(
              icon: Icons.offline_pin,
              title: 'Offline Mode',
              subtitle: 'Download content for offline access',
              value: state.settings.offlineMode,
              onChanged: (value) {
                final updatedSettings = state.settings.copyWith(
                  offlineMode: value,
                );
                context.read<SettingsBloc>().add(
                  SettingsUpdateRequested(settings: updatedSettings),
                );
              },
            ),
            SettingsTile.switchTile(
              icon: Icons.auto_awesome,
              title: 'Auto-sync',
              subtitle: 'Automatically sync your progress',
              value: state.settings.autoSync,
              onChanged: (value) {
                final updatedSettings = state.settings.copyWith(
                  autoSync: value,
                );
                context.read<SettingsBloc>().add(
                  SettingsUpdateRequested(settings: updatedSettings),
                );
              },
            ),
            SettingsTile.switchTile(
              icon: Icons.analytics,
              title: 'Analytics',
              subtitle: 'Help improve the app with usage data',
              value: state.settings.analyticsEnabled,
              onChanged: (value) {
                final updatedSettings = state.settings.copyWith(
                  analyticsEnabled: value,
                );
                context.read<SettingsBloc>().add(
                  SettingsUpdateRequested(settings: updatedSettings),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return SettingsSection(
      title: 'Data & Storage',
      children: [
        SettingsTile(
          icon: Icons.storage,
          title: 'Storage Usage',
          subtitle: 'View app storage usage',
          onTap: () => _showStorageInfo(context),
        ),
        SettingsTile(
          icon: Icons.cloud_sync,
          title: 'Sync Data',
          subtitle: 'Sync your data with the cloud',
          onTap: () => _syncData(context),
        ),
        SettingsTile(
          icon: Icons.delete_sweep,
          title: 'Clear Cache',
          subtitle: 'Free up space by clearing cache',
          onTap: () => _showClearCacheDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return SettingsSection(
      title: 'About',
      children: [
        SettingsTile(
          icon: Icons.info,
          title: 'App Version',
          subtitle: '1.0.0',
        ),
        SettingsTile(
          icon: Icons.description,
          title: 'Terms of Service',
          onTap: () => _showTermsOfService(context),
        ),
        SettingsTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          onTap: () => _showPrivacyPolicy(context),
        ),
        SettingsTile(
          icon: Icons.help,
          title: 'Help & Support',
          onTap: () => _showHelpSupport(context),
        ),
      ],
    );
  }

  String _getThemeDescription(ThemeState state) {
    if (state is ThemeLoaded) {
      return state.currentTheme;
    } else if (state is ThemeSystemEnabled) {
      return 'System';
    }
    return 'Light';
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ThemeSelector(),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    context.read<SettingsBloc>().add(AvailableLanguagesLoadRequested());
    
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded && state.availableLanguages.isNotEmpty) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Select Language',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...state.availableLanguages.map(
                    (language) => ListTile(
                      title: Text(language),
                      trailing: state.settings.language == language
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        final updatedSettings = state.settings.copyWith(
                          language: language,
                        );
                        context.read<SettingsBloc>().add(
                          SettingsUpdateRequested(settings: updatedSettings),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const NotificationSettings(),
    );
  }

  void _showStorageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Usage'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Data: 25.3 MB'),
            Text('Cache: 12.7 MB'),
            Text('Offline Content: 156.2 MB'),
            Divider(),
            Text('Total: 194.2 MB', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _syncData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Syncing data...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data and free up storage space. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('This will reset all settings to their default values. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SettingsBloc>().add(
                const SettingsResetRequested(userId: 'current_user'),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    // Navigate to terms of service page
  }

  void _showPrivacyPolicy(BuildContext context) {
    // Navigate to privacy policy page
  }

  void _showHelpSupport(BuildContext context) {
    // Navigate to help and support page
  }
}