import 'package:flutter/material.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/option.dart';
import '../../domain/entities/answer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/cached_network_image_widget.dart';

/// Widget for displaying answer options and handling selections
class AnswerOptionsWidget extends StatelessWidget {
  final Question question;
  final Answer? selectedAnswer;
  final Function(Answer) onAnswerSelected;
  final bool showCorrectAnswers;
  final bool isReviewMode;

  const AnswerOptionsWidget({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    this.selectedAnswer,
    this.showCorrectAnswers = false,
    this.isReviewMode = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.singleChoice:
      case QuestionType.trueFalse:
        return _buildSingleChoiceOptions();
      case QuestionType.multipleChoice:
        return _buildMultipleChoiceOptions();
      default:
        return const Center(
          child: Text(
            'Unsupported question type',
            style: TextStyle(color: Colors.red),
          ),
        );
    }
  }

  Widget _buildSingleChoiceOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select one answer:',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswer?.selectedOptionIds.contains(option.id) ?? false;
          
          return _buildSingleChoiceOption(
            option: option,
            index: index,
            isSelected: isSelected,
            onTap: () => _handleSingleChoiceSelection(option),
          );
        }),
      ],
    );
  }

  Widget _buildMultipleChoiceOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select all correct answers:',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswer?.selectedOptionIds.contains(option.id) ?? false;
          
          return _buildMultipleChoiceOption(
            option: option,
            index: index,
            isSelected: isSelected,
            onTap: () => _handleMultipleChoiceSelection(option),
          );
        }),
      ],
    );
  }



  Widget _buildSingleChoiceOption({
    required Option option,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isReviewMode ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getOptionBackgroundColor(option, isSelected),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getOptionBorderColor(option, isSelected),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Radio button
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.outline,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.circle,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
              
              const SizedBox(width: 12),
              
              // Option label
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getOptionLabelColor(option, isSelected),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D...
                    style: AppTextStyles.labelMedium.copyWith(
                      color: _getOptionLabelTextColor(option, isSelected),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Option content
              Expanded(
                child: _buildOptionContent(option),
              ),
              
              // Correct/Incorrect indicator (if in review mode)
              if (showCorrectAnswers) _buildAnswerIndicator(option, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceOption({
    required Option option,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isReviewMode ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getOptionBackgroundColor(option, isSelected),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getOptionBorderColor(option, isSelected),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.outline,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              
              const SizedBox(width: 12),
              
              // Option label
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getOptionLabelColor(option, isSelected),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D...
                    style: AppTextStyles.labelMedium.copyWith(
                      color: _getOptionLabelTextColor(option, isSelected),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Option content
              Expanded(
                child: _buildOptionContent(option),
              ),
              
              // Correct/Incorrect indicator (if in review mode)
              if (showCorrectAnswers) _buildAnswerIndicator(option, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionContent(Option option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          option.text,
          style: AppTextStyles.bodyMedium.copyWith(
            height: 1.4,
          ),
        ),
        if (option.imageUrl != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImageWidget(
              imageUrl: option.imageUrl!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAnswerIndicator(Option option, bool isSelected) {
    if (!showCorrectAnswers) return const SizedBox.shrink();
    
    final isCorrect = option.isCorrect;
    
    if (isCorrect && isSelected) {
      // Correct and selected
      return Icon(
        Icons.check_circle,
        color: AppColors.success,
        size: 24,
      );
    } else if (isCorrect && !isSelected) {
      // Correct but not selected
      return Icon(
        Icons.check_circle_outline,
        color: AppColors.success,
        size: 24,
      );
    } else if (!isCorrect && isSelected) {
      // Incorrect and selected
      return Icon(
        Icons.cancel,
        color: AppColors.error,
        size: 24,
      );
    }
    
    return const SizedBox.shrink();
  }

  Color _getOptionBackgroundColor(Option option, bool isSelected) {
    if (showCorrectAnswers) {
      if (option.isCorrect && isSelected) {
        return AppColors.success.withOpacity(0.1);
      } else if (!option.isCorrect && isSelected) {
        return AppColors.error.withOpacity(0.1);
      } else if (option.isCorrect) {
        return AppColors.success.withOpacity(0.05);
      }
    }
    
    return isSelected 
        ? AppColors.primaryContainer.withOpacity(0.3)
        : AppColors.surface;
  }

  Color _getOptionBorderColor(Option option, bool isSelected) {
    if (showCorrectAnswers) {
      if (option.isCorrect) {
        return AppColors.success;
      } else if (isSelected) {
        return AppColors.error;
      }
    }
    
    return isSelected ? AppColors.primary : AppColors.outline;
  }

  Color _getOptionLabelColor(Option option, bool isSelected) {
    if (showCorrectAnswers) {
      if (option.isCorrect) {
        return AppColors.success;
      } else if (isSelected) {
        return AppColors.error;
      }
    }
    
    return isSelected ? AppColors.primary : AppColors.surfaceVariant;
  }

  Color _getOptionLabelTextColor(Option option, bool isSelected) {
    if (showCorrectAnswers) {
      if (option.isCorrect || isSelected) {
        return Colors.white;
      }
    }
    
    return isSelected ? Colors.white : AppColors.onSurfaceVariant;
  }

  void _handleSingleChoiceSelection(Option option) {
    final answer = Answer(
      questionId: question.id,
      selectedOptionIds: [option.id],
      timeSpent: selectedAnswer?.timeSpent ?? 0,
      answeredAt: DateTime.now(),
      isCorrect: option.isCorrect,
      score: option.isCorrect ? question.marks : 0,
    );
    
    onAnswerSelected(answer);
  }

  void _handleMultipleChoiceSelection(Option option) {
    final currentSelections = List<String>.from(
      selectedAnswer?.selectedOptionIds ?? [],
    );
    
    if (currentSelections.contains(option.id)) {
      currentSelections.remove(option.id);
    } else {
      currentSelections.add(option.id);
    }
    
    // Calculate if answer is correct (all correct options selected, no incorrect ones)
    final correctOptionIds = question.options
        .where((opt) => opt.isCorrect)
        .map((opt) => opt.id)
        .toSet();
    final selectedOptionIds = currentSelections.toSet();
    final isCorrect = correctOptionIds.difference(selectedOptionIds).isEmpty &&
        selectedOptionIds.difference(correctOptionIds).isEmpty;
    
    final answer = Answer(
      questionId: question.id,
      selectedOptionIds: currentSelections,
      timeSpent: selectedAnswer?.timeSpent ?? 0,
      answeredAt: DateTime.now(),
      isCorrect: isCorrect,
      score: isCorrect ? question.marks : 0,
    );
    
    onAnswerSelected(answer);
  }


}