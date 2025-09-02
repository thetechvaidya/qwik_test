import 'package:equatable/equatable.dart';

/// Entity representing a recent activity item in the user's timeline
class RecentActivity extends Equatable {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final DateTime completedAt;
  final Map<String, dynamic> metadata;
  final String? examId;
  final String? examTitle;
  final double? score;
  final String? achievementId;
  final String? achievementTitle;
  final int? streakCount;
  final int? pointsEarned;

  const RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.completedAt,
    required this.metadata,
    this.examId,
    this.examTitle,
    this.score,
    this.achievementId,
    this.achievementTitle,
    this.streakCount,
    this.pointsEarned,
  });

  /// Get activity icon based on type
  String getActivityIcon() {
    switch (type) {
      case ActivityType.examCompleted:
        return '📝';
      case ActivityType.achievementUnlocked:
        return '🏆';
      case ActivityType.streakMilestone:
        return '🔥';
      case ActivityType.perfectScore:
        return '💯';
      case ActivityType.firstExam:
        return '🎯';
      case ActivityType.levelUp:
        return '⬆️';
      case ActivityType.categoryMastery:
        return '🎓';
      case ActivityType.timeRecord:
        return '⏱️';
    }
  }

  /// Get activity color based on type
  String getActivityColor() {
    switch (type) {
      case ActivityType.examCompleted:
        return '#4CAF50'; // Green
      case ActivityType.achievementUnlocked:
        return '#FF9800'; // Orange
      case ActivityType.streakMilestone:
        return '#F44336'; // Red
      case ActivityType.perfectScore:
        return '#9C27B0'; // Purple
      case ActivityType.firstExam:
        return '#2196F3'; // Blue
      case ActivityType.levelUp:
        return '#00BCD4'; // Cyan
      case ActivityType.categoryMastery:
        return '#8BC34A'; // Light Green
      case ActivityType.timeRecord:
        return '#FF5722'; // Deep Orange
    }
  }

  /// Format activity description with dynamic data
  String getFormattedDescription() {
    switch (type) {
      case ActivityType.examCompleted:
        if (score != null) {
          return 'Completed "$examTitle" with ${score!.toStringAsFixed(1)}% score';
        }
        return description;
      case ActivityType.achievementUnlocked:
        return 'Unlocked "$achievementTitle" achievement';
      case ActivityType.streakMilestone:
        return 'Reached $streakCount day learning streak!';
      case ActivityType.perfectScore:
        return 'Perfect score on "$examTitle"!';
      case ActivityType.firstExam:
        return 'Completed first exam: "$examTitle"';
      case ActivityType.levelUp:
        return description;
      case ActivityType.categoryMastery:
        return description;
      case ActivityType.timeRecord:
        return description;
    }
  }

  /// Get relative time string
  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(completedAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${completedAt.day}/${completedAt.month}/${completedAt.year}';
    }
  }

  /// Check if activity is recent (within last 24 hours)
  bool isRecent() {
    final now = DateTime.now();
    final difference = now.difference(completedAt);
    return difference.inHours < 24;
  }

  /// Check if activity is today
  bool isToday() {
    final now = DateTime.now();
    return completedAt.year == now.year &&
        completedAt.month == now.month &&
        completedAt.day == now.day;
  }

  /// Get activity priority for sorting
  int getPriority() {
    switch (type) {
      case ActivityType.achievementUnlocked:
        return 1; // Highest priority
      case ActivityType.perfectScore:
        return 2;
      case ActivityType.streakMilestone:
        return 3;
      case ActivityType.levelUp:
        return 4;
      case ActivityType.categoryMastery:
        return 5;
      case ActivityType.firstExam:
        return 6;
      case ActivityType.timeRecord:
        return 7;
      case ActivityType.examCompleted:
        return 8; // Lowest priority
    }
  }

  /// Check if activity should show points earned
  bool shouldShowPoints() {
    return pointsEarned != null && pointsEarned! > 0;
  }

  /// Get formatted points string
  String? getFormattedPoints() {
    if (pointsEarned == null || pointsEarned! <= 0) return null;
    return '+${pointsEarned!} pts';
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        completedAt,
        metadata,
        examId,
        examTitle,
        score,
        achievementId,
        achievementTitle,
        streakCount,
        pointsEarned,
      ];

  @override
  String toString() {
    return 'RecentActivity(id: $id, type: $type, title: $title, completedAt: $completedAt)';
  }
}

/// Enum for different types of activities
enum ActivityType {
  examCompleted,
  achievementUnlocked,
  streakMilestone,
  perfectScore,
  firstExam,
  levelUp,
  categoryMastery,
  timeRecord,
}

/// Extension for activity type
extension ActivityTypeExtension on ActivityType {
  String get displayName {
    switch (this) {
      case ActivityType.examCompleted:
        return 'Exam Completed';
      case ActivityType.achievementUnlocked:
        return 'Achievement Unlocked';
      case ActivityType.streakMilestone:
        return 'Streak Milestone';
      case ActivityType.perfectScore:
        return 'Perfect Score';
      case ActivityType.firstExam:
        return 'First Exam';
      case ActivityType.levelUp:
        return 'Level Up';
      case ActivityType.categoryMastery:
        return 'Category Mastery';
      case ActivityType.timeRecord:
        return 'Time Record';
    }
  }
}