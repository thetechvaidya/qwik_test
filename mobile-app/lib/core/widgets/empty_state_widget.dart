import 'package:flutter/material.dart';

/// A reusable empty state widget with customizable appearance and actions
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? illustration;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? customAction;
  final EdgeInsetsGeometry? padding;
  final bool showIcon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.illustration,
    this.actionText,
    this.onAction,
    this.customAction,
    this.padding,
    this.showIcon = true,
  });

  /// Factory constructor for empty search results
  factory EmptyStateWidget.search({
    String? query,
    VoidCallback? onClearFilters,
  }) {
    return EmptyStateWidget(
      title: 'No results found',
      subtitle: query != null
          ? 'No results found for "$query". Try adjusting your search terms or filters.'
          : 'Try adjusting your search terms or filters.',
      icon: Icons.search_off,
      actionText: 'Clear Filters',
      onAction: onClearFilters,
    );
  }

  /// Factory constructor for empty lists
  factory EmptyStateWidget.list({
    required String itemName,
    VoidCallback? onRefresh,
  }) {
    return EmptyStateWidget(
      title: 'No $itemName found',
      subtitle: 'There are no $itemName available at the moment.',
      icon: Icons.inbox_outlined,
      actionText: 'Refresh',
      onAction: onRefresh,
    );
  }

  /// Factory constructor for empty favorites
  factory EmptyStateWidget.favorites({
    VoidCallback? onExplore,
  }) {
    return EmptyStateWidget(
      title: 'No favorites yet',
      subtitle: 'Items you mark as favorites will appear here.',
      icon: Icons.favorite_border,
      actionText: 'Explore',
      onAction: onExplore,
    );
  }

  /// Factory constructor for empty history
  factory EmptyStateWidget.history({
    VoidCallback? onExplore,
  }) {
    return EmptyStateWidget(
      title: 'No history yet',
      subtitle: 'Your activity history will appear here.',
      icon: Icons.history,
      actionText: 'Start Exploring',
      onAction: onExplore,
    );
  }

  /// Factory constructor for empty notifications
  factory EmptyStateWidget.notifications() {
    return const EmptyStateWidget(
      title: 'No notifications',
      subtitle: 'You\'re all caught up! New notifications will appear here.',
      icon: Icons.notifications_none,
    );
  }

  /// Factory constructor for offline state
  factory EmptyStateWidget.offline({
    VoidCallback? onRetry,
  }) {
    return EmptyStateWidget(
      title: 'You\'re offline',
      subtitle: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      actionText: 'Retry',
      onAction: onRetry,
    );
  }

  /// Factory constructor for maintenance mode
  factory EmptyStateWidget.maintenance() {
    return const EmptyStateWidget(
      title: 'Under Maintenance',
      subtitle: 'We\'re currently performing maintenance. Please check back later.',
      icon: Icons.build_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (illustration != null)
              illustration!
            else if (showIcon && icon != null) ...[

              Icon(
                icon,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[

              const SizedBox(height: 12),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            if (customAction != null)
              customAction!
            else if (onAction != null && actionText != null)
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(actionText!),
              ),
          ],
        ),
      ),
    );
  }
}

/// A compact empty state widget for smaller spaces
class CompactEmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;

  const CompactEmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[

            Icon(
              icon,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
          ],
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionText != null) ...[

            const SizedBox(height: 16),
            TextButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state widget specifically for list views
class ListEmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;

  const ListEmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyStateWidget(
        title: title,
        subtitle: subtitle,
        icon: icon,
        onAction: onAction,
        actionText: actionText,
      ),
    );
  }
}