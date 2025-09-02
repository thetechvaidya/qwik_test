import 'package:equatable/equatable.dart';

/// Entity representing user performance statistics
class UserStats extends Equatable {
  final int totalExams;
  final int completedToday;
  final int currentStreak;
  final int totalPoints;
  final double averageScore;
  final int totalTimeSpent; // in minutes
  final List<double> performanceTrends; // last 7 days scores
  final int totalCorrectAnswers;
  final int totalQuestions;
  final int longestStreak;
  final DateTime? lastExamDate;
  final int weeklyGoal;
  final int monthlyGoal;

  const UserStats({
    required this.totalExams,
    required this.completedToday,
    required this.currentStreak,
    required this.totalPoints,
    required this.averageScore,
    required this.totalTimeSpent,
    required this.performanceTrends,
    required this.totalCorrectAnswers,
    required this.totalQuestions,
    required this.longestStreak,
    this.lastExamDate,
    this.weeklyGoal = 5,
    this.monthlyGoal = 20,
  });

  /// Calculate accuracy percentage
  double get accuracyPercentage {
    if (totalQuestions == 0) return 0.0;
    return (totalCorrectAnswers / totalQuestions) * 100;
  }

  /// Get streak status (active, at risk, broken)
  StreakStatus get streakStatus {
    if (lastExamDate == null) return StreakStatus.broken;
    
    final daysSinceLastExam = DateTime.now().difference(lastExamDate!).inDays;
    
    if (daysSinceLastExam == 0) return StreakStatus.active;
    if (daysSinceLastExam == 1) return StreakStatus.atRisk;
    return StreakStatus.broken;
  }

  /// Check if daily goal is met
  bool get isDailyGoalMet => completedToday >= 1;

  /// Check if weekly goal is met
  bool get isWeeklyGoalMet => totalExams >= weeklyGoal;

  /// Get performance rating based on average score
  PerformanceRating get performanceRating {
    if (averageScore >= 90) return PerformanceRating.excellent;
    if (averageScore >= 80) return PerformanceRating.good;
    if (averageScore >= 70) return PerformanceRating.average;
    if (averageScore >= 60) return PerformanceRating.belowAverage;
    return PerformanceRating.needsImprovement;
  }

  /// Get weekly progress percentage
  double get weeklyProgressPercentage {
    if (weeklyGoal == 0) return 0.0;
    return (totalExams / weeklyGoal * 100).clamp(0.0, 100.0);
  }

  /// Get monthly progress percentage
  double get monthlyProgressPercentage {
    if (monthlyGoal == 0) return 0.0;
    return (totalExams / monthlyGoal * 100).clamp(0.0, 100.0);
  }

  /// Get average time per exam in minutes
  double get averageTimePerExam {
    if (totalExams == 0) return 0.0;
    return totalTimeSpent / totalExams;
  }

  /// Get performance trend (improving, declining, stable)
  PerformanceTrend get performanceTrend {
    if (performanceTrends.length < 2) return PerformanceTrend.stable;
    
    final recent = performanceTrends.take(3).toList();
    final older = performanceTrends.skip(3).take(3).toList();
    
    if (recent.isEmpty || older.isEmpty) return PerformanceTrend.stable;
    
    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;
    
    final difference = recentAvg - olderAvg;
    
    if (difference > 5) return PerformanceTrend.improving;
    if (difference < -5) return PerformanceTrend.declining;
    return PerformanceTrend.stable;
  }

  /// Format total time spent as human readable string
  String get formattedTotalTime {
    final hours = totalTimeSpent ~/ 60;
    final minutes = totalTimeSpent % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  List<Object?> get props => [
        totalExams,
        completedToday,
        currentStreak,
        totalPoints,
        averageScore,
        totalTimeSpent,
        performanceTrends,
        totalCorrectAnswers,
        totalQuestions,
        longestStreak,
        lastExamDate,
        weeklyGoal,
        monthlyGoal,
      ];

  @override
  String toString() {
    return 'UserStats(totalExams: $totalExams, currentStreak: $currentStreak, averageScore: $averageScore)';
  }
}

/// Enum for streak status
enum StreakStatus {
  active,
  atRisk,
  broken,
}

/// Enum for performance rating
enum PerformanceRating {
  excellent,
  good,
  average,
  belowAverage,
  needsImprovement,
}

/// Enum for performance trend
enum PerformanceTrend {
  improving,
  declining,
  stable,
}