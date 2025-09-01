import 'package:flutter/material.dart';
import 'navigation_item.dart';

/// A NavigationRail component for tablet and desktop layouts
class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.extended = false,
    this.minWidth,
    this.minExtendedWidth,
    this.groupAlignment,
    this.labelType,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.indicatorColor,
    this.indicatorShape,
    this.leading,
    this.trailing,
    this.useIndicator,
  });

  /// List of navigation destinations
  final List<NavigationItem> destinations;

  /// Currently selected destination index
  final int selectedIndex;

  /// Callback when a destination is selected
  final ValueChanged<int> onDestinationSelected;

  /// Background color of the navigation rail
  final Color? backgroundColor;

  /// Whether the navigation rail is in extended mode
  final bool extended;

  /// Minimum width of the navigation rail
  final double? minWidth;

  /// Minimum width when extended
  final double? minExtendedWidth;

  /// Alignment of the destination group
  final double? groupAlignment;

  /// Type of labels to show
  final NavigationRailLabelType? labelType;

  /// Text style for unselected labels
  final TextStyle? unselectedLabelTextStyle;

  /// Text style for selected labels
  final TextStyle? selectedLabelTextStyle;

  /// Icon theme for unselected icons
  final IconThemeData? unselectedIconTheme;

  /// Icon theme for selected icons
  final IconThemeData? selectedIconTheme;

  /// Elevation of the navigation rail
  final double? elevation;

  /// Shadow color of the navigation rail
  final Color? shadowColor;

  /// Surface tint color for Material 3 theming
  final Color? surfaceTintColor;

  /// Color of the selection indicator
  final Color? indicatorColor;

  /// Shape of the selection indicator
  final ShapeBorder? indicatorShape;

  /// Widget to display at the top of the rail
  final Widget? leading;

  /// Widget to display at the bottom of the rail
  final Widget? trailing;

  /// Whether to use the selection indicator
  final bool? useIndicator;

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

    return NavigationRail(
      destinations: enabledDestinations
          .map((entry) => entry.value.toNavigationRailDestination())
          .toList(),
      selectedIndex: filteredSelectedIndex,
      onDestinationSelected: (index) {
        // Map back to original index
        final originalIndex = enabledDestinations[index].key;
        onDestinationSelected(originalIndex);
      },
      backgroundColor: backgroundColor,
      extended: extended,
      minWidth: minWidth,
      minExtendedWidth: minExtendedWidth,
      groupAlignment: groupAlignment,
      labelType: labelType,
      unselectedLabelTextStyle: unselectedLabelTextStyle,
      selectedLabelTextStyle: selectedLabelTextStyle,
      unselectedIconTheme: unselectedIconTheme,
      selectedIconTheme: selectedIconTheme,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      indicatorColor: indicatorColor,
      indicatorShape: indicatorShape,
      leading: leading,
      trailing: trailing,
      useIndicator: useIndicator,
    );
  }
}

/// A collapsible navigation rail that can expand/collapse
class CollapsibleNavigationRail extends StatefulWidget {
  const CollapsibleNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.minWidth,
    this.minExtendedWidth,
    this.groupAlignment,
    this.labelType,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.indicatorColor,
    this.indicatorShape,
    this.leading,
    this.trailing,
    this.useIndicator,
    this.initiallyExtended = false,
    this.onExtendedChanged,
    this.toggleButton,
  });

  /// List of navigation destinations
  final List<NavigationItem> destinations;

  /// Currently selected destination index
  final int selectedIndex;

  /// Callback when a destination is selected
  final ValueChanged<int> onDestinationSelected;

  /// Background color of the navigation rail
  final Color? backgroundColor;

  /// Minimum width of the navigation rail
  final double? minWidth;

  /// Minimum width when extended
  final double? minExtendedWidth;

  /// Alignment of the destination group
  final double? groupAlignment;

  /// Type of labels to show
  final NavigationRailLabelType? labelType;

  /// Text style for unselected labels
  final TextStyle? unselectedLabelTextStyle;

  /// Text style for selected labels
  final TextStyle? selectedLabelTextStyle;

  /// Icon theme for unselected icons
  final IconThemeData? unselectedIconTheme;

  /// Icon theme for selected icons
  final IconThemeData? selectedIconTheme;

  /// Elevation of the navigation rail
  final double? elevation;

  /// Shadow color of the navigation rail
  final Color? shadowColor;

  /// Surface tint color for Material 3 theming
  final Color? surfaceTintColor;

  /// Color of the selection indicator
  final Color? indicatorColor;

  /// Shape of the selection indicator
  final ShapeBorder? indicatorShape;

  /// Widget to display at the top of the rail
  final Widget? leading;

  /// Widget to display at the bottom of the rail
  final Widget? trailing;

  /// Whether to use the selection indicator
  final bool? useIndicator;

  /// Whether the rail is initially extended
  final bool initiallyExtended;

  /// Callback when extended state changes
  final ValueChanged<bool>? onExtendedChanged;

  /// Custom toggle button widget
  final Widget? toggleButton;

  @override
  State<CollapsibleNavigationRail> createState() => _CollapsibleNavigationRailState();
}

class _CollapsibleNavigationRailState extends State<CollapsibleNavigationRail>
    with SingleTickerProviderStateMixin {
  late bool _extended;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _extended = widget.initiallyExtended;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    if (_extended) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExtended() {
    setState(() {
      _extended = !_extended;
      if (_extended) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      widget.onExtendedChanged?.call(_extended);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final toggleButton = widget.toggleButton ??
            IconButton(
              icon: AnimatedRotation(
                turns: _animation.value * 0.5,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.menu),
              ),
              onPressed: _toggleExtended,
              tooltip: _extended ? 'Collapse menu' : 'Expand menu',
            );
            
        return AppNavigationRail(
          destinations: widget.destinations,
          selectedIndex: widget.selectedIndex,
          onDestinationSelected: widget.onDestinationSelected,
          backgroundColor: widget.backgroundColor,
          extended: _extended,
          minWidth: widget.minWidth,
          minExtendedWidth: widget.minExtendedWidth,
          groupAlignment: widget.groupAlignment,
          labelType: widget.labelType,
          unselectedLabelTextStyle: widget.unselectedLabelTextStyle,
          selectedLabelTextStyle: widget.selectedLabelTextStyle,
          unselectedIconTheme: widget.unselectedIconTheme,
          selectedIconTheme: widget.selectedIconTheme,
          elevation: widget.elevation,
          shadowColor: widget.shadowColor,
          surfaceTintColor: widget.surfaceTintColor,
          indicatorColor: widget.indicatorColor,
          indicatorShape: widget.indicatorShape,
          leading: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.leading != null) widget.leading!,
              toggleButton,
            ],
          ),
          trailing: widget.trailing,
          useIndicator: widget.useIndicator,
        );
      },
    );
  }
}