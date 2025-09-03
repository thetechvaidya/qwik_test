import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/performance_trend.dart';
import '../../domain/entities/recent_activity.dart';
import '../../domain/entities/user_stats.dart';
import 'achievement_model.dart';
import 'performance_trend_model.dart';
import 'recent_activity_model.dart';
import 'user_stats_model.dart';

part 'dashboard_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DashboardDataModel extends DashboardData {
  @override
  final UserStatsModel userStats;
  @override
  final List<AchievementModel> achievements;
  @override
  final List<RecentActivityModel> recentActivities;
  @override
  final List<PerformanceTrendModel> performanceTrends;
  @override
  final DashboardSummaryModel summary;

  const DashboardDataModel({
    required this.userStats,
    required this.achievements,
    required this.recentActivities,
    required this.performanceTrends,
    required this.summary,
    required super.lastUpdated,
    super.metadata = const {},
  }) : super(
          userStats: userStats,
          achievements: achievements,
          recentActivities: recentActivities,
          performanceTrends: performanceTrends,
          summary: summary,
        );

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDataModelToJson(this);

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
  @override
  DashboardData toEntity() {
    return DashboardData(
      userStats: userStats.toEntity(),
      achievements: achievements.map((e) => e.toEntity()).toList(),
      recentActivities: recentActivities.map((e) => e.toEntity()).toList(),
      performanceTrends: performanceTrends.map((e) => e.toEntity()).toList(),
      summary: summary.toEntity(),
      lastUpdated: lastUpdated,
      metadata: metadata,
    );
  }

  /// Copy with new values
  @override
  DashboardDataModel copyWith({
    UserStats? userStats,
    List<Achievement>? achievements,
    List<RecentActivity>? recentActivities,
    List<PerformanceTrend>? performanceTrends,
    DashboardSummary? summary,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
  }) {
    return DashboardDataModel(
      userStats: userStats == null
          ? this.userStats
          : (userStats is UserStatsModel
              ? userStats
              : UserStatsModel.fromEntity(userStats)),
      achievements: achievements == null
          ? this.achievements
          : achievements
              .map<AchievementModel>((e) =>
                  e is AchievementModel ? e : AchievementModel.fromEntity(e))
              .toList(),
      recentActivities: recentActivities == null
          ? this.recentActivities
          : recentActivities
              .map<RecentActivityModel>((e) => e is RecentActivityModel
                  ? e
                  : RecentActivityModel.fromEntity(e))
              .toList(),
      performanceTrends: performanceTrends == null
          ? this.performanceTrends
          : performanceTrends
              .map<PerformanceTrendModel>((e) => e is PerformanceTrendModel
                  ? e
                  : PerformanceTrendModel.fromEntity(e))
              .toList(),
      summary: summary == null
          ? this.summary
          : (summary is DashboardSummaryModel
              ? summary
              : DashboardSummaryModel.fromEntity(summary)),
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
    required super.overallAverageScore,
    required super.totalTimeSpentMinutes,
    required super.totalAchievementsUnlocked,
    required super.currentLevel,
    required super.totalPointsEarned,
    super.lastExamDate,
    super.strongestCategory,
    super.weakestCategory,
    required super.categoryBreakdown,
    required super.monthlyProgress,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalExamsCompleted: json['totalExamsCompleted'] as int? ?? 0,
      overallAverageScore: (json['overallAverageScore'] as num?)?.toDouble() ?? 0.0,
      totalTimeSpentMinutes: json['totalTimeSpentMinutes'] as int? ?? 0,
      totalAchievementsUnlocked: json['totalAchievementsUnlocked'] as int? ?? 0,
      currentLevel: json['currentLevel'] as int? ?? 1,
      totalPointsEarned: json['totalPointsEarned'] as int? ?? 0,
      lastExamDate: json['lastExamDate'] != null
          ? DateTime.parse(json['lastExamDate'] as String)
          : null,
      strongestCategory: json['strongestCategory'] as String?,
      weakestCategory: json['weakestCategory'] as String?,
      categoryBreakdown: Map<String, int>.from(
        json['categoryBreakdown'] as Map<String, dynamic>? ?? {},
      ),
      monthlyProgress: Map<String, double>.from(
        (json['monthlyProgress'] as Map<String, dynamic>? ?? {})
            .map((key, value) => MapEntry(key, (value as num).toDouble())),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalExamsCompleted': totalExamsCompleted,
      'overallAverageScore': overallAverageScore,
      'totalTimeSpentMinutes': totalTimeSpentMinutes,
      'totalAchievementsUnlocked': totalAchievementsUnlocked,
      'currentLevel': currentLevel,
      'totalPointsEarned': totalPointsEarned,
      'lastExamDate': lastExamDate?.toIso8601String(),
      'strongestCategory': strongestCategory,
      'weakestCategory': weakestCategory,
      'categoryBreakdown': categoryBreakdown,
      'monthlyProgress': monthlyProgress,
    };
  }

  /// Create from entity
  factory DashboardSummaryModel.fromEntity(DashboardSummary entity) {
    return DashboardSummaryModel(
      totalExamsCompleted: entity.totalExamsCompleted,
      overallAverageScore: entity.overallAverageScore,
      totalTimeSpentMinutes: entity.totalTimeSpentMinutes,
      totalAchievementsUnlocked: entity.totalAchievementsUnlocked,
      currentLevel: entity.currentLevel,
      totalPointsEarned: entity.totalPointsEarned,
      lastExamDate: entity.lastExamDate,
      strongestCategory: entity.strongestCategory,
      weakestCategory: entity.weakestCategory,
      categoryBreakdown: entity.categoryBreakdown,
      monthlyProgress: entity.monthlyProgress,
    );
  }

  /// Convert to entity
  DashboardSummary toEntity() {
    return DashboardSummary(
      totalExamsCompleted: totalExamsCompleted,
      overallAverageScore: overallAverageScore,
      totalTimeSpentMinutes: totalTimeSpentMinutes,
      totalAchievementsUnlocked: totalAchievementsUnlocked,
      currentLevel: currentLevel,
      totalPointsEarned: totalPointsEarned,
      lastExamDate: lastExamDate,
      strongestCategory: strongestCategory,
      weakestCategory: weakestCategory,
      categoryBreakdown: categoryBreakdown,
      monthlyProgress: monthlyProgress,
    );
  }

  /// Copy with new values
  DashboardSummaryModel copyWith({
    int? totalExamsCompleted,
    double? overallAverageScore,
    int? totalTimeSpentMinutes,
    int? totalAchievementsUnlocked,
    int? currentLevel,
    int? totalPointsEarned,
    DateTime? lastExamDate,
    String? strongestCategory,
    String? weakestCategory,
    Map<String, int>? categoryBreakdown,
    Map<String, double>? monthlyProgress,
  }) {
    return DashboardSummaryModel(
      totalExamsCompleted: totalExamsCompleted ?? this.totalExamsCompleted,
      overallAverageScore: overallAverageScore ?? this.overallAverageScore,
      totalTimeSpentMinutes: totalTimeSpentMinutes ?? this.totalTimeSpentMinutes,
      totalAchievementsUnlocked: totalAchievementsUnlocked ?? this.totalAchievementsUnlocked,
      currentLevel: currentLevel ?? this.currentLevel,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      lastExamDate: lastExamDate ?? this.lastExamDate,
      strongestCategory: strongestCategory ?? this.strongestCategory,
      weakestCategory: weakestCategory ?? this.weakestCategory,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      monthlyProgress: monthlyProgress ?? this.monthlyProgress,
    );
  }

  /// Create empty summary
  factory DashboardSummaryModel.empty() {
    return const DashboardSummaryModel(
      totalExamsCompleted: 0,
      overallAverageScore: 0.0,
      totalTimeSpentMinutes: 0,
      totalAchievementsUnlocked: 0,
      currentLevel: 1,
      totalPointsEarned: 0,
      categoryBreakdown: {},
      monthlyProgress: {},
    );
  }

  /// Create sample summary for testing
  factory DashboardSummaryModel.sample() {
    return DashboardSummaryModel(
      totalExamsCompleted: 45,
      overallAverageScore: 82.5,
      totalTimeSpentMinutes: 4050, // 67.5 hours
      totalAchievementsUnlocked: 18,
      currentLevel: 5,
      totalPointsEarned: 2250,
      lastExamDate: DateTime.now().subtract(const Duration(days: 1)),
      strongestCategory: 'Mathematics',
      weakestCategory: 'Science',
      categoryBreakdown: {
        'Mathematics': 85,
        'English': 80,
        'Science': 75,
        'History': 88,
      },
      monthlyProgress: {
        'January': 78.5,
        'February': 82.0,
        'March': 85.2,
      },
    );
  }

  @override
  String toString() {
    return 'DashboardSummaryModel(totalExams: $totalExamsCompleted, avgScore: $overallAverageScore, level: $currentLevel)';
  }
}