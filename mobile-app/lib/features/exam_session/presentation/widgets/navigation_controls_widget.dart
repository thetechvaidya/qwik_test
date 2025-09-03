import 'package:flutter/material.dart';
import '../../domain/entities/exam_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Widget for exam navigation controls (Previous, Next, Skip, etc.)
class NavigationControlsWidget extends StatelessWidget {
  final ExamSession session;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final VoidCallback? onMarkForReview;
  final VoidCallback? onClearAnswer;
  final VoidCallback? onSubmit;
  final bool showSubmit;

  const NavigationControlsWidget({
    super.key,
    required this.session,
    this.onPrevious,
    this.onNext,
    this.onSkip,
    this.onMarkForReview,
    this.onClearAnswer,
    this.onSubmit,
    this.showSubmit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.1).round()),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Action buttons row
            Row(
              children: [
                // Mark for review button
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.flag_outlined,
                    label: 'Mark for Review',
                    onPressed: onMarkForReview,
                    color: AppColors.warning,
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Clear answer button
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.clear,
                    label: 'Clear Answer',
                    onPressed: onClearAnswer,
                    color: AppColors.error,
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Skip button
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.skip_next,
                    label: 'Skip',
                    onPressed: onSkip,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Navigation buttons row
            Row(
              children: [
                // Previous button
                Expanded(
                  child: _buildNavigationButton(
                    icon: Icons.arrow_back,
                    label: 'Previous',
                    onPressed: onPrevious,
                    isPrimary: false,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Next or Submit button
                Expanded(
                  flex: 2,
                  child: showSubmit
                      ? _buildSubmitButton()
                      : _buildNavigationButton(
                          icon: Icons.arrow_forward,
                          label: _getNextButtonLabel(),
                          onPressed: onNext,
                          isPrimary: true,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: onPressed != null ? color : AppColors.onSurface.withAlpha((255 * 0.38).round()),
      ),
      label: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: onPressed != null ? color : AppColors.onSurface.withAlpha((255 * 0.38).round()),
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        side: BorderSide(
          color: onPressed != null ? color : AppColors.outline,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required bool isPrimary,
  }) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
        ),
        label: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
          color: onPressed != null ? AppColors.primary : AppColors.onSurface.withAlpha((255 * 0.38).round()),
        ),
        label: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: onPressed != null ? AppColors.primary : AppColors.onSurface.withAlpha((255 * 0.38).round()),
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: BorderSide(
            color: onPressed != null ? AppColors.primary : AppColors.outline,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: onSubmit,
      icon: const Icon(
        Icons.send,
        size: 20,
      ),
      label: Text(
        'Submit Exam',
        style: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  String _getNextButtonLabel() {
    final isLastQuestion = session.currentQuestionIndex >= session.questions.length - 1;
    return isLastQuestion ? 'Finish' : 'Next';
  }
}

/// Compact version of navigation controls for smaller screens
class CompactNavigationControlsWidget extends StatelessWidget {
  final ExamSession session;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final VoidCallback? onMarkForReview;
  final VoidCallback? onSubmit;
  final bool showSubmit;

  const CompactNavigationControlsWidget({
    super.key,
    required this.session,
    this.onPrevious,
    this.onNext,
    this.onSkip,
    this.onMarkForReview,
    this.onSubmit,
    this.showSubmit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.1).round()),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous button
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Previous',
            ),
            
            // Mark for review
            IconButton(
              onPressed: onMarkForReview,
              icon: const Icon(Icons.flag_outlined),
              tooltip: 'Mark for Review',
            ),
            
            // Skip button
            IconButton(
              onPressed: onSkip,
              icon: const Icon(Icons.skip_next),
              tooltip: 'Skip',
            ),
            
            const Spacer(),
            
            // Question indicator
            Text(
              '${session.currentQuestionIndex + 1}/${session.questions.length}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const Spacer(),
            
            // Next or Submit button
            if (showSubmit)
              ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Submit'),
              )
            else
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(_getNextButtonLabel()),
              ),
          ],
        ),
      ),
    );
  }

  String _getNextButtonLabel() {
    final isLastQuestion = session.currentQuestionIndex >= session.questions.length - 1;
    return isLastQuestion ? 'Finish' : 'Next';
  }
}