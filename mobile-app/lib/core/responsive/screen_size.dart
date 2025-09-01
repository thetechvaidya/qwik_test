import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// Enum that defines different screen size categories based on breakpoints
enum ScreenSize {
  mobile,
  tablet,
  desktop;

  /// Determines the screen size category based on the given width
  static ScreenSize fromWidth(double width) {
    if (width < AppDimensions.tabletBreakpoint) {
      return ScreenSize.mobile;
    } else if (width < AppDimensions.desktopBreakpoint) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  /// Determines the screen size category from the current context
  static ScreenSize fromContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return fromWidth(width);
  }

  /// Returns true if this is a mobile screen size
  bool get isMobile => this == ScreenSize.mobile;

  /// Returns true if this is a tablet screen size
  bool get isTablet => this == ScreenSize.tablet;

  /// Returns true if this is a desktop screen size
  bool get isDesktop => this == ScreenSize.desktop;

  /// Returns true if this is mobile or tablet (not desktop)
  bool get isMobileOrTablet => isMobile || isTablet;

  /// Returns true if this is tablet or desktop (not mobile)
  bool get isTabletOrDesktop => isTablet || isDesktop;

  /// Returns the maximum width for this screen size category
  double get maxWidth {
    switch (this) {
      case ScreenSize.mobile:
        return AppDimensions.tabletBreakpoint - 1;
      case ScreenSize.tablet:
        return AppDimensions.desktopBreakpoint - 1;
      case ScreenSize.desktop:
        return double.infinity;
    }
  }

  /// Returns the minimum width for this screen size category
  double get minWidth {
    switch (this) {
      case ScreenSize.mobile:
        return 0;
      case ScreenSize.tablet:
        return AppDimensions.tabletBreakpoint;
      case ScreenSize.desktop:
        return AppDimensions.desktopBreakpoint;
    }
  }

  /// Returns a human-readable name for this screen size
  String get displayName {
    switch (this) {
      case ScreenSize.mobile:
        return 'Mobile';
      case ScreenSize.tablet:
        return 'Tablet';
      case ScreenSize.desktop:
        return 'Desktop';
    }
  }
}

/// Extension methods for BuildContext to easily access screen size information
extension ScreenSizeExtension on BuildContext {
  /// Gets the current screen size category
  ScreenSize get screenSize => ScreenSize.fromContext(this);

  /// Returns true if the current screen is mobile
  bool get isMobile => screenSize.isMobile;

  /// Returns true if the current screen is tablet
  bool get isTablet => screenSize.isTablet;

  /// Returns true if the current screen is desktop
  bool get isDesktop => screenSize.isDesktop;

  /// Returns true if the current screen is mobile or tablet
  bool get isMobileOrTablet => screenSize.isMobileOrTablet;

  /// Returns true if the current screen is tablet or desktop
  bool get isTabletOrDesktop => screenSize.isTabletOrDesktop;
}