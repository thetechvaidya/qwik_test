import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle, this.showLogo = true});

  final String title;
  final String subtitle;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showLogo) ...[
          // App Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(76),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.quiz_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // App Name
          Text(
            'QwikTest',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 32),
        ],
        
        // Title
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          subtitle,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}