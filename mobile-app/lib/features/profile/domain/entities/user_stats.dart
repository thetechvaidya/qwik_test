import 'package:equatable/equatable.dart';

class UserStats extends Equatable {
  const UserStats({
    this.totalExamsTaken = 0,
    this.totalPoints = 0,
    this.averageScore = 0.0,
    this.rank = 0,
    this.streakDays = 0,
    this.certificatesEarned = 0,
    this.studyHours = 0,
    this.correctAnswers = 0,
    this.totalQuestions = 0,
  });

  final int totalExamsTaken;
  final int totalPoints;
  final double averageScore;
  final int rank;
  final int streakDays;
  final int certificatesEarned;
  final int studyHours;
  final int correctAnswers;
  final int totalQuestions;

  @override
  List<Object?> get props => [
        totalExamsTaken,
        totalPoints,
        averageScore,
        rank,
        streakDays,
        certificatesEarned,
        studyHours,
        correctAnswers,
        totalQuestions,
      ];

  /// Calculates accuracy percentage
  double getAccuracyPercentage() {
    if (totalQuestions == 0) return 0.0;
    return (correctAnswers / totalQuestions) * 100;
  }

  /// Returns performance rating based on average score
  String getPerformanceRating() {
    if (averageScore >= 90) return 'Excellent';
    if (averageScore >= 80) return 'Good';
    if (averageScore >= 70) return 'Average';
    if (averageScore >= 60) return 'Below Average';
    return 'Needs Improvement';
  }

  /// Checks if user has a current streak
  bool hasActiveStreak() {
    return streakDays > 0;
  }

  /// Returns streak status message
  String getStreakStatus() {
    if (streakDays == 0) return 'No active streak';
    if (streakDays == 1) return '1 day streak';
    return '$streakDays days streak';
  }

  /// Calculates progress towards next achievement level
  double getProgressToNextLevel() {
    const pointsPerLevel = 1000;
    final currentLevelPoints = totalPoints % pointsPerLevel;
    return currentLevelPoints / pointsPerLevel;
  }

  /// Gets current level based on total points
  int getCurrentLevel() {
    const pointsPerLevel = 1000;
    return (totalPoints / pointsPerLevel).floor() + 1;
  }

  UserStats copyWith({
    int? totalExamsTaken,
    int? totalPoints,
    double? averageScore,
    int? rank,
    int? streakDays,
    int? certificatesEarned,
    int? studyHours,
    int? correctAnswers,
    int? totalQuestions,
  }) {
    return UserStats(
      totalExamsTaken: totalExamsTaken ?? this.totalExamsTaken,
      totalPoints: totalPoints ?? this.totalPoints,
      averageScore: averageScore ?? this.averageScore,
      rank: rank ?? this.rank,
      streakDays: streakDays ?? this.streakDays,
      certificatesEarned: certificatesEarned ?? this.certificatesEarned,
      studyHours: studyHours ?? this.studyHours,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }

  @override
  String toString() {
    return 'UserStats(totalExamsTaken: $totalExamsTaken, totalPoints: $totalPoints, averageScore: $averageScore, rank: $rank, streakDays: $streakDays, certificatesEarned: $certificatesEarned, studyHours: $studyHours, correctAnswers: $correctAnswers, totalQuestions: $totalQuestions)';
  }
}