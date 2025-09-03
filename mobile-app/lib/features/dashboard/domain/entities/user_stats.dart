import 'package:equatable/equatable.dart';

import 'performance_trend.dart';

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
    return PerformanceRating.poor;
  }