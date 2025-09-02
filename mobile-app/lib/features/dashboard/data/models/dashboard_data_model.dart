import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/dashboard_data.dart';
import 'user_stats_model.dart';
import 'achievement_model.dart';
import 'recent_activity_model.dart';
import 'performance_trend_model.dart';

part 'dashboard_data_model.g.dart';

@JsonSerializable()
class DashboardDataModel extends DashboardData {
  const DashboardDataModel({
    required super.userStats,
    required super.achievements,
    required super.recentActivities,
    required super.performanceTrends,
    required super.summary,
    required super.lastUpdated,
    super.metadata,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      userStats: UserStatsModel.fromJson(
        json['userStats'] as Map<String, dynamic>,
      ),
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentActivities: (json['recentActivities'] as List<dynamic>)
          .map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      performanceTrends: (json['performanceTrends'] as List<dynamic>)
          .map((e) => PerformanceTrendModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: DashboardSummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      metadata: Map<String, dynamic>.from(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userStats': (userStats as UserStatsModel).toJson(),
      'achievements': achievements
          .map((e) => (e as AchievementModel).toJson())
          .toList(),
      'recentActivities': recentActivities
          .map((e) => (e as RecentActivityModel).toJson())
          .toList(),
      'performanceTrends': performanceTrends
          .map((e) => (e as PerformanceTrendModel).toJson())
          .toList(),
      'summary': (summary as DashboardSummaryModel).toJson(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create from entity
  factory DashboardDataModel.fromEntity(DashboardData entity) {
    return DashboardDataModel(
      userStats: UserStatsModel.fromEntity(entity.userStats),
      achievements: entity.achievements
          .map((e) => AchievementModel.fromEntity(e))
          .toList(),
      recentActivities: entity.recentActivities
          .map((e) => RecentActivityModel.fromEntity(e))
          .toList(),
      performanceTrends: entity.performanceTrends
          .map((e) => PerformanceTrendModel.fromEntity(e))
          .toList(),
      summary: DashboardSummaryModel.fromEntity(entity.summary),
      lastUpdated: entity.lastUpdated,
      metadata: entity.metadata,
    );
  }

  /// Convert to entity
  DashboardData toEntity() {
    return DashboardData(
      userStats: userStats,
      achievements: achievements,
      recentActivities: recentActivities,
      performanceTrends: performanceTrends,
      summary: summary,
      lastUpdated: lastUpdated,
      metadata: metadata,
    );
  }

  /// Copy with new values
  DashboardDataModel copyWith({
    UserStatsModel? userStats,
    List<AchievementModel>? achievements,
    List<RecentActivityModel>? recentActivities,
    List<PerformanceTrendModel>? performanceTrends,
    DashboardSummaryModel? summary,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
  }) {
    return DashboardDataModel(
      userStats: userStats ?? this.userStats as UserStatsModel,
      achievements: achievements ?? this.achievements.cast<AchievementModel>(),
      recentActivities: recentActivities ?? this.recentActivities.cast<RecentActivityModel>(),
      performanceTrends: performanceTrends ?? this.performanceTrends.cast<PerformanceTrendModel>(),
      summary: summary ?? this.summary as DashboardSummaryModel,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create empty dashboard data
  factory DashboardDataModel.empty() {
    return DashboardDataModel(
      userStats: UserStatsModel.empty(),
      achievements: [],
      recentActivities: [],
      performanceTrends: [],
      summary: DashboardSummaryModel.empty(),
      lastUpdated: DateTime.now(),
      metadata: {},
    );
  }

  /// Create sample dashboard data for testing
  factory DashboardDataModel.sample() {
    return DashboardDataModel(
      userStats: UserStatsModel.sample(),
      achievements: AchievementModel.getSampleAchievements(),
      recentActivities: RecentActivityModel.getSampleActivities(),
      performanceTrends: PerformanceTrendModel.getSampleTrends(),
      summary: DashboardSummaryModel.sample(),
      lastUpdated: DateTime.now(),
      metadata: {
        'version': '1.0.0',
        'source': 'sample_data',
        'generatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  String toString() {
    return 'DashboardDataModel(userStats: $userStats, achievements: ${achievements.length}, recentActivities: ${recentActivities.length}, performanceTrends: ${performanceTrends.length})';
  }
}

@JsonSerializable()
class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.totalExamsCompleted,
    required super.averageScore,
    required super.totalTimeSpent,
    required super.currentStreak,
    required super.longestStreak,
    required super.totalAchievements,
    required super.unlockedAchievements,
    required super.weeklyGoalProgress,
    required super.monthlyGoalProgress,
    required super.performanceRating,
    required super.improvementAreas,
    required super.strengths,
    super.lastExamDate,
    super.nextMilestone,
    super.studyRecommendations,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalExamsCompleted: json['totalExamsCompleted'] as int,
      averageScore: (json['averageScore'] as num).toDouble(),
      totalTimeSpent: Duration(
        minutes: json['totalTimeSpentMinutes'] as int,
      ),
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      totalAchievements: json['totalAchievements'] as int,
      unlockedAchievements: json['unlockedAchievements'] as int,
      weeklyGoalProgress: (json['weeklyGoalProgress'] as num).toDouble(),
      monthlyGoalProgress: (json['monthlyGoalProgress'] as num).toDouble(),
      performanceRating: PerformanceRating.values.firstWhere(
        (e) => e.name == json['performanceRating'],
        orElse: () => PerformanceRating.average,
      ),
      improvementAreas: (json['improvementAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      strengths: (json['strengths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastExamDate: json['lastExamDate'] != null
          ? DateTime.parse(json['lastExamDate'] as String)
          : null,
      nextMilestone: json['nextMilestone'] as String?,
      studyRecommendations: (json['studyRecommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalExamsCompleted': totalExamsCompleted,
      'averageScore': averageScore,
      'totalTimeSpentMinutes': totalTimeSpent.inMinutes,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalAchievements': totalAchievements,
      'unlockedAchievements': unlockedAchievements,
      'weeklyGoalProgress': weeklyGoalProgress,
      'monthlyGoalProgress': monthlyGoalProgress,
      'performanceRating': performanceRating.name,
      'improvementAreas': improvementAreas,
      'strengths': strengths,
      'lastExamDate': lastExamDate?.toIso8601String(),
      'nextMilestone': nextMilestone,
      'studyRecommendations': studyRecommendations,
    };
  }

  /// Create from entity
  factory DashboardSummaryModel.fromEntity(DashboardSummary entity) {
    return DashboardSummaryModel(
      totalExamsCompleted: entity.totalExamsCompleted,
      averageScore: entity.averageScore,
      totalTimeSpent: entity.totalTimeSpent,
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      totalAchievements: entity.totalAchievements,
      unlockedAchievements: entity.unlockedAchievements,
      weeklyGoalProgress: entity.weeklyGoalProgress,
      monthlyGoalProgress: entity.monthlyGoalProgress,
      performanceRating: entity.performanceRating,
      improvementAreas: entity.improvementAreas,
      strengths: entity.strengths,
      lastExamDate: entity.lastExamDate,
      nextMilestone: entity.nextMilestone,
      studyRecommendations: entity.studyRecommendations,
    );
  }

  /// Convert to entity
  DashboardSummary toEntity() {
    return DashboardSummary(
      totalExamsCompleted: totalExamsCompleted,
      averageScore: averageScore,
      totalTimeSpent: totalTimeSpent,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalAchievements: totalAchievements,
      unlockedAchievements: unlockedAchievements,
      weeklyGoalProgress: weeklyGoalProgress,
      monthlyGoalProgress: monthlyGoalProgress,
      performanceRating: performanceRating,
      improvementAreas: improvementAreas,
      strengths: strengths,
      lastExamDate: lastExamDate,
      nextMilestone: nextMilestone,
      studyRecommendations: studyRecommendations,
    );
  }

  /// Copy with new values
  DashboardSummaryModel copyWith({
    int? totalExamsCompleted,
    double? averageScore,
    Duration? totalTimeSpent,
    int? currentStreak,
    int? longestStreak,
    int? totalAchievements,
    int? unlockedAchievements,
    double? weeklyGoalProgress,
    double? monthlyGoalProgress,
    PerformanceRating? performanceRating,
    List<String>? improvementAreas,
    List<String>? strengths,
    DateTime? lastExamDate,
    String? nextMilestone,
    List<String>? studyRecommendations,
  }) {
    return DashboardSummaryModel(
      totalExamsCompleted: totalExamsCompleted ?? this.totalExamsCompleted,
      averageScore: averageScore ?? this.averageScore,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalAchievements: totalAchievements ?? this.totalAchievements,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      weeklyGoalProgress: weeklyGoalProgress ?? this.weeklyGoalProgress,
      monthlyGoalProgress: monthlyGoalProgress ?? this.monthlyGoalProgress,
      performanceRating: performanceRating ?? this.performanceRating,
      improvementAreas: improvementAreas ?? this.improvementAreas,
      strengths: strengths ?? this.strengths,
      lastExamDate: lastExamDate ?? this.lastExamDate,
      nextMilestone: nextMilestone ?? this.nextMilestone,
      studyRecommendations: studyRecommendations ?? this.studyRecommendations,
    );
  }

  /// Create empty summary
  factory DashboardSummaryModel.empty() {
    return const DashboardSummaryModel(
      totalExamsCompleted: 0,
      averageScore: 0.0,
      totalTimeSpent: Duration.zero,
      currentStreak: 0,
      longestStreak: 0,
      totalAchievements: 0,
      unlockedAchievements: 0,
      weeklyGoalProgress: 0.0,
      monthlyGoalProgress: 0.0,
      performanceRating: PerformanceRating.beginner,
      improvementAreas: [],
      strengths: [],
    );
  }

  /// Create sample summary for testing
  factory DashboardSummaryModel.sample() {
    return DashboardSummaryModel(
      totalExamsCompleted: 45,
      averageScore: 82.5,
      totalTimeSpent: const Duration(hours: 67, minutes: 30),
      currentStreak: 7,
      longestStreak: 12,
      totalAchievements: 25,
      unlockedAchievements: 18,
      weeklyGoalProgress: 0.75,
      monthlyGoalProgress: 0.60,
      performanceRating: PerformanceRating.good,
      improvementAreas: ['Time Management', 'Advanced Mathematics'],
      strengths: ['Basic Concepts', 'Problem Solving', 'Consistency'],
      lastExamDate: DateTime.now().subtract(const Duration(days: 1)),
      nextMilestone: 'Complete 50 exams',
      studyRecommendations: [
        'Focus on time management techniques',
        'Practice advanced math problems daily',
        'Review weak topics from recent exams',
      ],
    );
  }

  @override
  String toString() {
    return 'DashboardSummaryModel(totalExams: $totalExamsCompleted, avgScore: $averageScore, streak: $currentStreak)';
  }
}