import 'package:flutter/material.dart';
import '../../domain/entities/exam_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Dialog for confirming exam submission
class ExamSubmissionDialog extends StatelessWidget {
  final ExamSession session;
  final int answeredCount;
  final int totalQuestions;
  final int skippedCount;
  final int markedForReviewCount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ExamSubmissionDialog({
    Key? key,
    required this.session,
    required this.answeredCount,
    required this.totalQuestions,
    required this.skippedCount,
    required this.markedForReviewCount,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unansweredCount = totalQuestions - answeredCount - skippedCount;
    
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'Submit Exam',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to submit your exam? This action cannot be undone.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          // Summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exam Summary',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSummaryRow('Total Questions', totalQuestions.toString()),
                _buildSummaryRow('Answered', answeredCount.toString(), AppColors.success),
                if (skippedCount > 0)
                  _buildSummaryRow('Skipped', skippedCount.toString(), AppColors.warning),
                if (unansweredCount > 0)
                  _buildSummaryRow('Unanswered', unansweredCount.toString(), AppColors.error),
                if (markedForReviewCount > 0)
                  _buildSummaryRow('Marked for Review', markedForReviewCount.toString(), AppColors.info),
              ],
            ),
          ),
          
          if (unansweredCount > 0) ..[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.onErrorContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You have $unansweredCount unanswered question${unansweredCount == 1 ? '' : 's'}.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Submit Exam',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: valueColor ?? AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Show the submission dialog
  static Future<bool?> show({
    required BuildContext context,
    required ExamSession session,
    required int answeredCount,
    required int totalQuestions,
    required int skippedCount,
    required int markedForReviewCount,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ExamSubmissionDialog(
        session: session,
        answeredCount: answeredCount,
        totalQuestions: totalQuestions,
        skippedCount: skippedCount,
        markedForReviewCount: markedForReviewCount,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}