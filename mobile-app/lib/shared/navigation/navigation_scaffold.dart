import 'package:flutter/material.dart';
import '../../core/responsive/responsive_builder.dart';
import '../../core/responsive/screen_size.dart';
import 'package:flutter/gestures.dart';
import 'navigation_item.dart';
import 'app_navigation_bar.dart';
import 'app_navigation_rail.dart';

/// A unified navigation scaffold that adapts to different screen sizes
class NavigationScaffold extends StatelessWidget {
  const NavigationScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    // Navigation customization
    this.navigationBarHeight,
    this.navigationBarElevation,
    this.navigationBarBackgroundColor,
    this.navigationBarSurfaceTintColor,
    this.navigationBarShadowColor,
    this.navigationBarLabelBehavior,
    this.navigationBarIndicatorColor,
    this.navigationBarIndicatorShape,
    this.navigationRailMinWidth,
    this.navigationRailMinExtendedWidth,
    this.navigationRailExtended = false,
    this.navigationRailGroupAlignment,
    this.navigationRailLabelType,
    this.navigationRailElevation,
    this.navigationRailBackgroundColor,
    this.navigationRailSurfaceTintColor,
    this.navigationRailShadowColor,
    this.navigationRailIndicatorColor,
    this.navigationRailIndicatorShape,
    this.navigationRailLeading,
    this.navigationRailTrailing,
    this.navigationRailUseIndicator,
    this.useCollapsibleRail = false,
    this.onRailExtendedChanged,
    this.customNavigationRailToggle,
  });

  /// List of navigation destinations
  final List<NavigationItem> destinations;

  /// Currently selected destination index
  final int selectedIndex;

  /// Callback when a destination is selected
  final ValueChanged<int> onDestinationSelected;

  /// The primary content of the scaffold
  final Widget body;

  // Standard Scaffold properties
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final DrawerCallback? onDrawerChanged;
  final DrawerCallback? onEndDrawerChanged;

  // Navigation Bar customization
  final double? navigationBarHeight;
  final double? navigationBarElevation;
  final Color? navigationBarBackgroundColor;
  final Color? navigationBarSurfaceTintColor;
  final Color? navigationBarShadowColor;
  final NavigationDestinationLabelBehavior? navigationBarLabelBehavior;
  final Color? navigationBarIndicatorColor;
  final ShapeBorder? navigationBarIndicatorShape;

  // Navigation Rail customization
  final double? navigationRailMinWidth;
  final double? navigationRailMinExtendedWidth;
  final bool navigationRailExtended;
  final double? navigationRailGroupAlignment;
  final NavigationRailLabelType? navigationRailLabelType;
  final double? navigationRailElevation;
  final Color? navigationRailBackgroundColor;
  final Color? navigationRailSurfaceTintColor;
  final Color? navigationRailShadowColor;
  final Color? navigationRailIndicatorColor;
  final ShapeBorder? navigationRailIndicatorShape;
  final Widget? navigationRailLeading;
  final Widget? navigationRailTrailing;
  final bool? navigationRailUseIndicator;
  final bool useCollapsibleRail;
  final ValueChanged<bool>? onRailExtendedChanged;
  final Widget? customNavigationRailToggle;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => _buildMobileLayout(context),
      tablet: (context) => _buildTabletLayout(context),
      desktop: (context) => _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      body: body,
      bottomNavigationBar: AppNavigationBar(
        destinations: destinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: navigationBarBackgroundColor,
        surfaceTintColor: navigationBarSurfaceTintColor,
        shadowColor: navigationBarShadowColor,
        elevation: navigationBarElevation,
        height: navigationBarHeight,
        labelBehavior: navigationBarLabelBehavior,
        indicatorColor: navigationBarIndicatorColor,
        indicatorShape: navigationBarIndicatorShape,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: persistentFooterAlignment,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
      onDrawerChanged: onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged,
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      body: Row(
        children: [
          _buildNavigationRail(),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: persistentFooterAlignment,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
      onDrawerChanged: onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged,
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      body: Row(
        children: [
          _buildNavigationRail(),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: persistentFooterAlignment,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
      onDrawerChanged: onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged,
    );
  }

  Widget _buildNavigationRail() {
    if (useCollapsibleRail) {
      return CollapsibleNavigationRail(
        destinations: destinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: navigationRailBackgroundColor,
        minWidth: navigationRailMinWidth,
        minExtendedWidth: navigationRailMinExtendedWidth,
        groupAlignment: navigationRailGroupAlignment,
        labelType: navigationRailLabelType,
        elevation: navigationRailElevation,
        shadowColor: navigationRailShadowColor,
        surfaceTintColor: navigationRailSurfaceTintColor,
        indicatorColor: navigationRailIndicatorColor,
        indicatorShape: navigationRailIndicatorShape,
        leading: navigationRailLeading,
        trailing: navigationRailTrailing,
        useIndicator: navigationRailUseIndicator,
        initiallyExtended: navigationRailExtended,
        onExtendedChanged: onRailExtendedChanged,
        toggleButton: customNavigationRailToggle,
      );
    }

    return AppNavigationRail(
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: navigationRailBackgroundColor,
      extended: navigationRailExtended,
      minWidth: navigationRailMinWidth,
      minExtendedWidth: navigationRailMinExtendedWidth,
      groupAlignment: navigationRailGroupAlignment,
      labelType: navigationRailLabelType,
      elevation: navigationRailElevation,
      shadowColor: navigationRailShadowColor,
      surfaceTintColor: navigationRailSurfaceTintColor,
      indicatorColor: navigationRailIndicatorColor,
      indicatorShape: navigationRailIndicatorShape,
      leading: navigationRailLeading,
      trailing: navigationRailTrailing,
      useIndicator: navigationRailUseIndicator,
    );
  }
}

/// A simplified version of NavigationScaffold with fewer customization options
class SimpleNavigationScaffold extends StatelessWidget {
  const SimpleNavigationScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendedRailOnDesktop = true,
  });

  /// List of navigation destinations
  final List<NavigationItem> destinations;

  /// Currently selected destination index
  final int selectedIndex;

  /// Callback when a destination is selected
  final ValueChanged<int> onDestinationSelected;

  /// The primary content of the scaffold
  final Widget body;

  /// App bar widget
  final PreferredSizeWidget? appBar;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Background color
  final Color? backgroundColor;

  /// Whether to extend the rail on desktop
  final bool extendedRailOnDesktop;

  @override
  Widget build(BuildContext context) {
    return NavigationScaffold(
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      body: body,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
      navigationRailExtended: extendedRailOnDesktop,
      useCollapsibleRail: true,
    );
  }
}