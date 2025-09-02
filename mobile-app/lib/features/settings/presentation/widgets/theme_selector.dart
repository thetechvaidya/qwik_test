import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({Key? key}) : super(key: key);

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  @override
  void initState() {
    super.initState();
    context.read<ThemeBloc>().add(ThemeAvailableLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<ThemeBloc, ThemeState>(
      listener: (context, state) {
        if (state is ThemeChangeSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Theme changed to ${state.theme}'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ThemeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Theme',
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
            ),
            const SizedBox(height: 16),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                if (state is ThemeLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  );
                }
                
                return Column(
                  children: [
                    _buildSystemThemeOption(context, state),
                    const Divider(height: 1),
                    ..._buildThemeOptions(context, state),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemThemeOption(BuildContext context, ThemeState state) {
    final isSelected = state is ThemeSystemEnabled;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.brightness_auto,
          color: Colors.grey,
          size: 20,
        ),
      ),
      title: const Text(
        'System',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: const Text('Follow system theme'),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        context.read<ThemeBloc>().add(ThemeSystemRequested());
      },
    );
  }

  List<Widget> _buildThemeOptions(BuildContext context, ThemeState state) {
    final availableThemes = _getAvailableThemes(state);
    final currentTheme = _getCurrentTheme(state);
    
    return availableThemes.map((themeData) {
      final isSelected = currentTheme == themeData.name && state is! ThemeSystemEnabled;
      
      return Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeData.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                themeData.icon,
                color: themeData.primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              themeData.displayName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(themeData.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildColorPreview(themeData.primaryColor),
                const SizedBox(width: 8),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
            onTap: () {
              context.read<ThemeBloc>().add(
                ThemeChangeRequested(theme: themeData.name),
              );
            },
          ),
          if (themeData != availableThemes.last)
            const Divider(height: 1, indent: 56),
        ],
      );
    }).toList();
  }

  Widget _buildColorPreview(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }

  List<AppThemeData> _getAvailableThemes(ThemeState state) {
    // Default themes if not loaded from state
    return [
      AppThemeData(
        name: 'light',
        displayName: 'Light',
        description: 'Clean and bright theme',
        icon: Icons.light_mode,
        primaryColor: Colors.blue,
      ),
      AppThemeData(
        name: 'dark',
        displayName: 'Dark',
        description: 'Easy on the eyes',
        icon: Icons.dark_mode,
        primaryColor: Colors.blue,
      ),
      AppThemeData(
        name: 'blue',
        displayName: 'Ocean Blue',
        description: 'Calm and professional',
        icon: Icons.water,
        primaryColor: Colors.blue,
      ),
      AppThemeData(
        name: 'green',
        displayName: 'Forest Green',
        description: 'Natural and refreshing',
        icon: Icons.eco,
        primaryColor: Colors.green,
      ),
      AppThemeData(
        name: 'purple',
        displayName: 'Royal Purple',
        description: 'Creative and elegant',
        icon: Icons.palette,
        primaryColor: Colors.purple,
      ),
      AppThemeData(
        name: 'orange',
        displayName: 'Sunset Orange',
        description: 'Warm and energetic',
        icon: Icons.wb_sunny,
        primaryColor: Colors.orange,
      ),
    ];
  }

  String _getCurrentTheme(ThemeState state) {
    if (state is ThemeLoaded) {
      return state.currentTheme;
    }
    return 'light';
  }
}

class AppThemeData {
  const AppThemeData({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.primaryColor,
  });

  final String name;
  final String displayName;
  final String description;
  final IconData icon;
  final Color primaryColor;
}