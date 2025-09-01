import 'package:flutter/material.dart';
import '../../domain/entities/exam.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Grid item widget for displaying exam information in grid view
class ExamGridItem extends StatelessWidget {
  final Exam exam;
  final VoidCallback? onTap;
  final Function(bool)? onFavoriteToggle;
  final bool showProgress;

  const ExamGridItem({
    super.key,
    required this.exam,
    this.onTap,
    this.onFavoriteToggle,
    this.showProgress = true,
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
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 8),
              _buildTitle(context),
              const SizedBox(height: 4),
              _buildCategory(context),
              const Spacer(),
              _buildMetadata(context),
              if (showProgress && exam.userProgress != null) ..[
                const SizedBox(height: 8),
                _buildProgress(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Exam type icon with difficulty color
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getDifficultyColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getExamTypeIcon(),
            color: _getDifficultyColor(),
            size: 20,
          ),
        ),
        
        // Favorite button
        if (onFavoriteToggle != null)
          GestureDetector(
            onTap: () => onFavoriteToggle?.call(!exam.isFavorite),
            child: Icon(
              exam.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: exam.isFavorite ? AppColors.error : AppColors.textSecondary,
              size: 20,
            ),
          ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      exam.title,
      style: AppTextStyles.titleSmall.copyWith(
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCategory(BuildContext context) {
    if (exam.categoryName == null) {
      return const SizedBox.shrink();
    }
    
    return Text(
      exam.categoryName!,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Difficulty and duration
        Row(
          children: [
            _buildDifficultyChip(),
            const Spacer(),
            if (exam.duration != null)
              _buildMetadataItem(
                icon: Icons.access_time,
                label: DurationFormatter.formatShort(exam.duration!),
              ),
          ],
        ),
        const SizedBox(height: 4),
        
        // Question count and rating
        Row(
          children: [
            _buildMetadataItem(
              icon: Icons.quiz_outlined,
              label: '${exam.questionCount}',
            ),
            const Spacer(),
            if (exam.stats.averageRating > 0)
              _buildMetadataItem(
                icon: Icons.star,
                label: exam.stats.averageRating.toStringAsFixed(1),
                color: AppColors.warning,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultyChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getDifficultyColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _getDifficultyColor().withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        exam.difficulty.displayName.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: _getDifficultyColor(),
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
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
          size: 12,
          color: color ?? AppColors.textSecondary,
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: color ?? AppColors.textSecondary,
            fontSize: 11,
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
              _getProgressText(),
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
            Text(
              '${progressPercentage.toStringAsFixed(0)}%',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: _getProgressColor(progressPercentage),
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        LinearProgressIndicator(
          value: progressPercentage / 100,
          backgroundColor: AppColors.surface,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(progressPercentage),
          ),
          minHeight: 3,
        ),
      ],
    );
  }

  String _getProgressText() {
    final progress = exam.userProgress!;
    
    if (progress.isCompleted) {
      return 'Completed';
    } else if (progress.isStarted) {
      return 'In Progress';
    } else {
      return 'Not Started';
    }
  }

  IconData _getExamTypeIcon() {
    switch (exam.examType) {
      case ExamType.practice:
        return Icons.school_outlined;
      case ExamType.mock:
        return Icons.quiz_outlined;
      case ExamType.certification:
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