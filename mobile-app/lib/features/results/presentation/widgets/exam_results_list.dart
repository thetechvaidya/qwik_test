import 'package:flutter/material.dart';
import '../../domain/entities/exam_result.dart';

class ExamResultsList extends StatelessWidget {
  final List<ExamResult> examResults;
  final bool isLoading;
  final Function(ExamResult)? onResultTap;
  final VoidCallback? onLoadMore;

  const ExamResultsList({
    Key? key,
    required this.examResults,
    this.isLoading = false,
    this.onResultTap,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (examResults.isEmpty && !isLoading) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        ...examResults.asMap().entries.map((entry) {
          final index = entry.key;
          final result = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: index == examResults.length - 1 ? 16 : 8,
            ),
            child: _buildResultCard(context, result),
          );
        }),
        
        // Load more button
        if (examResults.isNotEmpty && onLoadMore != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? const CircularProgressIndicator()
                : OutlinedButton(
                    onPressed: onLoadMore,
                    child: const Text('Load More Results'),
                  ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No exam results found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Take your first exam to see results here!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, ExamResult result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onResultTap?.call(result),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with exam title and score
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.examTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          result.subject,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildScoreBadge(context, result.score),
                ],
              ),
              const SizedBox(height: 16),
              
              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Questions',
                      '${result.correctAnswers}/${result.totalQuestions}',
                      Icons.quiz,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Accuracy',
                      '${((result.correctAnswers / result.totalQuestions) * 100).toStringAsFixed(1)}%',
                      Icons.target,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Duration',
                      _formatDuration(result.duration),
                      Icons.timer,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        '${result.correctAnswers}/${result.totalQuestions}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _getScoreColor(result.score),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: result.correctAnswers / result.totalQuestions,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getScoreColor(result.score),
                    ),
                    minHeight: 6,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Footer with date and status
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(result.completedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const Spacer(),
                  _buildStatusChip(context, result.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBadge(BuildContext context, double score) {
    final color = _getScoreColor(score);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getScoreIcon(score),
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${score.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 70) return Colors.orange;
    if (score >= 60) return Colors.deepOrange;
    return Colors.red;
  }

  IconData _getScoreIcon(double score) {
    if (score >= 90) return Icons.emoji_events;
    if (score >= 80) return Icons.thumb_up;
    if (score >= 70) return Icons.trending_up;
    if (score >= 60) return Icons.trending_flat;
    return Icons.trending_down;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _formatDuration(int durationInSeconds) {
    final duration = Duration(seconds: durationInSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${weekdays[date.weekday - 1]} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}