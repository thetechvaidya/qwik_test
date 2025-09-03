import 'package:flutter/material.dart';
import '../../domain/entities/achievement.dart';

class AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;
  final Function(String achievementId)? onAchievementTap;

  const AchievementsSection({
    Key? key,
    required this.achievements,
    this.onAchievementTap,
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
            if (achievements.isEmpty)
              _buildEmptyState(context)
            else
              _buildAchievementsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;
    final totalCount = achievements.length;
    
    return Row(
      children: [
        Icon(
          Icons.emoji_events,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '$unlockedCount of $totalCount unlocked',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        if (totalCount > 0)
          CircularProgressIndicator(
            value: unlockedCount / totalCount,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
            strokeWidth: 3,
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
              Icons.emoji_events_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No achievements yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start learning to unlock achievements!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsList(BuildContext context) {
    // Sort achievements: unlocked first, then by progress
    final sortedAchievements = List<Achievement>.from(achievements)
      ..sort((a, b) {
        if (a.isUnlocked && !b.isUnlocked) return -1;
        if (!a.isUnlocked && b.isUnlocked) return 1;
        return b.progress.compareTo(a.progress);
      });

    return Column(
      children: [
        // Featured achievements (first 3)
        ...sortedAchievements.take(3).map(
          (achievement) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAchievementCard(context, achievement, featured: true),
          ),
        ),
        
        // Show more button if there are more achievements
        if (sortedAchievements.length > 3) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _showAllAchievements(context, sortedAchievements),
            child: Text(
              'View all ${sortedAchievements.length} achievements',
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

  Widget _buildAchievementCard(
    BuildContext context,
    Achievement achievement, {
    bool featured = false,
  }) {
    return GestureDetector(
      onTap: () => onAchievementTap?.call(achievement.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: achievement.isUnlocked
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: achievement.isUnlocked
                ? Theme.of(context).primaryColor.withOpacity(0.3)
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Achievement Icon
            Container(
              width: featured ? 60 : 50,
              height: featured ? 60 : 50,
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? _getAchievementColor(achievement.category)
                    : Colors.grey[400],
                shape: BoxShape.circle,
                boxShadow: achievement.isUnlocked
                    ? [
                        BoxShadow(
                          color: _getAchievementColor(achievement.category)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                _getAchievementIcon(achievement.category),
                color: Colors.white,
                size: featured ? 30 : 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Achievement Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: achievement.isUnlocked
                                    ? Colors.black87
                                    : Colors.grey[600],
                              ),
                        ),
                      ),
                      if (achievement.isUnlocked)
                        Icon(
                          Icons.check_circle,
                          color: _getAchievementColor(achievement.category),
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Progress Bar (only for locked achievements)
                  if (!achievement.isUnlocked) ...[
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: achievement.progress,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getAchievementColor(achievement.category),
                            ),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(achievement.progress * 100).toInt()}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _getAchievementColor(achievement.category),
                              ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Unlock date for unlocked achievements
                    if (achievement.unlockedAt != null)
                      Text(
                        'Unlocked ${_formatDate(achievement.unlockedAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getAchievementColor(achievement.category),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllAchievements(BuildContext context, List<Achievement> achievements) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'All Achievements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: achievements.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildAchievementCard(context, achievements[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAchievementColor(String category) {
    switch (category.toLowerCase()) {
      case 'learning':
        return Colors.blue;
      case 'performance':
        return Colors.green;
      case 'streak':
        return Colors.orange;
      case 'milestone':
        return Colors.purple;
      case 'special':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getAchievementIcon(String category) {
    switch (category.toLowerCase()) {
      case 'learning':
        return Icons.school;
      case 'performance':
        return Icons.trending_up;
      case 'streak':
        return Icons.local_fire_department;
      case 'milestone':
        return Icons.flag;
      case 'special':
        return Icons.star;
      default:
        return Icons.emoji_events;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}