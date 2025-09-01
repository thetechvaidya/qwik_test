import 'package:flutter/material.dart';
import 'screen_size.dart';
import 'responsive_layout.dart';
import '../theme/app_dimensions.dart';

/// A widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.breakpoints,
  });

  /// Builder for mobile layout (required)
  final Widget Function(BuildContext context) mobile;

  /// Builder for tablet layout (optional, falls back to mobile if not provided)
  final Widget Function(BuildContext context)? tablet;

  /// Builder for desktop layout (optional, falls back to tablet or mobile if not provided)
  final Widget Function(BuildContext context)? desktop;

  /// Custom breakpoints (optional, uses default breakpoints if not provided)
  final ResponsiveBreakpoints? breakpoints;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        
        // Use provided breakpoints or default ones
        final effectiveBreakpoints = breakpoints ?? ResponsiveBreakpoints.defaultBreakpoints;
        final screenSize = effectiveBreakpoints.getScreenSize(screenWidth);
        
        return ResponsiveLayout(
          screenSize: screenSize,
          screenWidth: screenWidth,
          screenHeight: mediaQuery.size.height,
          child: Builder(
            builder: (context) {
              switch (screenSize) {
                case ScreenSize.mobile:
                  return mobile(context);
                case ScreenSize.tablet:
                  return (tablet ?? mobile)(context);
                case ScreenSize.desktop:
                  return (desktop ?? tablet ?? mobile)(context);
              }
            },
          ),
        );
      },
    );
  }
}

/// A widget that provides different widgets based on screen size
class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.breakpoints,
  });

  /// Widget for mobile layout (required)
  final Widget mobile;

  /// Widget for tablet layout (optional, falls back to mobile if not provided)
  final Widget? tablet;

  /// Widget for desktop layout (optional, falls back to tablet or mobile if not provided)
  final Widget? desktop;

  /// Custom breakpoints (optional, uses default breakpoints if not provided)
  final ResponsiveBreakpoints? breakpoints;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (_) => mobile,
      tablet: tablet != null ? (_) => tablet! : null,
      desktop: desktop != null ? (_) => desktop! : null,
      breakpoints: breakpoints,
    );
  }
}

/// A widget that provides different values based on screen size
class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Value for mobile layout (required)
  final T mobile;

  /// Value for tablet layout (optional, falls back to mobile if not provided)
  final T? tablet;

  /// Value for desktop layout (optional, falls back to tablet or mobile if not provided)
  final T? desktop;

  /// Gets the appropriate value based on the current screen size
  T getValue(BuildContext context) {
    final screenSize = ResponsiveLayout.screenSizeOf(context);
    
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Static method to create a ResponsiveValue and get its value immediately
  static T of<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return ResponsiveValue<T>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).getValue(context);
  }
}

/// Custom breakpoints for responsive design
class ResponsiveBreakpoints {
  const ResponsiveBreakpoints({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  final double mobile;
  final double tablet;
  final double desktop;

  /// Default breakpoints based on Material Design guidelines
  static const ResponsiveBreakpoints defaultBreakpoints = ResponsiveBreakpoints(
    mobile: AppDimensions.mobileBreakpoint,
    tablet: AppDimensions.tabletBreakpoint,
    desktop: AppDimensions.desktopBreakpoint,
  );

  /// Determines screen size based on these breakpoints
  ScreenSize getScreenSize(double width) {
    if (width < tablet) {
      return ScreenSize.mobile;
    } else if (width < desktop) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }
}

/// Extension methods for easy responsive design
extension ResponsiveExtension on BuildContext {
  /// Gets a responsive value based on screen size
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return ResponsiveValue.of<T>(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Gets responsive padding
  EdgeInsets responsivePaddingValue({
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    return responsive<EdgeInsets>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Gets responsive margin
  EdgeInsets responsiveMarginValue({
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    return responsive<EdgeInsets>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Gets responsive font size
  double responsiveFontSize({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive<double>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Gets responsive spacing
  double responsiveSpacing({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive<double>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}