import 'package:flutter/material.dart';
import '../../domain/entities/recent_activity.dart';

class RecentActivitiesSection extends StatelessWidget {
  final List<RecentActivity> activities;
  final Function(RecentActivity)? onActivityTap;
  final VoidCallback? onViewAll;

  const RecentActivitiesSection({
    Key? key,
    required this.activities,
    this.onActivityTap,
    this.onViewAll,
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
            if (activities.isEmpty)
              _buildEmptyState(context)
            else
              _buildActivitiesList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.history,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Recent Activities',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        if (activities.isNotEmpty && onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'View All',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No recent activities',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start learning to see your activities here!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesList(BuildContext context) {
    // Show only the first 5 activities
    final displayActivities = activities.take(5).toList();
    
    return Column(
      children: displayActivities.asMap().entries.map((entry) {
        final index = entry.key;
        final activity = entry.value;
        final isLast = index == displayActivities.length - 1;
        
        return Column(
          children: [
            _buildActivityItem(context, activity),
            if (!isLast)
              Divider(
                height: 24,
                color: Colors.grey[300],
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildActivityItem(BuildContext context, RecentActivity activity) {
    return GestureDetector(
      onTap: () => onActivityTap?.call(activity),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Activity Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getActivityColor(activity.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getActivityColor(activity.type).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                _getActivityIcon(activity.type),
                color: _getActivityColor(activity.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Activity Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimestamp(activity.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                      ),
                      if (activity.metadata.isNotEmpty) ...[
                        const SizedBox(width: 16),
                        ..._buildMetadataTags(context, activity.metadata),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Activity Status/Score
            if (activity.metadata.containsKey('score') ||
                activity.metadata.containsKey('status'))
              _buildActivityBadge(context, activity),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityBadge(BuildContext context, RecentActivity activity) {
    if (activity.metadata.containsKey('score')) {
      final score = activity.metadata['score'];
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getScoreColor(score).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getScoreColor(score).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          '${score}%',
          style: TextStyle(
            color: _getScoreColor(score),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    }
    
    if (activity.metadata.containsKey('status')) {
      final status = activity.metadata['status'];
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor(status).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStatusColor(status).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          status.toString().toUpperCase(),
          style: TextStyle(
            color: _getStatusColor(status),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  List<Widget> _buildMetadataTags(BuildContext context, Map<String, dynamic> metadata) {
    final tags = <Widget>[];
    
    if (metadata.containsKey('subject')) {
      tags.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            metadata['subject'].toString(),
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    
    if (metadata.containsKey('duration')) {
      tags.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${metadata['duration']}min',
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    
    return tags.take(2).toList(); // Limit to 2 tags to avoid overflow
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return Colors.blue;
      case 'practice':
        return Colors.green;
      case 'study':
        return Colors.orange;
      case 'achievement':
        return Colors.purple;
      case 'review':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return Icons.quiz;
      case 'practice':
        return Icons.fitness_center;
      case 'study':
        return Icons.menu_book;
      case 'achievement':
        return Icons.emoji_events;
      case 'review':
        return Icons.rate_review;
      default:
        return Icons.circle;
    }
  }

  Color _getScoreColor(dynamic score) {
    final scoreValue = score is String ? double.tryParse(score) ?? 0 : score.toDouble();
    
    if (scoreValue >= 90) return Colors.green;
    if (scoreValue >= 80) return Colors.lightGreen;
    if (scoreValue >= 70) return Colors.orange;
    if (scoreValue >= 60) return Colors.deepOrange;
    return Colors.red;
  }

  Color _getStatusColor(dynamic status) {
    switch (status.toString().toLowerCase()) {
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}