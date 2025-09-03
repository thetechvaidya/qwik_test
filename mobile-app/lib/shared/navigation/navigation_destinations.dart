import 'package:flutter/material.dart';
import 'navigation_item.dart';

/// Defines all navigation destinations for the app
class NavigationDestinations {
  NavigationDestinations._();

  /// Exams destination
  static const NavigationItem exams = NavigationItem(
    icon: Icons.quiz_outlined,
    selectedIcon: Icons.quiz,
    label: 'Exams',
    route: '/exams',
    tooltip: 'View Exams',
  );



  /// Profile destination
  static const NavigationItem profile = NavigationItem(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: 'Profile',
    route: '/profile',
    tooltip: 'User Profile',
  );

  /// Settings destination
  static const NavigationItem settings = NavigationItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    label: 'Settings',
    route: '/settings',
    tooltip: 'App Settings',
  );



  /// Main navigation destinations (primary navigation)
  static const List<NavigationItem> mainDestinations = [
    exams,
    profile,
  ];

  /// Secondary navigation destinations (drawer/menu items)
  static const List<NavigationItem> secondaryDestinations = [
    settings,
  ];

  /// All navigation destinations
  static const List<NavigationItem> allDestinations = [
    ...mainDestinations,
    ...secondaryDestinations,
  ];

  /// Get navigation item by route
  static NavigationItem? getByRoute(String route) {
    try {
      return allDestinations.firstWhere((item) => item.route == route);
    } catch (e) {
      return null;
    }
  }

  /// Get navigation item index by route
  static int getIndexByRoute(String route, {List<NavigationItem>? destinations}) {
    final items = destinations ?? mainDestinations;
    for (int i = 0; i < items.length; i++) {
      // Check for exact match first
      if (items[i].route == route) {
        return i;
      }
      // Check if the route starts with the destination route (for nested routes)
      // e.g., '/exams/:id' should match '/exams'
      if (route.startsWith('${items[i].route}/') || 
          (items[i].route != '/' && route.startsWith(items[i].route))) {
        return i;
      }
    }
    return 0; // Default to first item if not found
  }

  /// Get route by index
  static String getRouteByIndex(int index, {List<NavigationItem>? destinations}) {
    final items = destinations ?? mainDestinations;
    if (index >= 0 && index < items.length) {
      return items[index].route;
    }
    return items.first.route; // Default to first item if index is out of bounds
  }

  /// Check if route is a main destination
  static bool isMainDestination(String route) {
    return mainDestinations.any((item) => item.route == route);
  }

  /// Check if route is a secondary destination
  static bool isSecondaryDestination(String route) {
    return secondaryDestinations.any((item) => item.route == route);
  }

  /// Get navigation items with badges
  static List<NavigationItem> getDestinationsWithBadges({
    List<NavigationItem>? destinations,
    Map<String, Widget>? customBadges,
  }) {
    final targetDestinations = destinations ?? mainDestinations;
    
    return targetDestinations.map((item) {
      // Add custom badges
      if (customBadges != null && customBadges.containsKey(item.route)) {
        return item.copyWith(badge: customBadges[item.route]);
      }

      return item;
    }).toList();
  }

  /// Get disabled navigation items based on user permissions or app state
  static List<NavigationItem> getDestinationsWithPermissions({
    bool canAccessExams = true,
    bool canAccessProfile = true,
    Map<String, bool>? customPermissions,
  }) {
    return mainDestinations.map((item) {
      bool isEnabled = true;

      // Check built-in permissions
      switch (item.route) {
        case '/exams':
          isEnabled = canAccessExams;
          break;
        case '/profile':
          isEnabled = canAccessProfile;
          break;
      }

      // Check custom permissions
      if (customPermissions != null && customPermissions.containsKey(item.route)) {
        isEnabled = customPermissions[item.route] ?? false;
      }

      return item.copyWith(isEnabled: isEnabled);
    }).toList();
  }
}

/// Extension methods for NavigationDestinations
extension NavigationDestinationsExtension on List<NavigationItem> {
  /// Find navigation item by route
  NavigationItem? findByRoute(String route) {
    try {
      return firstWhere((item) => item.route == route);
    } catch (e) {
      return null;
    }
  }

  /// Get index by route
  int indexByRoute(String route) {
    for (int i = 0; i < length; i++) {
      // Check for exact match first
      if (this[i].route == route) {
        return i;
      }
      // Check if the route starts with the destination route (for nested routes)
      if (route.startsWith('${this[i].route}/') || 
          (this[i].route != '/' && route.startsWith(this[i].route))) {
        return i;
      }
    }
    return 0;
  }

  /// Get route by index
  String routeByIndex(int index) {
    if (index >= 0 && index < length) {
      return this[index].route;
    }
    return isNotEmpty ? first.route : '/';
  }

  /// Filter enabled destinations
  List<NavigationItem> get enabledOnly {
    return where((item) => item.isEnabled).toList();
  }

  /// Filter disabled destinations
  List<NavigationItem> get disabledOnly {
    return where((item) => !item.isEnabled).toList();
  }

  /// Get destinations with badges
  List<NavigationItem> get withBadges {
    return where((item) => item.badge != null).toList();
  }

  /// Get destinations without badges
  List<NavigationItem> get withoutBadges {
    return where((item) => item.badge == null).toList();
  }
}