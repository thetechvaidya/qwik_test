import 'package:flutter/material.dart';

import '../../domain/entities/user_stats.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({
    Key? key,
    required this.stats,
    this.isLoading = false,
    this.onStatTap,
  }) : super(key: key);

  final UserStats stats;
  final bool isLoading;
  final Function(String statType)? onStatTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isLoading) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistics',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );
    }
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard(
                  context,
                  icon: Icons.quiz,
                  label: 'Exams Taken',
                  value: stats.examsTaken.toString(),
                  color: Colors.blue,
                  onTap: () => onStatTap?.call('exams'),
                ),
                _buildStatCard(
                  context,
                  icon: Icons.star,
                  label: 'Average Score',
                  value: '${stats.averageScore.toStringAsFixed(1)}%',
                  color: Colors.orange,
                  onTap: () => onStatTap?.call('scores'),
                ),
                _buildStatCard(
                  context,
                  icon: Icons.timer,
                  label: 'Study Time',
                  value: _formatStudyTime(stats.totalStudyTime),
                  color: Colors.green,
                  onTap: () => onStatTap?.call('study_time'),
                ),
                _buildStatCard(
                  context,
                  icon: Icons.emoji_events,
                  label: 'Achievements',
                  value: stats.achievementsUnlocked.toString(),
                  color: Colors.purple,
                  onTap: () => onStatTap?.call('achievements'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildProgressItem(
          context,
          label: 'Current Streak',
          value: '${stats.currentStreak} days',
          progress: (stats.currentStreak / 30).clamp(0.0, 1.0),
          color: Colors.orange,
        ),
        const SizedBox(height: 8),
        _buildProgressItem(
          context,
          label: 'Best Streak',
          value: '${stats.bestStreak} days',
          progress: (stats.bestStreak / 100).clamp(0.0, 1.0),
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildProgressItem(
    BuildContext context, {
    required String label,
    required String value,
    required double progress,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  String _formatStudyTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    } else if (minutes < 1440) {
      final hours = (minutes / 60).floor();
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0 ? '${hours}h ${remainingMinutes}m' : '${hours}h';
    } else {
      final days = (minutes / 1440).floor();
      final remainingHours = ((minutes % 1440) / 60).floor();
      return remainingHours > 0 ? '${days}d ${remainingHours}h' : '${days}d';
    }
  }
}