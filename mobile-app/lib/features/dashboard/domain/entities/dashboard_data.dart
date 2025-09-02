import 'package:equatable/equatable.dart';
import 'user_stats.dart';
import 'achievement.dart';
import 'recent_activity.dart';
import 'performance_trend.dart';

/// Main dashboard entity that aggregates all dashboard-related data
class DashboardData extends Equatable {
  final UserStats userStats;
  final List<Achievement> achievements;
  final List<RecentActivity> recentActivities;
  final List<PerformanceTrend> performanceTrends;
  final DashboardSummary summary;
  final DateTime lastUpdated;
  final Map<String, dynamic> metadata;

  const DashboardData({
    required this.userStats,
    required this.achievements,
    required this.recentActivities,
    required this.performanceTrends,
    required this.summary,
    required this.lastUpdated,
    required this.metadata,
  });

  /// Get unlocked achievements
  List<Achievement> getUnlockedAchievements() {
    return achievements.where((achievement) => achievement.isUnlocked).toList();
  }

  /// Get locked achievements
  List<Achievement> getLockedAchievements() {
    return achievements.where((achievement) => !achievement.isUnlocked).toList();
  }

  /// Get achievements by category
  List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    return achievements.where((achievement) => achievement.category == category).toList();
  }

  /// Get recent activities (last 7 days)
  List<RecentActivity> getRecentActivities({int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return recentActivities
        .where((activity) => activity.completedAt.isAfter(cutoffDate))
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  /// Get activities by type
  List<RecentActivity> getActivitiesByType(ActivityType type) {
    return recentActivities.where((activity) => activity.type == type).toList();
  }

  /// Get performance trends for a specific period
  List<PerformanceTrend> getTrendsForPeriod(TrendPeriod period) {
    return performanceTrends
        .where((trend) => trend.period == period)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get latest performance trend
  PerformanceTrend? getLatestTrend() {
    if (performanceTrends.isEmpty) return null;
    return performanceTrends.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }

  /// Get performance trend for category
  List<PerformanceTrend> getTrendsForCategory(String category) {
    return performanceTrends
        .where((trend) => trend.category == category)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Calculate total points earned
  int getTotalPointsEarned() {
    return getUnlockedAchievements()
        .fold(0, (total, achievement) => total + achievement.points);
  }

  /// Get achievement completion percentage
  double getAchievementCompletionPercentage() {
    if (achievements.isEmpty) return 0.0;
    final unlockedCount = getUnlockedAchievements().length;
    return (unlockedCount / achievements.length * 100).clamp(0.0, 100.0);
  }

  /// Get next achievement to unlock
  Achievement? getNextAchievement() {
    final lockedAchievements = getLockedAchievements()
      ..sort((a, b) => b.getProgressPercentage().compareTo(a.getProgressPercentage()));
    
    return lockedAchievements.isNotEmpty ? lockedAchievements.first : null;
  }

  /// Check if user is on a streak
  bool isOnStreak() {
    return userStats.currentStreak > 0;
  }

  /// Get streak status message
  String getStreakStatusMessage() {
    if (userStats.currentStreak == 0) {
      return 'Start your learning streak today!';
    } else if (userStats.currentStreak == 1) {
      return 'Great start! Keep the momentum going.';
    } else if (userStats.currentStreak < 7) {
      return '${userStats.currentStreak} day streak! You\'re doing great.';
    } else if (userStats.currentStreak < 30) {
      return 'Amazing ${userStats.currentStreak} day streak! Keep it up!';
    } else {
      return 'Incredible ${userStats.currentStreak} day streak! You\'re unstoppable!';
    }
  }

  /// Get performance insights
  List<String> getPerformanceInsights() {
    final insights = <String>[];
    
    // Recent performance
    final latestTrend = getLatestTrend();
    if (latestTrend != null) {
      if (latestTrend.score >= 90) {
        insights.add('Excellent recent performance! Keep up the great work.');
      } else if (latestTrend.score < 70) {
        insights.add('Consider reviewing recent topics to improve performance.');
      }
    }
    
    // Streak insights
    if (userStats.currentStreak >= 7) {
      insights.add('Your consistency is paying off with a ${userStats.currentStreak}-day streak!');
    } else if (userStats.currentStreak == 0) {
      insights.add('Start a learning streak to build momentum.');
    }
    
    // Achievement insights
    final nextAchievement = getNextAchievement();
    if (nextAchievement != null && nextAchievement.getProgressPercentage() > 50) {
      insights.add('You\'re ${nextAchievement.getProgressPercentage().toStringAsFixed(0)}% towards "${nextAchievement.title}"!');
    }
    
    // Activity insights
    final recentActivities = getRecentActivities(days: 7);
    if (recentActivities.length >= 5) {
      insights.add('High activity this week with ${recentActivities.length} completed activities.');
    } else if (recentActivities.isEmpty) {
      insights.add('No recent activity. Consider taking an exam to get back on track.');
    }
    
    return insights;
  }

  /// Check if dashboard needs refresh
  bool needsRefresh({Duration maxAge = const Duration(minutes: 30)}) {
    return DateTime.now().difference(lastUpdated) > maxAge;
  }

  /// Get dashboard health score (0-100)
  int getDashboardHealthScore() {
    int score = 0;
    
    // Performance score (40 points)
    score += (userStats.averageScore * 0.4).round();
    
    // Streak score (20 points)
    if (userStats.currentStreak > 0) {
      score += (userStats.currentStreak.clamp(0, 20));
    }
    
    // Achievement score (20 points)
    final achievementPercentage = getAchievementCompletionPercentage();
    score += (achievementPercentage * 0.2).round();
    
    // Activity score (20 points)
    final recentActivities = getRecentActivities(days: 7);
    score += (recentActivities.length.clamp(0, 20));
    
    return score.clamp(0, 100);
  }

  @override
  List<Object?> get props => [
        userStats,
        achievements,
        recentActivities,
        performanceTrends,
        summary,
        lastUpdated,
        metadata,
      ];

  @override
  String toString() {
    return 'DashboardData(userStats: $userStats, achievements: ${achievements.length}, activities: ${recentActivities.length})';
  }
}

/// Summary statistics for the dashboard
class DashboardSummary extends Equatable {
  final int totalExamsCompleted;
  final double overallAverageScore;
  final int totalTimeSpentMinutes;
  final int totalAchievementsUnlocked;
  final int currentLevel;
  final int totalPointsEarned;
  final DateTime? lastExamDate;
  final String? strongestCategory;
  final String? weakestCategory;
  final Map<String, int> categoryBreakdown;
  final Map<String, double> monthlyProgress;

  const DashboardSummary({
    required this.totalExamsCompleted,
    required this.overallAverageScore,
    required this.totalTimeSpentMinutes,
    required this.totalAchievementsUnlocked,
    required this.currentLevel,
    required this.totalPointsEarned,
    this.lastExamDate,
    this.strongestCategory,
    this.weakestCategory,
    required this.categoryBreakdown,
    required this.monthlyProgress,
  });

  /// Get formatted total time spent
  String getFormattedTotalTime() {
    final hours = totalTimeSpentMinutes ~/ 60;
    final minutes = totalTimeSpentMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get level progress percentage
  double getLevelProgress() {
    // Assuming each level requires 1000 points
    const pointsPerLevel = 1000;
    final currentLevelPoints = totalPointsEarned % pointsPerLevel;
    return (currentLevelPoints / pointsPerLevel * 100).clamp(0.0, 100.0);
  }

  /// Get points needed for next level
  int getPointsToNextLevel() {
    const pointsPerLevel = 1000;
    final currentLevelPoints = totalPointsEarned % pointsPerLevel;
    return pointsPerLevel - currentLevelPoints;
  }

  /// Get days since last exam
  int? getDaysSinceLastExam() {
    if (lastExamDate == null) return null;
    return DateTime.now().difference(lastExamDate!).inDays;
  }

  /// Check if user is active (exam within last 7 days)
  bool isActiveUser() {
    final daysSince = getDaysSinceLastExam();
    return daysSince != null && daysSince <= 7;
  }

  /// Get performance rating
  PerformanceRating getOverallPerformanceRating() {
    if (overallAverageScore >= 90) return PerformanceRating.excellent;
    if (overallAverageScore >= 80) return PerformanceRating.good;
    if (overallAverageScore >= 70) return PerformanceRating.average;
    if (overallAverageScore >= 60) return PerformanceRating.belowAverage;
    return PerformanceRating.poor;
  }

  @override
  List<Object?> get props => [
        totalExamsCompleted,
        overallAverageScore,
        totalTimeSpentMinutes,
        totalAchievementsUnlocked,
        currentLevel,
        totalPointsEarned,
        lastExamDate,
        strongestCategory,
        weakestCategory,
        categoryBreakdown,
        monthlyProgress,
      ];

  @override
  String toString() {
    return 'DashboardSummary(exams: $totalExamsCompleted, avgScore: $overallAverageScore, level: $currentLevel)';
  }
}