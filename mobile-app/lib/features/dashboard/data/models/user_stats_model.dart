import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_stats.dart';

part 'user_stats_model.g.dart';

@JsonSerializable()
class UserStatsModel extends UserStats {
  const UserStatsModel({
    required super.totalExams,
    required super.completedToday,
    required super.currentStreak,
    required super.totalPoints,
    required super.averageScore,
    required super.totalTimeSpent,
    required super.performanceTrends,
    required super.totalCorrectAnswers,
    required super.totalQuestions,
    required super.longestStreak,
    required super.lastExamDate,
    required super.weeklyGoal,
    required super.monthlyGoal,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsModelToJson(this);

  /// Create from entity
  factory UserStatsModel.fromEntity(UserStats entity) {
    return UserStatsModel(
      totalExams: entity.totalExams,
      completedToday: entity.completedToday,
      currentStreak: entity.currentStreak,
      totalPoints: entity.totalPoints,
      averageScore: entity.averageScore,
      totalTimeSpent: entity.totalTimeSpent,
      performanceTrends: entity.performanceTrends,
      totalCorrectAnswers: entity.totalCorrectAnswers,
      totalQuestions: entity.totalQuestions,
      longestStreak: entity.longestStreak,
      lastExamDate: entity.lastExamDate,
      weeklyGoal: entity.weeklyGoal,
      monthlyGoal: entity.monthlyGoal,
    );
  }

  /// Convert to entity
  UserStats toEntity() {
    return UserStats(
      totalExams: totalExams,
      completedToday: completedToday,
      currentStreak: currentStreak,
      totalPoints: totalPoints,
      averageScore: averageScore,
      totalTimeSpent: totalTimeSpent,
      performanceTrends: performanceTrends,
      totalCorrectAnswers: totalCorrectAnswers,
      totalQuestions: totalQuestions,
      longestStreak: longestStreak,
      lastExamDate: lastExamDate,
      weeklyGoal: weeklyGoal,
      monthlyGoal: monthlyGoal,
    );
  }

  /// Create empty model
  factory UserStatsModel.empty() {
    return const UserStatsModel(
      totalExams: 0,
      completedToday: 0,
      currentStreak: 0,
      totalPoints: 0,
      averageScore: 0.0,
      totalTimeSpent: 0,
      performanceTrends: [],
      totalCorrectAnswers: 0,
      totalQuestions: 0,
      longestStreak: 0,
      lastExamDate: null,
      weeklyGoal: 5,
      monthlyGoal: 20,
    );
  }

  /// Copy with new values
  UserStatsModel copyWith({
    int? totalExams,
    int? completedToday,
    int? currentStreak,
    int? totalPoints,
    double? averageScore,
    int? totalTimeSpent,
    List<double>? performanceTrends,
    int? totalCorrectAnswers,
    int? totalQuestions,
    int? longestStreak,
    DateTime? lastExamDate,
    int? weeklyGoal,
    int? monthlyGoal,
  }) {
    return UserStatsModel(
      totalExams: totalExams ?? this.totalExams,
      completedToday: completedToday ?? this.completedToday,
      currentStreak: currentStreak ?? this.currentStreak,
      totalPoints: totalPoints ?? this.totalPoints,
      averageScore: averageScore ?? this.averageScore,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      performanceTrends: performanceTrends ?? this.performanceTrends,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      longestStreak: longestStreak ?? this.longestStreak,
      lastExamDate: lastExamDate ?? this.lastExamDate,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      monthlyGoal: monthlyGoal ?? this.monthlyGoal,
    );
  }

  /// Create sample user stats for testing
  factory UserStatsModel.sample() {
    return UserStatsModel(
      totalExams: 25,
      completedToday: 2,
      currentStreak: 7,
      totalPoints: 2550,
      averageScore: 85.5,
      totalTimeSpent: 2730, // 45 hours 30 minutes in minutes
      performanceTrends: [75.0, 78.5, 82.0, 85.5, 88.0],
      totalCorrectAnswers: 210,
      totalQuestions: 245,
      longestStreak: 15,
      lastExamDate: DateTime.now().subtract(const Duration(days: 1)),
      weeklyGoal: 5,
      monthlyGoal: 20,
    );
  }
}