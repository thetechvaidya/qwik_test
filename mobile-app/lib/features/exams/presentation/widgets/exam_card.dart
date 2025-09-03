import 'package:flutter/material.dart';
import '../../domain/entities/exam.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Card widget for displaying exam information in list view
class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onResume;
  final Function(bool)? onFavoriteToggle;
  final bool showProgress;
  final bool isCompact;

  const ExamCard({
    super.key,
    required this.exam,
    this.onTap,
    this.onStart,
    this.onResume,
    this.onFavoriteToggle,
    this.showProgress = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              if (!isCompact) ...[
                const SizedBox(height: 8),
                _buildDescription(context),
              ],
              const SizedBox(height: 12),
              _buildMetadata(context),
              if (showProgress && exam.userProgress != null) ...[
                const SizedBox(height: 12),
                _buildProgress(context),
              ],
              if (!isCompact) ...[
                const SizedBox(height: 12),
                _buildActions(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Exam thumbnail/icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getDifficultyColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getExamTypeIcon(),
            color: _getDifficultyColor(),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        
        // Title and category
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exam.title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (exam.categoryName.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  exam.categoryName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Favorite button
        if (onFavoriteToggle != null)
          IconButton(
            icon: Icon(
              exam.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: exam.isFavorite ? AppColors.error : AppColors.textSecondary,
            ),
            onPressed: () => onFavoriteToggle?.call(!exam.isFavorite),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    if (exam.description == null || exam.description!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Text(
      exam.description!,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        // Difficulty
        _buildMetadataItem(
          icon: Icons.signal_cellular_alt,
          label: exam.difficulty.displayName,
          color: _getDifficultyColor(),
        ),
        
        // Duration
        if (exam.duration != null)
          _buildMetadataItem(
            icon: Icons.access_time,
            label: DurationFormatter.format(exam.duration!),
          ),
        
        // Question count
        _buildMetadataItem(
          icon: Icons.quiz_outlined,
          label: '${exam.totalQuestions} questions',
        ),
        
        // Rating
        if (exam.stats.averageRating > 0)
          _buildMetadataItem(
            icon: Icons.star,
            label: exam.stats.averageRating.toStringAsFixed(1),
            color: AppColors.warning,
          ),
        
        // Status
        if (!exam.isActive)
          _buildMetadataItem(
            icon: Icons.pause_circle_outline,
            label: 'Inactive',
            color: AppColors.textSecondary,
          ),
      ],
    );
  }

  Widget _buildMetadataItem({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: color ?? AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgress(BuildContext context) {
    final progress = exam.userProgress!;
    final progressPercentage = progress.completionPercentage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${progressPercentage.toStringAsFixed(0)}%',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: _getProgressColor(progressPercentage),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progressPercentage / 100,
          backgroundColor: AppColors.surface,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(progressPercentage),
          ),
        ),
        if (progress.lastAttemptAt != null) ...[
          const SizedBox(height: 4),
          Text(
            'Last attempt: ${DateFormatter.formatRelative(progress.lastAttemptAt!)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final progress = exam.userProgress;
    
    return Row(
      children: [
        // Primary action button
        Expanded(
          child: ElevatedButton(
            onPressed: _getPrimaryAction(),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getPrimaryActionColor(),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(_getPrimaryActionText()),
          ),
        ),
        
        // Secondary actions
        if (progress != null && progress.isStarted) ...[
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('View'),
          ),
        ],
      ],
    );
  }

  VoidCallback? _getPrimaryAction() {
    final progress = exam.userProgress;
    
    if (progress == null || !progress.isStarted) {
      return onStart;
    } else if (progress.isCompleted) {
      return onTap; // View results
    } else {
      return onResume; // Continue
    }
  }

  String _getPrimaryActionText() {
    final progress = exam.userProgress;
    
    if (progress == null || !progress.isStarted) {
      return 'Start Exam';
    } else if (progress.isCompleted) {
      return 'View Results';
    } else {
      return 'Continue';
    }
  }

  Color _getPrimaryActionColor() {
    final progress = exam.userProgress;
    
    if (progress == null || !progress.isStarted) {
      return AppColors.primary;
    } else if (progress.isCompleted) {
      return AppColors.success;
    } else {
      return AppColors.warning;
    }
  }

  IconData _getExamTypeIcon() {
    switch (exam.examType) {
      case ExamType.practice:
        return Icons.school_outlined;
      case ExamType.mock:
        return Icons.quiz_outlined;
      case ExamType.live:
        return Icons.workspace_premium_outlined;
      case ExamType.assessment:
        return Icons.assessment_outlined;
    }
  }

  Color _getDifficultyColor() {
    switch (exam.difficulty) {
      case ExamDifficulty.beginner:
        return AppColors.success;
      case ExamDifficulty.intermediate:
        return AppColors.warning;
      case ExamDifficulty.advanced:
        return AppColors.error;
      case ExamDifficulty.expert:
        return AppColors.primary;
    }
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 80) {
      return AppColors.success;
    } else if (percentage >= 50) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }
}