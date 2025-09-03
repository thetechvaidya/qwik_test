import 'package:flutter/material.dart';
import 'navigation_item.dart';

/// A Material 3 NavigationBar component for mobile layouts
class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.surfaceTintColor,
    this.shadowColor,
    this.elevation,
    this.height,
    this.labelBehavior,
    this.animationDuration,
    this.overlayColor,
    this.indicatorColor,
    this.indicatorShape,
  });

  /// List of navigation destinations
  final List<NavigationItem> destinations;

  /// Currently selected destination index
  final int selectedIndex;

  /// Callback when a destination is selected
  final ValueChanged<int> onDestinationSelected;

  /// Background color of the navigation bar
  final Color? backgroundColor;

  /// Surface tint color for Material 3 theming
  final Color? surfaceTintColor;

  /// Shadow color of the navigation bar
  final Color? shadowColor;

  /// Elevation of the navigation bar
  final double? elevation;

  /// Height of the navigation bar
  final double? height;

  /// Label behavior for navigation destinations
  final NavigationDestinationLabelBehavior? labelBehavior;

  /// Animation duration for selection changes
  final Duration? animationDuration;

  /// Overlay color for interactive states
  final WidgetStateProperty<Color?>? overlayColor;

  /// Color of the selection indicator
  final Color? indicatorColor;

  /// Shape of the selection indicator
  final ShapeBorder? indicatorShape;

  @override
  Widget build(BuildContext context) {
    // Guard against empty destinations
    if (destinations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Filter out disabled destinations
    final enabledDestinations = destinations
        .asMap()
        .entries
        .where((entry) => entry.value.isEnabled)
        .toList();

    // Guard against all destinations being disabled
    if (enabledDestinations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Map original indices to filtered indices
    final indexMapping = <int, int>{};
    for (int i = 0; i < enabledDestinations.length; i++) {
      indexMapping[enabledDestinations[i].key] = i;
    }

    // Find the selected index in the filtered list
    final filteredSelectedIndex = indexMapping[selectedIndex] ?? 0;

    return NavigationBar(
      destinations: enabledDestinations
          .map((entry) => entry.value.toNavigationDestination())
          .toList(),
      selectedIndex: filteredSelectedIndex,
      onDestinationSelected: (index) {
        // Map back to original index
        final originalIndex = enabledDestinations[index].key;
        onDestinationSelected(originalIndex);
      },
      backgroundColor: backgroundColor,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      elevation: elevation,
      height: height,
      labelBehavior: labelBehavior,
      animationDuration: animationDuration,
      overlayColor: overlayColor,
      indicatorColor: indicatorColor,
      indicatorShape: indicatorShape,
    );
  }
}

/// A legacy BottomNavigationBar component for compatibility
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.elevation,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.type,
    this.landscapeLayout,
    this.mouseCursor,
    this.enableFeedback,
    this.iconSize,
    this.selectedFontSize,
    this.unselectedFontSize,
  });

  /// List of navigation destinations
  final List<NavigationItem> destinations;

  /// Currently selected destination index
  final int selectedIndex;

  /// Callback when a destination is selected
  final ValueChanged<int> onDestinationSelected;

  /// Background color of the navigation bar
  final Color? backgroundColor;

  /// Elevation of the navigation bar
  final double? elevation;

  /// Color of selected items
  final Color? selectedItemColor;

  /// Color of unselected items
  final Color? unselectedItemColor;

  /// Text style for selected labels
  final TextStyle? selectedLabelStyle;

  /// Text style for unselected labels
  final TextStyle? unselectedLabelStyle;

  /// Whether to show labels for selected items
  final bool showSelectedLabels;

  /// Whether to show labels for unselected items
  final bool showUnselectedLabels;

  /// Type of bottom navigation bar
  final BottomNavigationBarType? type;

  /// Layout for landscape orientation
  final BottomNavigationBarLandscapeLayout? landscapeLayout;

  /// Mouse cursor for interactive elements
  final MouseCursor? mouseCursor;

  /// Whether to enable haptic feedback
  final bool? enableFeedback;

  /// Size of icons
  final double? iconSize;

  /// Font size for selected labels
  final double? selectedFontSize;

  /// Font size for unselected labels
  final double? unselectedFontSize;

  @override
  Widget build(BuildContext context) {
    // Guard against empty destinations
    if (destinations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Filter out disabled destinations
    final enabledDestinations = destinations
        .asMap()
        .entries
        .where((entry) => entry.value.isEnabled)
        .toList();

    // Guard against all destinations being disabled
    if (enabledDestinations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Map original indices to filtered indices
    final indexMapping = <int, int>{};
    for (int i = 0; i < enabledDestinations.length; i++) {
      indexMapping[enabledDestinations[i].key] = i;
    }

    // Find the selected index in the filtered list
    final filteredSelectedIndex = indexMapping[selectedIndex] ?? 0;

    return BottomNavigationBar(
      items: enabledDestinations
          .map((entry) => entry.value.toBottomNavigationBarItem())
          .toList(),
      currentIndex: filteredSelectedIndex,
      onTap: (index) {
        // Map back to original index
        final originalIndex = enabledDestinations[index].key;
        onDestinationSelected(originalIndex);
      },
      backgroundColor: backgroundColor,
      elevation: elevation,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      selectedLabelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels,
      type: type,
      landscapeLayout: landscapeLayout,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      iconSize: iconSize,
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
    );
  }
}