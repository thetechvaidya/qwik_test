import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_stats.dart';

part 'user_stats_model.g.dart';

@JsonSerializable()
class UserStatsModel extends UserStats {
  const UserStatsModel({
    required super.totalExams,
    required super.averageScore,
    required super.currentStreak,
    required super.longestStreak,
    required super.totalTimeSpent,
    required super.performanceTrends,
    required super.lastExamDate,
    required super.totalPointsEarned,
    required super.currentLevel,
    required super.examsByCategory,
    required super.weeklyGoal,
    required super.monthlyGoal,
    required super.achievementsUnlocked,
    required super.favoriteCategories,
    required super.weakAreas,
    required super.strongAreas,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalExams: json['totalExams'] as int? ?? 0,
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      totalTimeSpent: Duration(
        minutes: json['totalTimeSpentMinutes'] as int? ?? 0,
      ),
      performanceTrends: (json['performanceTrends'] as List<dynamic>?)?
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      lastExamDate: json['lastExamDate'] != null
          ? DateTime.parse(json['lastExamDate'] as String)
          : null,
      totalPointsEarned: json['totalPointsEarned'] as int? ?? 0,
      currentLevel: json['currentLevel'] as int? ?? 1,
      examsByCategory: Map<String, int>.from(
        json['examsByCategory'] as Map<String, dynamic>? ?? {},
      ),
      weeklyGoal: json['weeklyGoal'] as int? ?? 5,
      monthlyGoal: json['monthlyGoal'] as int? ?? 20,
      achievementsUnlocked: json['achievementsUnlocked'] as int? ?? 0,
      favoriteCategories: (json['favoriteCategories'] as List<dynamic>?)?
              ?.map((e) => e as String)
              .toList() ??
          [],
      weakAreas: (json['weakAreas'] as List<dynamic>?)?
              ?.map((e) => e as String)
              .toList() ??
          [],
      strongAreas: (json['strongAreas'] as List<dynamic>?)?
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalExams': totalExams,
      'averageScore': averageScore,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalTimeSpentMinutes': totalTimeSpent.inMinutes,
      'performanceTrends': performanceTrends,
      'lastExamDate': lastExamDate?.toIso8601String(),
      'totalPointsEarned': totalPointsEarned,
      'currentLevel': currentLevel,
      'examsByCategory': examsByCategory,
      'weeklyGoal': weeklyGoal,
      'monthlyGoal': monthlyGoal,
      'achievementsUnlocked': achievementsUnlocked,
      'favoriteCategories': favoriteCategories,
      'weakAreas': weakAreas,
      'strongAreas': strongAreas,
    };
  }

  /// Create from entity
  factory UserStatsModel.fromEntity(UserStats entity) {
    return UserStatsModel(
      totalExams: entity.totalExams,
      averageScore: entity.averageScore,
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      totalTimeSpent: entity.totalTimeSpent,
      performanceTrends: entity.performanceTrends,
      lastExamDate: entity.lastExamDate,
      totalPointsEarned: entity.totalPointsEarned,
      currentLevel: entity.currentLevel,
      examsByCategory: entity.examsByCategory,
      weeklyGoal: entity.weeklyGoal,
      monthlyGoal: entity.monthlyGoal,
      achievementsUnlocked: entity.achievementsUnlocked,
      favoriteCategories: entity.favoriteCategories,
      weakAreas: entity.weakAreas,
      strongAreas: entity.strongAreas,
    );
  }

  /// Convert to entity
  UserStats toEntity() {
    return UserStats(
      totalExams: totalExams,
      averageScore: averageScore,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalTimeSpent: totalTimeSpent,
      performanceTrends: performanceTrends,
      lastExamDate: lastExamDate,
      totalPointsEarned: totalPointsEarned,
      currentLevel: currentLevel,
      examsByCategory: examsByCategory,
      weeklyGoal: weeklyGoal,
      monthlyGoal: monthlyGoal,
      achievementsUnlocked: achievementsUnlocked,
      favoriteCategories: favoriteCategories,
      weakAreas: weakAreas,
      strongAreas: strongAreas,
    );
  }

  /// Create empty model
  factory UserStatsModel.empty() {
    return const UserStatsModel(
      totalExams: 0,
      averageScore: 0.0,
      currentStreak: 0,
      longestStreak: 0,
      totalTimeSpent: Duration.zero,
      performanceTrends: [],
      lastExamDate: null,
      totalPointsEarned: 0,
      currentLevel: 1,
      examsByCategory: {},
      weeklyGoal: 5,
      monthlyGoal: 20,
      achievementsUnlocked: 0,
      favoriteCategories: [],
      weakAreas: [],
      strongAreas: [],
    );
  }

  /// Copy with new values
  UserStatsModel copyWith({
    int? totalExams,
    double? averageScore,
    int? currentStreak,
    int? longestStreak,
    Duration? totalTimeSpent,
    List<double>? performanceTrends,
    DateTime? lastExamDate,
    int? totalPointsEarned,
    int? currentLevel,
    Map<String, int>? examsByCategory,
    int? weeklyGoal,
    int? monthlyGoal,
    int? achievementsUnlocked,
    List<String>? favoriteCategories,
    List<String>? weakAreas,
    List<String>? strongAreas,
  }) {
    return UserStatsModel(
      totalExams: totalExams ?? this.totalExams,
      averageScore: averageScore ?? this.averageScore,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      performanceTrends: performanceTrends ?? this.performanceTrends,
      lastExamDate: lastExamDate ?? this.lastExamDate,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      currentLevel: currentLevel ?? this.currentLevel,
      examsByCategory: examsByCategory ?? this.examsByCategory,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      monthlyGoal: monthlyGoal ?? this.monthlyGoal,
      achievementsUnlocked: achievementsUnlocked ?? this.achievementsUnlocked,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      weakAreas: weakAreas ?? this.weakAreas,
      strongAreas: strongAreas ?? this.strongAreas,
    );
  }

  @override
  String toString() {
    return 'UserStatsModel(totalExams: $totalExams, averageScore: $averageScore, currentStreak: $currentStreak)';
  }
}