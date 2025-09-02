import 'package:flutter/material.dart';
import '../../domain/entities/study_recommendation.dart';

class StudyRecommendationsCard extends StatelessWidget {
  final List<StudyRecommendation> recommendations;
  final Function(StudyRecommendation)? onRecommendationTap;
  final Function()? onRefresh;
  final bool isLoading;

  const StudyRecommendationsCard({
    Key? key,
    required this.recommendations,
    this.onRecommendationTap,
    this.onRefresh,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            if (isLoading)
              _buildLoadingState(context)
            else if (recommendations.isEmpty)
              _buildEmptyState(context)
            else
              _buildRecommendationsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.lightbulb_outline,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Study Recommendations',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        if (onRefresh != null)
          IconButton(
            onPressed: isLoading ? null : onRefresh,
            icon: Icon(
              Icons.refresh,
              color: isLoading ? Colors.grey : Theme.of(context).primaryColor,
            ),
            tooltip: 'Refresh recommendations',
          ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Generating personalized recommendations...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No recommendations available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete more exams to get personalized study suggestions',
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

  Widget _buildRecommendationsList(BuildContext context) {
    return Column(
      children: [
        ...recommendations.take(5).map(
          (recommendation) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildRecommendationItem(context, recommendation),
          ),
        ),
        if (recommendations.length > 5) ..[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _showAllRecommendations(context),
            child: Text(
              'View all ${recommendations.length} recommendations',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRecommendationItem(BuildContext context, StudyRecommendation recommendation) {
    return GestureDetector(
      onTap: () => onRecommendationTap?.call(recommendation),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getPriorityColor(recommendation.priority).withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getPriorityColor(recommendation.priority).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(recommendation.priority),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    recommendation.priority.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation.subject,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Icon(
                  _getTypeIcon(recommendation.type),
                  size: 16,
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              recommendation.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              recommendation.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (recommendation.estimatedTime != null) ..[
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${recommendation.estimatedTime} min',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (recommendation.difficulty != null) ..[
                  Icon(
                    Icons.trending_up,
                    size: 14,
                    color: _getDifficultyColor(recommendation.difficulty!),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    recommendation.difficulty!.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getDifficultyColor(recommendation.difficulty!),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (recommendation.tags.isNotEmpty) ..[
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: recommendation.tags.take(3).map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ],
              ],
            ),
            if (recommendation.resources.isNotEmpty) ..[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.library_books,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${recommendation.resources.length} resource${recommendation.resources.length > 1 ? 's' : ''} available',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAllRecommendations(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'All Study Recommendations',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildRecommendationItem(context, recommendations[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'practice':
        return Icons.fitness_center;
      case 'review':
        return Icons.refresh;
      case 'concept':
        return Icons.school;
      case 'weak_area':
        return Icons.warning;
      case 'skill_building':
        return Icons.build;
      default:
        return Icons.lightbulb;
    }
  }
}