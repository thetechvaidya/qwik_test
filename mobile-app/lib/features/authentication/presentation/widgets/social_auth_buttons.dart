import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  void _handleGoogleAuth() {
    // TODO: Implement Google authentication
  }

  void _handleAppleAuth() {
    // TODO: Implement Apple authentication
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign In
        _SocialAuthButton(
          onPressed: _handleGoogleAuth,
          icon: const _GoogleIcon(),
          text: 'Continue with Google',
          backgroundColor: Colors.white,
          textColor: AppColors.textPrimary,
          borderColor: AppColors.border,
        ),
        
        const SizedBox(height: 12),
        
        // Apple Sign In (only show on iOS)
        if (Theme.of(context).platform == TargetPlatform.iOS)
          _SocialAuthButton(
            onPressed: _handleAppleAuth,
            icon: const Icon(
              Icons.apple,
              size: 20,
              color: Colors.white,
            ),
            text: 'Continue with Apple',
            backgroundColor: Colors.black,
            textColor: Colors.white,
          ),
      ],
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 12),
                Text(
                  text,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: const _GoogleIconPainter(),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  const _GoogleIconPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Google "G" colors
    const blue = Color(0xFF4285F4);
    const green = Color(0xFF34A853);
    const yellow = Color(0xFFFBBC05);
    const red = Color(0xFFEA4335);
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw the "G" shape using simple geometric shapes
    // This is a simplified version - in production, you'd use the official Google icon
    
    // Blue section (top-right)
    paint.color = blue;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57, // -90 degrees
      1.57,  // 90 degrees
      true,
      paint,
    );
    
    // Green section (bottom-right)
    paint.color = green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,     // 0 degrees
      1.57,  // 90 degrees
      true,
      paint,
    );
    
    // Yellow section (bottom-left)
    paint.color = yellow;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.57,  // 90 degrees
      1.57,  // 90 degrees
      true,
      paint,
    );
    
    // Red section (top-left)
    paint.color = red;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14,  // 180 degrees
      1.57,  // 90 degrees
      true,
      paint,
    );
    
    // White center circle
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.4, paint);
    
    // Blue "G" inner shape
    paint.color = blue;
    final path = Path();
    path.moveTo(center.dx, center.dy - radius * 0.2);
    path.lineTo(center.dx + radius * 0.3, center.dy - radius * 0.2);
    path.lineTo(center.dx + radius * 0.3, center.dy);
    path.lineTo(center.dx + radius * 0.1, center.dy);
    path.lineTo(center.dx + radius * 0.1, center.dy + radius * 0.2);
    path.lineTo(center.dx + radius * 0.3, center.dy + radius * 0.2);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}