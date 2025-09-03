// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardDataModel _$DashboardDataModelFromJson(Map<String, dynamic> json) =>
    DashboardDataModel(
      userStats:
          UserStatsModel.fromJson(json['userStats'] as Map<String, dynamic>),
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
          json['summary'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$DashboardDataModelToJson(DashboardDataModel instance) =>
    <String, dynamic>{
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'metadata': instance.metadata,
      'userStats': instance.userStats.toJson(),
      'achievements': instance.achievements.map((e) => e.toJson()).toList(),
      'recentActivities':
          instance.recentActivities.map((e) => e.toJson()).toList(),
      'performanceTrends':
          instance.performanceTrends.map((e) => e.toJson()).toList(),
      'summary': instance.summary.toJson(),
    };

DashboardSummaryModel _$DashboardSummaryModelFromJson(
        Map<String, dynamic> json) =>
    DashboardSummaryModel(
      totalExamsCompleted: (json['totalExamsCompleted'] as num).toInt(),
      overallAverageScore: (json['overallAverageScore'] as num).toDouble(),
      totalTimeSpentMinutes: (json['totalTimeSpentMinutes'] as num).toInt(),
      totalAchievementsUnlocked:
          (json['totalAchievementsUnlocked'] as num).toInt(),
      currentLevel: (json['currentLevel'] as num).toInt(),
      totalPointsEarned: (json['totalPointsEarned'] as num).toInt(),
      lastExamDate: json['lastExamDate'] == null
          ? null
          : DateTime.parse(json['lastExamDate'] as String),
      strongestCategory: json['strongestCategory'] as String?,
      weakestCategory: json['weakestCategory'] as String?,
      categoryBreakdown:
          Map<String, int>.from(json['categoryBreakdown'] as Map),
      monthlyProgress: (json['monthlyProgress'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$DashboardSummaryModelToJson(
        DashboardSummaryModel instance) =>
    <String, dynamic>{
      'totalExamsCompleted': instance.totalExamsCompleted,
      'overallAverageScore': instance.overallAverageScore,
      'totalTimeSpentMinutes': instance.totalTimeSpentMinutes,
      'totalAchievementsUnlocked': instance.totalAchievementsUnlocked,
      'currentLevel': instance.currentLevel,
      'totalPointsEarned': instance.totalPointsEarned,
      'lastExamDate': instance.lastExamDate?.toIso8601String(),
      'strongestCategory': instance.strongestCategory,
      'weakestCategory': instance.weakestCategory,
      'categoryBreakdown': instance.categoryBreakdown,
      'monthlyProgress': instance.monthlyProgress,
    };
