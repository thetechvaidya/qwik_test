import 'package:flutter/material.dart';
import '../../core/theme/app_dimensions.dart';

/// A Material 3 conformant chip widget with selectable and action variants
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.avatar,
    this.onPressed,
    this.onDeleted,
    this.onSelected,
    this.selected = false,
    this.enabled = true,
    this.variant = AppChipVariant.assist,
    this.backgroundColor,
    this.selectedColor,
    this.disabledColor,
    this.labelStyle,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.tooltip,
  });

  final Widget label;
  final Widget? avatar;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;
  final ValueChanged<bool>? onSelected;
  final bool selected;
  final bool enabled;
  final AppChipVariant variant;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? disabledColor;
  final TextStyle? labelStyle;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final IconThemeData? iconTheme;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final effectiveShape = shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.chipBorderRadius),
        );

    Widget chip;
    
    switch (variant) {
      case AppChipVariant.assist:
        chip = AssistChip(
          label: label,
          avatar: avatar,
          onPressed: enabled ? onPressed : null,
          backgroundColor: backgroundColor,
          disabledColor: disabledColor,
          labelStyle: labelStyle,
          side: side,
          shape: effectiveShape,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: materialTapTargetSize,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          iconTheme: iconTheme,
        );
        break;
      case AppChipVariant.filter:
        chip = FilterChip(
          label: label,
          avatar: avatar,
          onSelected: enabled ? onSelected : null,
          selected: selected,
          backgroundColor: backgroundColor,
          selectedColor: selectedColor,
          disabledColor: disabledColor,
          labelStyle: labelStyle,
          side: side,
          shape: effectiveShape,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: materialTapTargetSize,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          iconTheme: iconTheme,
        );
        break;
      case AppChipVariant.input:
        chip = InputChip(
          label: label,
          avatar: avatar,
          onPressed: enabled ? onPressed : null,
          onDeleted: enabled ? onDeleted : null,
          onSelected: enabled ? onSelected : null,
          selected: selected,
          backgroundColor: backgroundColor,
          selectedColor: selectedColor,
          disabledColor: disabledColor,
          labelStyle: labelStyle,
          side: side,
          shape: effectiveShape,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: materialTapTargetSize,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          iconTheme: iconTheme,
        );
        break;
      case AppChipVariant.choice:
        chip = ChoiceChip(
          label: label,
          avatar: avatar,
          onSelected: enabled ? onSelected : null,
          selected: selected,
          backgroundColor: backgroundColor,
          selectedColor: selectedColor,
          disabledColor: disabledColor,
          labelStyle: labelStyle,
          side: side,
          shape: effectiveShape,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: materialTapTargetSize,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          iconTheme: iconTheme,
        );
        break;
      case AppChipVariant.action:
        chip = ActionChip(
          label: label,
          avatar: avatar,
          onPressed: enabled ? onPressed : null,
          backgroundColor: backgroundColor,
          disabledColor: disabledColor,
          labelStyle: labelStyle,
          side: side,
          shape: effectiveShape,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: materialTapTargetSize,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          iconTheme: iconTheme,
        );
        break;
    }

    if (tooltip != null) {
      chip = Tooltip(
        message: tooltip!,
        child: chip,
      );
    }

    return chip;
  }
}

/// Variants of AppChip
enum AppChipVariant {
  /// Assist chips help users complete tasks or provide information
  assist,
  
  /// Filter chips allow users to select from a set of options
  filter,
  
  /// Input chips represent discrete pieces of information entered by a user
  input,
  
  /// Choice chips allow users to select a single option from a set
  choice,
  
  /// Action chips trigger actions related to primary content
  action,
}