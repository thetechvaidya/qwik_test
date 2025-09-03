import 'package:flutter/material.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/responsive_builder.dart';
import '../../core/responsive/screen_size.dart';

enum ButtonVariant {
  filled,        // Material 3 filled button (primary)
  filledTonal,   // Material 3 filled tonal button
  elevated,      // Material 3 elevated button
  outlined,      // Material 3 outlined button
  text,          // Material 3 text button
  // Legacy variants for backward compatibility
  primary,
  secondary,
  outline,
  danger,
}

enum ButtonType {
  standard,
  icon,
  fab,           // Floating Action Button
  extendedFab,   // Extended Floating Action Button
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final bool iconAtEnd;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final String? tooltip;
  final String? semanticLabel;
  final bool autofocus;
  final FocusNode? focusNode;
  final WidgetStatesController? statesController;

  const CustomButton({
    super.key,
    this.text,
    this.onPressed,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.medium,
    this.type = ButtonType.standard,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconAtEnd = false,
    this.padding,
    this.borderRadius,
    this.tooltip,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
    this.statesController,
  }) : assert(
         (type == ButtonType.icon && icon != null) ||
         (type == ButtonType.fab && icon != null) ||
         (type == ButtonType.extendedFab && (text != null || icon != null)) ||
         (type == ButtonType.standard && text != null),
         'Button content must match the button type',
       );

  /// Creates an icon button
  const CustomButton.icon({
    super.key,
    required Widget this.icon,
    required this.onPressed,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.medium,
    this.tooltip,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
    this.statesController,
  }) : text = null,
       type = ButtonType.icon,
       isLoading = false,
       isFullWidth = false,
       iconAtEnd = false,
       padding = null,
       borderRadius = null;

  /// Creates a floating action button
  const CustomButton.fab({
    super.key,
    required Widget this.icon,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.tooltip,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
    this.statesController,
  }) : text = null,
       variant = ButtonVariant.filled,
       type = ButtonType.fab,
       isLoading = false,
       isFullWidth = false,
       iconAtEnd = false,
       padding = null,
       borderRadius = null;

  /// Creates an extended floating action button
  const CustomButton.extendedFab({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.tooltip,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
    this.statesController,
  }) : variant = ButtonVariant.filled,
       type = ButtonType.extendedFab,
       size = ButtonSize.medium,
       isLoading = false,
       isFullWidth = false,
       iconAtEnd = false,
       padding = null,
       borderRadius = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Handle different button types
    switch (type) {
      case ButtonType.icon:
        return _buildIconButton(context, theme, colorScheme);
      case ButtonType.fab:
        return _buildFab(context, theme, colorScheme);
      case ButtonType.extendedFab:
        return _buildExtendedFab(context, theme, colorScheme);
      case ButtonType.standard:
        return _buildStandardButton(context, theme, colorScheme);
    }
  }

  Widget _buildStandardButton(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    // Determine button dimensions based on size and screen size
    final screenSize = context.screenSize;
    final isCompact = screenSize.isMobile;
    
    double height;
    double fontSize;
    EdgeInsetsGeometry defaultPadding;
    
    switch (size) {
      case ButtonSize.small:
        height = isCompact ? AppDimensions.buttonHeightSm * 0.9 : AppDimensions.buttonHeightSm;
        fontSize = isCompact ? 11 : 12;
        defaultPadding = EdgeInsets.symmetric(
          horizontal: isCompact ? AppDimensions.paddingSm : AppDimensions.paddingMd,
          vertical: AppDimensions.paddingXs,
        );
        break;
      case ButtonSize.medium:
        height = isCompact ? AppDimensions.buttonHeightMd * 0.95 : AppDimensions.buttonHeightMd;
        fontSize = isCompact ? 13 : 14;
        defaultPadding = EdgeInsets.symmetric(
          horizontal: isCompact ? AppDimensions.paddingMd : AppDimensions.paddingLg,
          vertical: AppDimensions.paddingSm,
        );
        break;
      case ButtonSize.large:
        height = AppDimensions.buttonHeightLg;
        fontSize = isCompact ? 15 : 16;
        defaultPadding = EdgeInsets.symmetric(
          horizontal: isCompact ? AppDimensions.paddingLg : AppDimensions.paddingXl,
          vertical: AppDimensions.paddingMd,
        );
        break;
    }

    // Determine colors and styles based on variant (Material 3 + legacy support)
    Color backgroundColor;
    Color foregroundColor;
    Color? borderColor;
    double elevation = 0;
    
    switch (variant) {
      // Material 3 variants
      case ButtonVariant.filled:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        borderColor = null;
        break;
      case ButtonVariant.filledTonal:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        borderColor = null;
        break;
      case ButtonVariant.elevated:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.primary;
        borderColor = null;
        elevation = 1;
        break;
      case ButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderColor = colorScheme.outline;
        break;
      case ButtonVariant.text:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderColor = null;
        break;
      // Legacy variants for backward compatibility
      case ButtonVariant.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        borderColor = null;
        break;
      case ButtonVariant.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        borderColor = null;
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderColor = colorScheme.outline;
        break;
      case ButtonVariant.danger:
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.onError;
        borderColor = null;
        break;
    }

    Widget buttonChild = _buildButtonContent(context, foregroundColor, fontSize);
    Widget button = _buildButtonWidget(context, theme, colorScheme, backgroundColor, foregroundColor, borderColor, elevation, height, defaultPadding, buttonChild);

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }

  Widget _buildButtonContent(BuildContext context, Color foregroundColor, double fontSize) {
    if (isLoading) {
      return SizedBox(
        height: AppDimensions.progressIndicatorSm,
        width: AppDimensions.progressIndicatorSm,
        child: CircularProgressIndicator(
          strokeWidth: AppDimensions.progressStrokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    List<Widget> children = [];
    
    if (icon != null && !iconAtEnd) {
      children.add(icon!);
      if (text != null) children.add(const SizedBox(width: AppDimensions.spacingSm));
    }
    
    if (text != null) {
      children.add(
        Text(
          text!,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
          ),
        ),
      );
    }
    
    if (icon != null && iconAtEnd) {
      if (text != null) children.add(const SizedBox(width: AppDimensions.spacingSm));
      children.add(icon!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildButtonWidget(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color backgroundColor,
    Color foregroundColor,
    Color? borderColor,
    double elevation,
    double height,
    EdgeInsetsGeometry defaultPadding,
    Widget buttonChild,
  ) {
    final buttonStyle = _getButtonStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      elevation: elevation,
      height: height,
      padding: defaultPadding,
    );

    Widget button;
    switch (variant) {
      case ButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          focusNode: focusNode,
          autofocus: autofocus,
          statesController: statesController,
          child: buttonChild,
        );
        break;
      case ButtonVariant.outlined:
      case ButtonVariant.outline: // Legacy support
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          focusNode: focusNode,
          autofocus: autofocus,
          statesController: statesController,
          child: buttonChild,
        );
        break;
      default:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          focusNode: focusNode,
          autofocus: autofocus,
          statesController: statesController,
          child: buttonChild,
        );
        break;
    }

    return tooltip != null
        ? Tooltip(
            message: tooltip!,
            child: button,
          )
        : button;
  }

  ButtonStyle _getButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
    Color? borderColor,
    required double elevation,
    required double height,
    required EdgeInsetsGeometry padding,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return backgroundColor.withAlpha((255 * 0.12).round());
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return foregroundColor.withAlpha((255 * 0.38).round());
        }
        return foregroundColor;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return 0;
        if (states.contains(WidgetState.pressed)) return elevation + 2;
        if (states.contains(WidgetState.hovered)) return elevation + 1;
        return elevation;
      }),
      padding: WidgetStateProperty.all(padding ?? this.padding),
      minimumSize: WidgetStateProperty.all(
        Size(
          isFullWidth ? double.infinity : AppDimensions.buttonMinWidth,
          height,
        ),
      ),
      side: borderColor != null
          ? WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(
                  color: borderColor.withAlpha((255 * 0.12).round()),
                  width: AppDimensions.inputBorderWidth,
                );
              }
              return BorderSide(
                color: borderColor,
                width: AppDimensions.inputBorderWidth,
              );
            })
          : null,
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return foregroundColor.withAlpha((255 * 0.12).round());
        }
        if (states.contains(WidgetState.hovered)) {
          return foregroundColor.withAlpha((255 * 0.08).round());
        }
        if (states.contains(WidgetState.focused)) {
          return foregroundColor.withAlpha((255 * 0.12).round());
        }
        return null;
      }),
    );
  }

  Widget _buildIconButton(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final iconSize = _getIconSize();
    final buttonStyle = _getIconButtonStyle(colorScheme);

    Widget button = IconButton(
      onPressed: onPressed,
      icon: icon!,
      iconSize: iconSize,
      style: buttonStyle,
      tooltip: tooltip,
      focusNode: focusNode,
      autofocus: autofocus,
    );

    return semanticLabel != null
        ? Semantics(
            label: semanticLabel!,
            child: button,
          )
        : button;
  }

  Widget _buildFab(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    Widget fab;
    switch (size) {
      case ButtonSize.small:
        fab = FloatingActionButton.small(
          onPressed: onPressed,
          tooltip: tooltip,
          focusNode: focusNode,
          autofocus: autofocus,
          child: icon!,
        );
        break;
      case ButtonSize.large:
        fab = FloatingActionButton.large(
          onPressed: onPressed,
          tooltip: tooltip,
          focusNode: focusNode,
          autofocus: autofocus,
          child: icon!,
        );
        break;
      case ButtonSize.medium:
      default:
        fab = FloatingActionButton(
          onPressed: onPressed,
          tooltip: tooltip,
          focusNode: focusNode,
          autofocus: autofocus,
          child: icon!,
        );
        break;
    }

    return semanticLabel != null
        ? Semantics(
            label: semanticLabel!,
            child: fab,
          )
        : fab;
  }

  Widget _buildExtendedFab(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    Widget? fabIcon = icon;
    String? fabLabel = text;

    Widget fab = FloatingActionButton.extended(
      onPressed: onPressed,
      icon: fabIcon,
      label: fabLabel != null ? Text(fabLabel) : const SizedBox.shrink(),
      tooltip: tooltip,
      focusNode: focusNode,
      autofocus: autofocus,
    );

    return semanticLabel != null
        ? Semantics(
            label: semanticLabel!,
            child: fab,
          )
        : fab;
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppDimensions.iconSm;
      case ButtonSize.medium:
        return AppDimensions.iconMd;
      case ButtonSize.large:
        return AppDimensions.iconLg;
    }
  }



  ButtonStyle _getIconButtonStyle(ColorScheme colorScheme) {
    Color backgroundColor;
    Color foregroundColor;

    switch (variant) {
      case ButtonVariant.filled:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;
      case ButtonVariant.filledTonal:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        break;
      case ButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        break;
      case ButtonVariant.text:
      default:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurfaceVariant;
        break;
    }

    return IconButton.styleFrom(
       backgroundColor: backgroundColor,
       foregroundColor: foregroundColor,
       padding: padding,
       shape: borderRadius != null
           ? RoundedRectangleBorder(borderRadius: borderRadius!)
           : null,
     );
   }
}