import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_dimensions.dart';

enum LoadingSize {
  small,
  medium,
  large,
}

enum LoadingType {
  circular,
  linear,
  dots,
  pulse,
}

class LoadingWidget extends StatefulWidget {
  final LoadingSize size;
  final LoadingType type;
  final Color? color;
  final String? message;
  final bool showMessage;
  final double? strokeWidth;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final bool adaptToPlatform;

  const LoadingWidget({
    super.key,
    this.size = LoadingSize.medium,
    this.type = LoadingType.circular,
    this.color,
    this.message,
    this.showMessage = false,
    this.strokeWidth,
    this.padding,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.adaptToPlatform = true,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.type == LoadingType.dots) {
      _animationController.repeat();
    } else if (widget.type == LoadingType.pulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  double get _indicatorSize {
    switch (widget.size) {
      case LoadingSize.small:
        return AppDimensions.progressIndicatorSm;
      case LoadingSize.medium:
        return AppDimensions.progressIndicatorMd;
      case LoadingSize.large:
        return AppDimensions.progressIndicatorLg;
    }
  }

  double get _strokeWidth {
    if (widget.strokeWidth != null) return widget.strokeWidth!;
    
    switch (widget.size) {
      case LoadingSize.small:
        return 1.5;
      case LoadingSize.medium:
        return AppDimensions.progressStrokeWidth;
      case LoadingSize.large:
        return 3.0;
    }
  }

  Widget _buildCircularIndicator() {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    
    // Use platform-specific indicator if adaptToPlatform is true
    if (widget.adaptToPlatform && Platform.isIOS) {
      return SizedBox(
        width: _indicatorSize,
        height: _indicatorSize,
        child: CupertinoActivityIndicator(
          color: color,
          radius: _indicatorSize / 2,
        ),
      );
    }
    
    return SizedBox(
      width: _indicatorSize,
      height: _indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: _strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildLinearIndicator() {
    return SizedBox(
      width: _indicatorSize * 3,
      child: LinearProgressIndicator(
        backgroundColor: (widget.color ?? Theme.of(context).colorScheme.primary)
            .withAlpha(51),
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = (_animationController.value - delay).clamp(0.0, 1.0);
            final opacity = (animationValue <= 0.5)
                ? animationValue * 2
                : (1.0 - animationValue) * 2;
            
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXs / 2,
              ),
              child: Opacity(
                opacity: opacity.clamp(0.3, 1.0),
                child: Container(
                  width: _indicatorSize / 3,
                  height: _indicatorSize / 3,
                  decoration: BoxDecoration(
                    color: widget.color ?? Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPulseIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: _indicatorSize,
            height: _indicatorSize,
            decoration: BoxDecoration(
              color: (widget.color ?? Theme.of(context).colorScheme.primary)
                  .withAlpha(178),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    switch (widget.type) {
      case LoadingType.circular:
        return _buildCircularIndicator();
      case LoadingType.linear:
        return _buildLinearIndicator();
      case LoadingType.dots:
        return _buildDotsIndicator();
      case LoadingType.pulse:
        return _buildPulseIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget loadingWidget = _buildLoadingIndicator();
    
    if (widget.showMessage && widget.message != null) {
      loadingWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingWidget,
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            widget.message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(178),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    
    if (widget.padding != null) {
      loadingWidget = Padding(
        padding: widget.padding!,
        child: loadingWidget,
      );
    }
    
    // Add accessibility semantics
    if (!widget.excludeFromSemantics) {
      final semanticLabel = widget.semanticLabel ?? 
          (widget.message ?? 'Loading');
      
      loadingWidget = Semantics(
        label: semanticLabel,
        liveRegion: true,
        child: ExcludeSemantics(
          excluding: widget.showMessage && widget.message != null,
          child: loadingWidget,
        ),
      );
    }
    
    return Center(child: loadingWidget);
  }
}

// Convenience widgets for common use cases
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final LoadingType type;
  final String? semanticLabel;
  final bool adaptToPlatform;
  
  const FullScreenLoading({
    super.key,
    this.message,
    this.backgroundColor,
    this.type = LoadingType.circular,
    this.semanticLabel,
    this.adaptToPlatform = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      body: LoadingWidget(
        type: type,
        size: LoadingSize.large,
        message: message,
        showMessage: message != null,
        semanticLabel: semanticLabel,
        adaptToPlatform: adaptToPlatform,
      ),
    );
  }
}

class OverlayLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? overlayColor;
  final LoadingType type;
  final String? semanticLabel;
  final bool adaptToPlatform;
  
  const OverlayLoading({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.overlayColor,
    this.type = LoadingType.circular,
    this.semanticLabel,
    this.adaptToPlatform = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? 
                Theme.of(context).colorScheme.surface.withAlpha(204),
            child: LoadingWidget(
              type: type,
              size: LoadingSize.large,
              message: message,
              showMessage: message != null,
              semanticLabel: semanticLabel,
              adaptToPlatform: adaptToPlatform,
            ),
          ),
      ],
    );
  }
}