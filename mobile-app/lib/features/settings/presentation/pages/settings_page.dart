import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Settings are loaded by router, only load theme here
    context.read<ThemeBloc>().add(ThemeLoadRequested());
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
                      color: Colors.red.withAlpha((255 * 0.6).round()),
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
                subtitle: state.settings.preferences.language,
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



  Widget _buildAboutSection(BuildContext context) {
    return SettingsSection(
      title: 'About',
      children: [
        SettingsTile(
          icon: Icons.info,
          title: 'App Version',
          subtitle: AppConstants.appVersion,
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
                      trailing: state.settings.preferences.language == language
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        final updatedSettings = state.settings.copyWith(
                          preferences: state.settings.preferences.copyWith(
                            language: language,
                          ),
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


}