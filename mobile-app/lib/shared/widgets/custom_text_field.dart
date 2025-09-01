import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_dimensions.dart';

enum TextFieldSize {
  small,
  medium,
  large,
}

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? initialValue;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final TextFieldSize size;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final bool showClearButton;
  final bool showPasswordToggle;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.size = TextFieldSize.medium,
    this.contentPadding,
    this.borderRadius,
    this.showClearButton = false,
    this.showPasswordToggle = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _showClearButton = _controller.text.isNotEmpty && widget.showClearButton;
    
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.showClearButton) {
      final showClear = _controller.text.isNotEmpty;
      if (showClear != _showClearButton) {
        setState(() {
          _showClearButton = showClear;
        });
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (widget.size) {
      case TextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        );
      case TextFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        );
      case TextFieldSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingLg,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Build suffix icon
    Widget? suffixIcon;
    if (widget.showPasswordToggle && widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          size: AppDimensions.iconMd,
        ),
        onPressed: _togglePasswordVisibility,
      );
    } else if (_showClearButton) {
      suffixIcon = IconButton(
        icon: Icon(
          Icons.clear,
          size: AppDimensions.iconMd,
        ),
        onPressed: _clearText,
      );
    } else if (widget.suffixIcon != null) {
      suffixIcon = widget.suffixIcon;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
        ],
        TextFormField(
          controller: _controller,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          validator: widget.validator,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: suffixIcon,
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            contentPadding: widget.contentPadding ?? _getDefaultPadding(),
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: colorScheme.outline,
                width: AppDimensions.inputBorderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: colorScheme.outline,
                width: AppDimensions.inputBorderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: AppDimensions.inputFocusBorderWidth,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: AppDimensions.inputBorderWidth,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: AppDimensions.inputFocusBorderWidth,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: colorScheme.outline.withAlpha(127),
                width: AppDimensions.inputBorderWidth,
              ),
            ),
            filled: true,
            fillColor: widget.enabled 
                ? colorScheme.surface 
                : colorScheme.surface.withAlpha(127),
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(153),
            ),
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withAlpha(178),
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
            prefixStyle: theme.textTheme.bodyMedium,
            suffixStyle: theme.textTheme.bodyMedium,
            counterStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withAlpha(178),
            ),
          ),
        ),
      ],
    );
  }
}