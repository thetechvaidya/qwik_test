import 'package:flutter/material.dart';
import '../../domain/entities/exam.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/duration_formatter.dart';

/// Section widget for displaying featured exams horizontally
class FeaturedExamsSection extends StatelessWidget {
  final List<Exam> exams;
  final Function(Exam) onExamTap;
  final Function(Exam, bool)? onFavoriteToggle;
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;

  const FeaturedExamsSection({
    super.key,
    required this.exams,
    required this.onExamTap,
    this.onFavoriteToggle,
    this.title = 'Featured Exams',
    this.showSeeAll = true,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (exams.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildExamsList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showSeeAll && onSeeAllTap != null)
            TextButton(
              onPressed: onSeeAllTap,
              child: Text(
                'See All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExamsList(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return Container(
            width: 240,
            margin: EdgeInsets.only(
              right: index < exams.length - 1 ? 16 : 0,
            ),
            child: _FeaturedExamCard(
              exam: exam,
              onTap: () => onExamTap(exam),
              onFavoriteToggle: onFavoriteToggle != null
                  ? (isFavorite) => onFavoriteToggle!(exam, isFavorite)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback onTap;
  final Function(bool)? onFavoriteToggle;

  const _FeaturedExamCard({
    required this.exam,
    required this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getDifficultyColor().withOpacity(0.1),
                _getDifficultyColor().withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                _buildTitle(context),
                const SizedBox(height: 8),
                _buildDescription(context),
                const Spacer(),
                _buildMetadata(context),
                const SizedBox(height: 12),
                _buildProgress(context),
                const SizedBox(height: 12),
                _buildActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Exam type badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getDifficultyColor().withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getExamTypeIcon(),
                size: 12,
                color: _getDifficultyColor(),
              ),
              const SizedBox(width: 4),
              Text(
                exam.examType.displayName.toUpperCase(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: _getDifficultyColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        
        // Favorite button
        if (onFavoriteToggle != null)
          GestureDetector(
            onTap: () => onFavoriteToggle?.call(!exam.isFavorite),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                exam.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: exam.isFavorite ? AppColors.error : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      exam.title,
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(BuildContext context) {
    if (exam.description == null || exam.description!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Text(
      exam.description!,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Difficulty and category
        Row(
          children: [
            _buildDifficultyChip(),
            if (exam.categoryName != null) ..[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  exam.categoryName!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        
        // Stats row
        Row(
          children: [
            _buildMetadataItem(
              icon: Icons.quiz_outlined,
              label: '${exam.questionCount}',
            ),
            const SizedBox(width: 12),
            if (exam.duration != null)
              _buildMetadataItem(
                icon: Icons.access_time,
                label: DurationFormatter.formatShort(exam.duration!),
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
          fontSize: 9,
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
    final progress = exam.userProgress;
    
    if (progress == null) {
      return const SizedBox.shrink();
    }
    
    final progressPercentage = progress.completionPercentage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getProgressText(progress),
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
        const SizedBox(height: 4),
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

  Widget _buildActionButton(BuildContext context) {
    final progress = exam.userProgress;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getActionButtonColor(progress),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          _getActionButtonText(progress),
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getProgressText(ExamUserProgress progress) {
    if (progress.isCompleted) {
      return 'Completed';
    } else if (progress.isStarted) {
      return 'In Progress';
    } else {
      return 'Not Started';
    }
  }

  String _getActionButtonText(ExamUserProgress? progress) {
    if (progress == null || !progress.isStarted) {
      return 'Start Exam';
    } else if (progress.isCompleted) {
      return 'View Results';
    } else {
      return 'Continue';
    }
  }

  Color _getActionButtonColor(ExamUserProgress? progress) {
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