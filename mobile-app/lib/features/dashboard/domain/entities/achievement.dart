import 'package:equatable/equatable.dart';

/// Entity representing an achievement in the system
class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int progress;
  final int total;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final AchievementCategory category;
  final int points;
  final AchievementDifficulty difficulty;
  final List<String> requirements;
  final String? badgeUrl;
  final bool isHidden; // Hidden until requirements are met

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.total,
    required this.isUnlocked,
    this.unlockedAt,
    required this.category,
    required this.points,
    required this.difficulty,
    required this.requirements,
    this.badgeUrl,
    this.isHidden = false,
  });

  /// Calculate progress percentage
  double getProgressPercentage() {
    if (total == 0) return 0.0;
    return (progress / total * 100).clamp(0.0, 100.0);
  }

  /// Check if achievement is completed
  bool isCompleted() {
    return progress >= total;
  }

  /// Get estimated time to unlock (in days)
  int? getTimeToUnlock() {
    if (isUnlocked || progress >= total) return null;
    
    final remaining = total - progress;
    
    // Estimate based on category
    switch (category) {
      case AchievementCategory.examCompletion:
        return remaining; // 1 exam per day
      case AchievementCategory.streak:
        return remaining; // 1 day per streak point
      case AchievementCategory.performance:
        return remaining * 2; // 2 days per performance point
      case AchievementCategory.special:
        return remaining * 7; // 1 week per special achievement
    }
  }

  /// Get achievement rarity based on difficulty
  String getRarity() {
    switch (difficulty) {
      case AchievementDifficulty.bronze:
        return 'Common';
      case AchievementDifficulty.silver:
        return 'Uncommon';
      case AchievementDifficulty.gold:
        return 'Rare';
      case AchievementDifficulty.platinum:
        return 'Epic';
      case AchievementDifficulty.diamond:
        return 'Legendary';
    }
  }

  /// Get achievement color based on difficulty
  String getColor() {
    switch (difficulty) {
      case AchievementDifficulty.bronze:
        return '#CD7F32';
      case AchievementDifficulty.silver:
        return '#C0C0C0';
      case AchievementDifficulty.gold:
        return '#FFD700';
      case AchievementDifficulty.platinum:
        return '#E5E4E2';
      case AchievementDifficulty.diamond:
        return '#B9F2FF';
    }
  }

  /// Get next milestone progress
  int getNextMilestone() {
    final milestones = [25, 50, 75, 90, 100];
    final currentPercentage = getProgressPercentage();
    
    for (final milestone in milestones) {
      if (currentPercentage < milestone) {
        return milestone;
      }
    }
    return 100;
  }

  /// Check if achievement should show progress
  bool shouldShowProgress() {
    return !isHidden && (progress > 0 || isUnlocked);
  }

  /// Get formatted unlock date
  String? getFormattedUnlockDate() {
    if (unlockedAt == null) return null;
    
    final now = DateTime.now();
    final difference = now.difference(unlockedAt!);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${unlockedAt!.day}/${unlockedAt!.month}/${unlockedAt!.year}';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        progress,
        total,
        isUnlocked,
        unlockedAt,
        category,
        points,
        difficulty,
        requirements,
        badgeUrl,
        isHidden,
      ];

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, progress: $progress/$total, unlocked: $isUnlocked)';
  }
}

/// Enum for achievement categories
enum AchievementCategory {
  examCompletion,
  streak,
  performance,
  special,
}

/// Enum for achievement difficulty levels
enum AchievementDifficulty {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
}

/// Extension for achievement category
extension AchievementCategoryExtension on AchievementCategory {
  String get displayName {
    switch (this) {
      case AchievementCategory.examCompletion:
        return 'Exam Completion';
      case AchievementCategory.streak:
        return 'Streak';
      case AchievementCategory.performance:
        return 'Performance';
      case AchievementCategory.special:
        return 'Special';
    }
  }

  String get icon {
    switch (this) {
      case AchievementCategory.examCompletion:
        return '📚';
      case AchievementCategory.streak:
        return '🔥';
      case AchievementCategory.performance:
        return '⭐';
      case AchievementCategory.special:
        return '🏆';
    }
  }
}