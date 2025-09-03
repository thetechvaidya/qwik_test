import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/exam.dart';
import '../bloc/exam_bloc.dart';
import '../bloc/exam_state.dart';
import '../widgets/exam_loading_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/di/service_locator.dart';

/// Page for displaying detailed information about an exam
class ExamDetailPage extends StatefulWidget {
  final String examId;
  final Exam? exam; // Optional exam data if already available

  const ExamDetailPage({
    super.key,
    required this.examId,
    this.exam,
  });

  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  late ExamBloc _examBloc;

  @override
  void initState() {
    super.initState();
    _examBloc = sl<ExamBloc>();
    
    // Load exam details if not already provided
    if (widget.exam == null) {
      _examBloc.add(LoadExamDetailEvent(examId: widget.examId));
    }
  }

  @override
  void dispose() {
    _examBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _examBloc,
      child: Scaffold(
        body: BlocBuilder<ExamBloc, ExamState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                _buildAppBar(context, state),
                SliverToBoxAdapter(
                  child: _buildContent(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ExamState state) {
    final exam = _getExamFromState(state);
    
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          exam?.title ?? 'Exam Details',
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: exam != null ? _buildAppBarContent(exam) : null,
        ),
      ),
      actions: [
        if (exam != null)
          IconButton(
            onPressed: () => _toggleFavorite(exam),
            icon: Icon(
              exam.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: exam.isFavorite ? AppColors.error : Colors.white,
            ),
          ),
        IconButton(
          onPressed: () => _shareExam(exam),
          icon: const Icon(Icons.share),
        ),
      ],
    );
  }

  Widget _buildAppBarContent(Exam exam) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60), // Space for title
          Row(
            children: [
              _buildExamTypeBadge(exam),
              const SizedBox(width: 12),
              _buildDifficultyBadge(exam),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            exam.categoryName,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ExamState state) {
    if (state is ExamDetailLoading) {
      return const ExamLoadingWidget.detail();
    }
    
    if (state is ExamDetailError) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: AppErrorWidget(
          message: state.message,
          onRetry: () => _examBloc.add(
            LoadExamDetailEvent(examId: widget.examId),
          ),
        ),
      );
    }
    
    final exam = _getExamFromState(state);
    if (exam == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: AppErrorWidget(
          message: 'Exam not found',
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsCards(exam),
          const SizedBox(height: 24),
          _buildProgressSection(exam),
          const SizedBox(height: 24),
          _buildDescriptionSection(exam),
          const SizedBox(height: 24),
          _buildRequirementsSection(exam),
          const SizedBox(height: 24),
          _buildTopicsSection(exam),
          const SizedBox(height: 32),
          _buildActionButtons(exam),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatsCards(Exam exam) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.quiz_outlined,
            title: 'Questions',
            value: exam.totalQuestions.toString(),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.access_time,
            title: 'Duration',
            value: exam.duration != null 
                ? DurationFormatter.format(exam.duration!)
                : 'Unlimited',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            title: 'Rating',
            value: exam.stats.averageRating > 0
                ? exam.stats.averageRating.toStringAsFixed(1)
                : 'N/A',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(Exam exam) {
    final progress = exam.userProgress;
    
    if (progress == null) {
      return const SizedBox.shrink();
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Progress',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${progress.completionPercentage.toStringAsFixed(0)}%',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getProgressColor(progress.completionPercentage),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.completionPercentage / 100,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(progress.completionPercentage),
              ),
              minHeight: 8,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressItem(
                  'Correct',
                  progress.correctAnswers.toString(),
                  AppColors.success,
                ),
                _buildProgressItem(
                  'Incorrect',
                  progress.incorrectAnswers.toString(),
                  AppColors.error,
                ),
                _buildProgressItem(
                  'Remaining',
                  (exam.totalQuestions - progress.answeredQuestions).toString(),
                  AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(Exam exam) {
    if (exam.description == null || exam.description!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          exam.description!,
          style: AppTextStyles.bodyLarge.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementsSection(Exam exam) {
    if (exam.requirements.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requirements',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...exam.requirements.map(
          (requirement) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    requirement,
                    style: AppTextStyles.bodyMedium.copyWith(
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopicsSection(Exam exam) {
    if (exam.topics.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topics Covered',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: exam.topics.map(
            (topic) => Chip(
              label: Text(
                topic,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              backgroundColor: AppColors.primary.withOpacity(0.1),
              side: BorderSide(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Exam exam) {
    final progress = exam.userProgress;
    
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _startOrContinueExam(exam),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getActionButtonColor(progress),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_getActionButtonIcon(progress)),
                const SizedBox(width: 8),
                Text(
                  _getActionButtonText(progress),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (progress != null && progress.isStarted && !progress.isCompleted) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _resetExam(exam),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh),
                  const SizedBox(width: 8),
                  Text(
                    'Reset Progress',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExamTypeBadge(Exam exam) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getExamTypeIcon(exam.examType),
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            exam.examType.displayName,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge(Exam exam) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getDifficultyColor(exam.difficulty).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Text(
        exam.difficulty.displayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Exam? _getExamFromState(ExamState state) {
    if (widget.exam != null) {
      return widget.exam;
    }
    
    if (state is ExamDetailLoaded) {
      return state.exam;
    }
    
    return null;
  }

  void _toggleFavorite(Exam exam) {
    _examBloc.add(ToggleExamFavoriteEvent(
      examId: exam.id,
      isFavorite: !exam.isFavorite,
    ));
  }

  void _shareExam(Exam? exam) {
    if (exam == null) return;
    
    // Implement share functionality
    // This could use the share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${exam.title}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startOrContinueExam(Exam exam) {
    final progress = exam.userProgress;
    
    if (progress == null || !progress.isStarted) {
      _examBloc.add(StartExamEvent(examId: exam.id));
    } else if (progress.isCompleted) {
      // Show completion message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exam completed successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    } else {
      _examBloc.add(ResumeExamEvent(examId: exam.id));
    }
  }

  void _resetExam(Exam exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'Are you sure you want to reset your progress? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement reset functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Progress reset successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  String _getActionButtonText(ExamUserProgress? progress) {
    if (progress == null || !progress.isStarted) {
      return 'Start Exam';
    } else if (progress.isCompleted) {
      return 'Exam Completed';
    } else {
      return 'Continue Exam';
    }
  }

  IconData _getActionButtonIcon(ExamUserProgress? progress) {
    if (progress == null || !progress.isStarted) {
      return Icons.play_arrow;
    } else if (progress.isCompleted) {
      return Icons.assessment;
    } else {
      return Icons.play_arrow;
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

  Color _getProgressColor(double percentage) {
    if (percentage >= 80) {
      return AppColors.success;
    } else if (percentage >= 50) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  IconData _getExamTypeIcon(ExamType type) {
    switch (type) {
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

  Color _getDifficultyColor(ExamDifficulty difficulty) {
    switch (difficulty) {
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
}