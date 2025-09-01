import 'package:flutter/material.dart';
import '../../core/theme/app_dimensions.dart';

/// A Material 3 conformant dialog widget with helper methods
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.alignment,
    this.clipBehavior = Clip.none,
    this.scrollable = false,
    this.semanticLabel,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 40.0,
      vertical: 24.0,
    ),
    this.actionsPadding,
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.titlePadding,
    this.contentPadding,
    this.titleTextStyle,
    this.contentTextStyle,
  });

  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;
  final bool scrollable;
  final String? semanticLabel;
  final EdgeInsets insetPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final MainAxisAlignment? actionsAlignment;
  final OverflowBarAlignment? actionsOverflowAlignment;
  final VerticalDirection? actionsOverflowDirection;
  final double? actionsOverflowButtonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;

  @override
  Widget build(BuildContext context) {
    final effectiveShape = shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.dialogBorderRadius),
        );

    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: effectiveShape,
      alignment: alignment,
      clipBehavior: clipBehavior,
      scrollable: scrollable,
      semanticLabel: semanticLabel,
      insetPadding: insetPadding,
      actionsPadding: actionsPadding,
      actionsAlignment: actionsAlignment,
      actionsOverflowAlignment: actionsOverflowAlignment,
      actionsOverflowDirection: actionsOverflowDirection,
      actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
      buttonPadding: buttonPadding,
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      titleTextStyle: titleTextStyle,
      contentTextStyle: contentTextStyle,
    );
  }

  /// Shows a confirmation dialog with OK and Cancel buttons
  static Future<bool?> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AppDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: cancelButtonColor != null
                  ? TextButton.styleFrom(foregroundColor: cancelButtonColor)
                  : null,
              child: Text(cancelText),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: confirmButtonColor != null
                  ? FilledButton.styleFrom(backgroundColor: confirmButtonColor)
                  : null,
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  /// Shows an alert dialog with a single OK button
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    bool barrierDismissible = true,
    Color? buttonColor,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AppDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: buttonColor != null
                  ? FilledButton.styleFrom(backgroundColor: buttonColor)
                  : null,
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  /// Shows an error dialog with appropriate styling
  static Future<void> showError({
    required BuildContext context,
    required String message,
    String title = 'Error',
    String buttonText = 'OK',
    bool barrierDismissible = true,
  }) {
    return showAlert(
      context: context,
      title: title,
      message: message,
      buttonText: buttonText,
      barrierDismissible: barrierDismissible,
      buttonColor: Theme.of(context).colorScheme.error,
    );
  }

  /// Shows a success dialog with appropriate styling
  static Future<void> showSuccess({
    required BuildContext context,
    required String message,
    String title = 'Success',
    String buttonText = 'OK',
    bool barrierDismissible = true,
  }) {
    return showAlert(
      context: context,
      title: title,
      message: message,
      buttonText: buttonText,
      barrierDismissible: barrierDismissible,
      buttonColor: Theme.of(context).colorScheme.primary,
    );
  }

  /// Shows a loading dialog that can be dismissed programmatically
  static void showLoading({
    required BuildContext context,
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AppDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppDimensions.spacingMedium),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  /// Dismisses the currently shown dialog
  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}