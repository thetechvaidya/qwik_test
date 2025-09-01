import 'package:flutter/material.dart';
import '../../domain/entities/exam_session.dart';
import 'exam_timer_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Header widget for exam taking page with timer and controls
class ExamHeaderWidget extends StatelessWidget {
  final ExamSession session;
  final Duration timeRemaining;
  final VoidCallback onPaletteToggle;
  final VoidCallback onSubmit;

  const ExamHeaderWidget({
    super.key,
    required this.session,
    required this.timeRemaining,
    required this.onPaletteToggle,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top row with exam title and menu
            Row(
              children: [
                // Back button
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Exit Exam',
                ),
                
                // Exam title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.exam?.title ?? 'Exam Session',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (session.exam?.categoryName != null)
                        Text(
                          session.exam!.categoryName!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Question palette toggle
                IconButton(
                  onPressed: onPaletteToggle,
                  icon: const Icon(Icons.grid_view),
                  tooltip: 'Question Palette',
                ),
                
                // Submit button
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Bottom row with timer and progress info
            Row(
              children: [
                // Timer
                Expanded(
                  child: ExamTimerWidget(
                    timeRemaining: timeRemaining,
                    totalDuration: session.exam?.duration ?? Duration.zero,
                    isWarning: timeRemaining.inMinutes <= 5,
                    isCritical: timeRemaining.inMinutes <= 1,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Question progress
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Question ${session.currentQuestionIndex + 1} of ${session.questions.length}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Auto-save indicator
                if (session.lastSyncedAt != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_done,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Saved',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}