import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({
    Key? key,
    this.onEditProfile,
    this.onSettings,
    this.onShare,
    this.isOwnProfile = true,
  }) : super(key: key);

  final VoidCallback? onEditProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onShare;
  final bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (isOwnProfile) ..._buildOwnProfileActions(context)
            else ..._buildOtherProfileActions(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOwnProfileActions(BuildContext context) {
    return [
      _buildActionButton(
        context,
        icon: Icons.edit,
        label: 'Edit Profile',
        subtitle: 'Update your information',
        onTap: onEditProfile,
        color: Colors.blue,
      ),

      const SizedBox(height: 12),
      _buildActionButton(
        context,
        icon: Icons.settings,
        label: 'Settings',
        subtitle: 'Manage your preferences',
        onTap: onSettings,
        color: Colors.grey,
      ),
      const SizedBox(height: 12),
      _buildActionButton(
        context,
        icon: Icons.share,
        label: 'Share Profile',
        subtitle: 'Share your achievements',
        onTap: onShare,
        color: Colors.purple,
      ),
    ];
  }

  List<Widget> _buildOtherProfileActions(BuildContext context) {
    return [

      _buildActionButton(
        context,
        icon: Icons.share,
        label: 'Share Profile',
        subtitle: 'Share this profile',
        onTap: onShare,
        color: Colors.purple,
      ),
    ];
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}