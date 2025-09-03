import 'package:flutter/material.dart';
import '../../domain/entities/question.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/cached_network_image_widget.dart';

/// Widget for displaying question content including text, images, and metadata
class QuestionContentWidget extends StatelessWidget {
  final Question question;
  final int questionNumber;
  final bool showDifficulty;
  final bool showMarks;

  const QuestionContentWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    this.showDifficulty = true,
    this.showMarks = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header with number and metadata
          _buildQuestionHeader(),
          
          const SizedBox(height: 16),
          
          // Question text
          _buildQuestionText(),
          
          // Question image (if available)
          if (question.imageUrl != null) ...[
            const SizedBox(height: 16),
            _buildQuestionImage(),
          ],
          
          // Note: Attachment functionality has been simplified
        ],
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Q$questionNumber',
            style: AppTextStyles.labelMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Question metadata
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question type
              Text(
                _getQuestionTypeText(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              // Difficulty and marks
              if (showDifficulty || showMarks)
                Row(
                  children: [
                    if (showDifficulty) ...[
                      _buildDifficultyChip(),
                      if (showMarks) const SizedBox(width: 8),
                    ],
                    if (showMarks) _buildMarksChip(),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionText() {
    return SelectableText(
      question.text,
      style: AppTextStyles.bodyLarge.copyWith(
        height: 1.5,
      ),
    );
  }

  Widget _buildQuestionImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImageWidget(
        imageUrl: question.imageUrl!,
        width: double.infinity,
        fit: BoxFit.contain,
        placeholder: Container(
          height: 200,
          color: AppColors.surfaceVariant,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: Container(
          height: 200,
          color: AppColors.surfaceVariant,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                size: 48,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load image',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildDifficultyChip() {
    final difficulty = question.difficulty;
    Color chipColor;
    Color textColor;
    
    switch (difficulty) {
      case QuestionDifficulty.easy:
        chipColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case QuestionDifficulty.medium:
        chipColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case QuestionDifficulty.hard:
        chipColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty.displayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMarksChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${question.marks} ${question.marks == 1 ? 'mark' : 'marks'}',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getQuestionTypeText() {
    switch (question.type) {
      case QuestionType.singleChoice:
        return 'Single Choice';
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.fillInTheBlank:
        return 'Fill in the Blank';
      case QuestionType.essay:
        return 'Essay';
      case QuestionType.matching:
        return 'Matching';
      case QuestionType.ordering:
        return 'Ordering';
    }
  }


}