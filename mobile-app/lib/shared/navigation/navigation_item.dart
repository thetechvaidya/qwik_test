import 'package:flutter/material.dart';

/// Represents a navigation item with icon, label, and route information
class NavigationItem {
  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
    this.badge,
    this.tooltip,
    this.isEnabled = true,
  });

  /// The icon to display when the item is not selected
  final IconData icon;

  /// The icon to display when the item is selected
  final IconData selectedIcon;

  /// The text label for the navigation item
  final String label;

  /// The route path associated with this navigation item
  final String route;

  /// Optional badge to display on the navigation item
  final Widget? badge;

  /// Optional tooltip text for accessibility
  final String? tooltip;

  /// Whether the navigation item is enabled
  final bool isEnabled;

  /// Creates a copy of this NavigationItem with the given fields replaced
  NavigationItem copyWith({
    IconData? icon,
    IconData? selectedIcon,
    String? label,
    String? route,
    Widget? badge,
    String? tooltip,
    bool? isEnabled,
  }) {
    return NavigationItem(
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      label: label ?? this.label,
      route: route ?? this.route,
      badge: badge ?? this.badge,
      tooltip: tooltip ?? this.tooltip,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationItem &&
        other.icon == icon &&
        other.selectedIcon == selectedIcon &&
        other.label == label &&
        other.route == route &&
        other.badge == badge &&
        other.tooltip == tooltip &&
        other.isEnabled == isEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      icon,
      selectedIcon,
      label,
      route,
      badge,
      tooltip,
      isEnabled,
    );
  }

  @override
  String toString() {
    return 'NavigationItem('
        'icon: $icon, '
        'selectedIcon: $selectedIcon, '
        'label: $label, '
        'route: $route, '
        'badge: $badge, '
        'tooltip: $tooltip, '
        'isEnabled: $isEnabled'
        ')';
  }
}

/// Extension methods for NavigationItem
extension NavigationItemExtension on NavigationItem {
  /// Converts this NavigationItem to a NavigationDestination for Material 3 NavigationBar
  NavigationDestination toNavigationDestination() {
    Widget iconWidget = Icon(icon);
    Widget selectedIconWidget = Icon(selectedIcon);
    
    // Wrap icons with Tooltip if tooltip is provided
    if (tooltip != null) {
      iconWidget = Tooltip(
        message: tooltip!,
        child: iconWidget,
      );
      selectedIconWidget = Tooltip(
        message: tooltip!,
        child: selectedIconWidget,
      );
    }
    
    return NavigationDestination(
      icon: iconWidget,
      selectedIcon: selectedIconWidget,
      label: label,
    );
  }

  /// Converts this NavigationItem to a NavigationRailDestination for NavigationRail
  NavigationRailDestination toNavigationRailDestination() {
    Widget iconWidget = badge != null
        ? Badge(
            label: badge,
            child: Icon(icon),
          )
        : Icon(icon);
    
    Widget selectedIconWidget = badge != null
        ? Badge(
            label: badge,
            child: Icon(selectedIcon),
          )
        : Icon(selectedIcon);
    
    // Wrap icons with Tooltip if tooltip is provided
    if (tooltip != null) {
      iconWidget = Tooltip(
        message: tooltip!,
        child: iconWidget,
      );
      selectedIconWidget = Tooltip(
        message: tooltip!,
        child: selectedIconWidget,
      );
    }
    
    return NavigationRailDestination(
      icon: iconWidget,
      selectedIcon: selectedIconWidget,
      label: Text(label),
    );
  }

  /// Converts this NavigationItem to a BottomNavigationBarItem for legacy BottomNavigationBar
  BottomNavigationBarItem toBottomNavigationBarItem() {
    return BottomNavigationBarItem(
      icon: badge != null
          ? Badge(
              label: badge,
              child: Icon(icon),
            )
          : Icon(icon),
      activeIcon: badge != null
          ? Badge(
              label: badge,
              child: Icon(selectedIcon),
            )
          : Icon(selectedIcon),
      label: label,
      tooltip: tooltip,
    );
  }
}