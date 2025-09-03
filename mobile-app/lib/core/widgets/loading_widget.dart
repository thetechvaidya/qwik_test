import 'package:flutter/material.dart';

/// A reusable loading widget with customizable appearance
class LoadingWidget extends StatelessWidget {
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;

  const LoadingWidget({
    super.key,
    this.message,
    this.size,
    this.color,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? 40,
            height: size ?? 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).primaryColor,
              ),
            ),
          ),
          if (showMessage && message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A compact loading widget for inline use
class CompactLoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const CompactLoadingWidget({
    super.key,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

/// A simple loading widget that shows content or a loading indicator
class SimpleLoadingWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget? loadingWidget;

  const SimpleLoadingWidget({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    return loadingWidget ?? const Center(
      child: CompactLoadingWidget(),
    );
  }
}

/// Simple placeholder widget for loading states
class SimplePlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? color;

  const SimplePlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[300]?.withOpacity(0.3),
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}