import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);

  const SettingsTile.switchTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    this.enabled = true,
  }) : trailing = Switch(
         value: value,
         onChanged: enabled ? onChanged : null,
       ),
       onTap = null,
       super(key: key);

  const SettingsTile.sliderTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required double value,
    required ValueChanged<double>? onChanged,
    double min = 0.0,
    double max = 1.0,
    int? divisions,
    this.enabled = true,
  }) : trailing = SizedBox(
         width: 120,
         child: Slider(
           value: value,
           onChanged: enabled ? onChanged : null,
           min: min,
           max: max,
           divisions: divisions,
         ),
       ),
       onTap = null,
       super(key: key);

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      enabled: enabled,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled 
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: enabled 
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.4),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: enabled 
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withOpacity(0.4),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: enabled 
                    ? theme.colorScheme.onSurface.withOpacity(0.7)
                    : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            )
          : null,
      trailing: trailing ?? (
        onTap != null
            ? Icon(
                Icons.chevron_right,
                color: enabled 
                    ? theme.colorScheme.onSurface.withOpacity(0.4)
                    : theme.colorScheme.onSurface.withOpacity(0.2),
              )
            : null
      ),
      onTap: enabled ? onTap : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
    );
  }
}

class SettingsTileGroup extends StatelessWidget {
  const SettingsTileGroup({
    Key? key,
    required this.children,
    this.margin,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: _buildChildrenWithDividers(),
      ),
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    final List<Widget> result = [];
    
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      
      // Add divider between items (but not after the last item)
      if (i < children.length - 1) {
        result.add(
          const Divider(
            height: 1,
            indent: 56, // Align with the text after the icon
          ),
        );
      }
    }
    
    return result;
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.padding,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          if (subtitle != null) ..[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}