import 'package:flutter/material.dart';
import 'screen_size.dart';
import '../theme/app_dimensions.dart';

/// InheritedWidget that provides screen size information to child widgets
class ResponsiveLayout extends InheritedWidget {
  const ResponsiveLayout({
    super.key,
    required super.child,
    required this.screenSize,
    required this.screenWidth,
    required this.screenHeight,
  });

  final ScreenSize screenSize;
  final double screenWidth;
  final double screenHeight;

  /// Creates a ResponsiveLayout that automatically determines screen size from MediaQuery
  static Widget builder({
    Key? key,
    required Widget child,
  }) {
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final size = mediaQuery.size;
        final screenSize = ScreenSize.fromWidth(size.width);

        return ResponsiveLayout(
          key: key,
          screenSize: screenSize,
          screenWidth: size.width,
          screenHeight: size.height,
          child: child,
        );
      },
    );
  }

  /// Gets the ResponsiveLayout from the widget tree
  static ResponsiveLayout? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveLayout>();
  }

  /// Gets the ResponsiveLayout from the widget tree, throws if not found
  static ResponsiveLayout of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No ResponsiveLayout found in context');
    return result!;
  }

  /// Convenience method to get the current screen size
  static ScreenSize screenSizeOf(BuildContext context) {
    return of(context).screenSize;
  }

  /// Convenience method to check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return screenSizeOf(context).isMobile;
  }

  /// Convenience method to check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return screenSizeOf(context).isTablet;
  }

  /// Convenience method to check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return screenSizeOf(context).isDesktop;
  }

  /// Convenience method to check if current screen is mobile or tablet
  static bool isMobileOrTablet(BuildContext context) {
    return screenSizeOf(context).isMobileOrTablet;
  }

  /// Convenience method to check if current screen is tablet or desktop
  static bool isTabletOrDesktop(BuildContext context) {
    return screenSizeOf(context).isTabletOrDesktop;
  }

  /// Gets the screen width
  static double widthOf(BuildContext context) {
    return of(context).screenWidth;
  }

  /// Gets the screen height
  static double heightOf(BuildContext context) {
    return of(context).screenHeight;
  }

  /// Returns appropriate padding based on screen size
  static EdgeInsets paddingOf(BuildContext context) {
    final screenSize = screenSizeOf(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(AppDimensions.paddingLg);
      case ScreenSize.tablet:
        return const EdgeInsets.all(AppDimensions.padding2xl);
      case ScreenSize.desktop:
        return const EdgeInsets.all(AppDimensions.padding3xl);
    }
  }

  /// Returns appropriate margin based on screen size
  static EdgeInsets marginOf(BuildContext context) {
    final screenSize = screenSizeOf(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(AppDimensions.marginLg);
      case ScreenSize.tablet:
        return const EdgeInsets.all(AppDimensions.margin2xl);
      case ScreenSize.desktop:
        return const EdgeInsets.all(AppDimensions.margin3xl);
    }
  }

  /// Returns appropriate content width based on screen size
  static double contentWidthOf(BuildContext context) {
    final screenSize = screenSizeOf(context);
    final screenWidth = widthOf(context);
    
    switch (screenSize) {
      case ScreenSize.mobile:
        return screenWidth;
      case ScreenSize.tablet:
        return screenWidth * 0.8;
      case ScreenSize.desktop:
        return screenWidth * 0.6;
    }
  }

  @override
  bool updateShouldNotify(ResponsiveLayout oldWidget) {
    return screenSize != oldWidget.screenSize ||
        screenWidth != oldWidget.screenWidth ||
        screenHeight != oldWidget.screenHeight;
  }
}

/// Extension methods for BuildContext to easily access ResponsiveLayout
extension ResponsiveLayoutExtension on BuildContext {
  /// Gets the ResponsiveLayout from the widget tree
  ResponsiveLayout get responsiveLayout => ResponsiveLayout.of(this);

  /// Gets the current screen size from ResponsiveLayout
  ScreenSize get responsiveScreenSize => ResponsiveLayout.screenSizeOf(this);

  /// Gets the screen width from ResponsiveLayout
  double get responsiveWidth => ResponsiveLayout.widthOf(this);

  /// Gets the screen height from ResponsiveLayout
  double get responsiveHeight => ResponsiveLayout.heightOf(this);

  /// Gets appropriate padding from ResponsiveLayout
  EdgeInsets get responsivePadding => ResponsiveLayout.paddingOf(this);

  /// Gets appropriate margin from ResponsiveLayout
  EdgeInsets get responsiveMargin => ResponsiveLayout.marginOf(this);

  /// Gets appropriate content width from ResponsiveLayout
  double get responsiveContentWidth => ResponsiveLayout.contentWidthOf(this);
}