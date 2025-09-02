import 'package:flutter/material.dart';
import '../../domain/entities/exam_session.dart';
import '../../domain/entities/answer.dart';
import '../utils/exam_progress_tracker.dart';

class QuestionPaletteWidget extends StatelessWidget {
  final ExamSession session;
  final int currentQuestionIndex;
  final Function(int) onQuestionTap;
  final VoidCallback? onClose;

  const QuestionPaletteWidget({
    super.key,
    required this.session,
    required this.currentQuestionIndex,
    required this.onQuestionTap,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressTracker = ExamProgressTracker(session);
    
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context, progressTracker),
          _buildLegend(context),
          Expanded(
            child: _buildQuestionGrid(context, progressTracker),
          ),
          _buildSummary(context, progressTracker),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ExamProgressTracker progressTracker) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.grid_view,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question Palette',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${progressTracker.answeredCount}/${session.questions.length} answered',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem(
                context,
                color: theme.colorScheme.primary,
                label: 'Current',
              ),
              _buildLegendItem(
                context,
                color: Colors.green,
                label: 'Answered',
              ),
              _buildLegendItem(
                context,
                color: Colors.orange,
                label: 'Marked',
              ),
              _buildLegendItem(
                context,
                color: Colors.grey,
                label: 'Unanswered',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, {
    required Color color,
    required String label,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildQuestionGrid(BuildContext context, ExamProgressTracker progressTracker) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: session.questions.length,
        itemBuilder: (context, index) {
          return _buildQuestionItem(context, index, progressTracker);
        },
      ),
    );
  }

  Widget _buildQuestionItem(BuildContext context, int index, ExamProgressTracker progressTracker) {
    final theme = Theme.of(context);
    final isCurrent = index == currentQuestionIndex;
    final status = progressTracker.getQuestionStatus(index);
    
    Color backgroundColor;
    Color textColor;
    
    if (isCurrent) {
      backgroundColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onPrimary;
    } else {
      switch (status) {
        case QuestionStatus.answered:
          backgroundColor = Colors.green;
          textColor = Colors.white;
          break;
        case QuestionStatus.markedForReview:
          backgroundColor = Colors.orange;
          textColor = Colors.white;
          break;
        case QuestionStatus.skipped:
        case QuestionStatus.unanswered:
          backgroundColor = Colors.grey.shade300;
          textColor = Colors.grey.shade700;
          break;
      }
    }
    
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => onQuestionTap(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isCurrent
                ? Border.all(
                    color: theme.colorScheme.onPrimary,
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${index + 1}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (status == QuestionStatus.markedForReview)
                  Icon(
                    Icons.bookmark,
                    size: 12,
                    color: textColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, ExamProgressTracker progressTracker) {
    final theme = Theme.of(context);
    final summary = progressTracker.getProgressSummary();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(context, 'Answered', '${summary.answeredCount}'),
          _buildSummaryRow(context, 'Marked for Review', '${summary.markedForReviewCount}'),
          _buildSummaryRow(context, 'Skipped', '${summary.skippedCount}'),
          _buildSummaryRow(context, 'Unanswered', '${summary.unansweredCount}'),
          const Divider(),
          _buildSummaryRow(
            context,
            'Progress',
            '${(summary.progressPercentage * 100).toStringAsFixed(1)}%',
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isHighlighted = false}) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: isHighlighted ? FontWeight.w600 : null,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isHighlighted ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}

class CompactQuestionPaletteWidget extends StatelessWidget {
  final ExamSession session;
  final int currentQuestionIndex;
  final Function(int) onQuestionTap;

  const CompactQuestionPaletteWidget({
    super.key,
    required this.session,
    required this.currentQuestionIndex,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressTracker = ExamProgressTracker(session);
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Questions:',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: session.questions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildCompactQuestionItem(context, index, progressTracker),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactQuestionItem(BuildContext context, int index, ExamProgressTracker progressTracker) {
    final theme = Theme.of(context);
    final isCurrent = index == currentQuestionIndex;
    final status = progressTracker.getQuestionStatus(index);
    
    Color backgroundColor;
    Color textColor;
    
    if (isCurrent) {
      backgroundColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onPrimary;
    } else {
      switch (status) {
        case QuestionStatus.answered:
          backgroundColor = Colors.green;
          textColor = Colors.white;
          break;
        case QuestionStatus.markedForReview:
          backgroundColor = Colors.orange;
          textColor = Colors.white;
          break;
        case QuestionStatus.skipped:
        case QuestionStatus.unanswered:
          backgroundColor = Colors.grey.shade300;
          textColor = Colors.grey.shade700;
          break;
      }
    }
    
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: () => onQuestionTap(index),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: isCurrent
                ? Border.all(
                    color: theme.colorScheme.onPrimary,
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}