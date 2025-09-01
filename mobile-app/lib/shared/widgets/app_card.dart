import 'package:flutter/material.dart';
import '../../core/theme/app_dimensions.dart';

/// A Material 3 conformant card widget with hover and focus states
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    this.child,
    this.onTap,
    this.elevation,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.clipBehavior = Clip.none,
    this.margin,
    this.padding,
    this.semanticContainer = true,
    this.borderOnForeground = true,
  });

  final Widget? child;
  final VoidCallback? onTap;
  final double? elevation;
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Clip clipBehavior;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool semanticContainer;
  final bool borderOnForeground;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;
    
    final effectiveElevation = widget.elevation ?? 
        (_isHovered ? 8.0 : (_isFocused ? 6.0 : cardTheme.elevation ?? 1.0));
    
    final effectiveShape = widget.shape ?? 
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        );

    Widget card = Card(
      elevation: effectiveElevation,
      color: widget.color,
      shadowColor: widget.shadowColor,
      surfaceTintColor: widget.surfaceTintColor,
      shape: effectiveShape,
      clipBehavior: widget.clipBehavior,
      margin: widget.margin,
      borderOnForeground: widget.borderOnForeground,
      semanticContainer: widget.semanticContainer && widget.onTap == null,
      child: widget.padding != null
          ? Padding(
              padding: widget.padding!,
              child: widget.child,
            )
          : widget.child,
    );

    if (widget.onTap != null) {
      card = InkWell(
        onTap: widget.onTap,
        onHover: (hovered) {
          setState(() {
            _isHovered = hovered;
          });
        },
        onFocusChange: (focused) {
          setState(() {
            _isFocused = focused;
          });
        },
        borderRadius: effectiveShape is RoundedRectangleBorder
            ? (effectiveShape as RoundedRectangleBorder).borderRadius as BorderRadius?
            : null,
        child: card,
      );
    } else {
      card = MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: Focus(
          onFocusChange: (focused) {
            setState(() {
              _isFocused = focused;
            });
          },
          child: card,
        ),
      );
    }

    return card;
  }
}