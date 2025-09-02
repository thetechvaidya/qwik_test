import 'package:flutter/material.dart';
import '../../domain/entities/exam_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Widget that displays exam progress information
class ExamProgressWidget extends StatelessWidget {
  final ExamSession session;
  final int currentQuestionIndex;
  final int totalQuestions;
  final int answeredCount;
  final int skippedCount;
  final int markedForReviewCount;

  const ExamProgressWidget({
    Key? key,
    required this.session,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.answeredCount,
    required this.skippedCount,
    required this.markedForReviewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions > 0 ? (currentQuestionIndex + 1) / totalQuestions : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1} of $totalQuestions',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Answered',
                  answeredCount.toString(),
                  AppColors.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Skipped',
                  skippedCount.toString(),
                  AppColors.warning,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Review',
                  markedForReviewCount.toString(),
                  AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}