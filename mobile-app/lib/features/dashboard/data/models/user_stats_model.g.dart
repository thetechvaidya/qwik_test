// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) =>
    UserStatsModel(
      totalExams: (json['totalExams'] as num).toInt(),
      completedToday: (json['completedToday'] as num).toInt(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      totalPoints: (json['totalPoints'] as num).toInt(),
      averageScore: (json['averageScore'] as num).toDouble(),
      totalTimeSpent: (json['totalTimeSpent'] as num).toInt(),
      performanceTrends: (json['performanceTrends'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      totalCorrectAnswers: (json['totalCorrectAnswers'] as num).toInt(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      lastExamDate: json['lastExamDate'] == null
          ? null
          : DateTime.parse(json['lastExamDate'] as String),
      weeklyGoal: (json['weeklyGoal'] as num?)?.toInt() ?? 5,
      monthlyGoal: (json['monthlyGoal'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$UserStatsModelToJson(UserStatsModel instance) =>
    <String, dynamic>{
      'totalExams': instance.totalExams,
      'completedToday': instance.completedToday,
      'currentStreak': instance.currentStreak,
      'totalPoints': instance.totalPoints,
      'averageScore': instance.averageScore,
      'totalTimeSpent': instance.totalTimeSpent,
      'performanceTrends': instance.performanceTrends,
      'totalCorrectAnswers': instance.totalCorrectAnswers,
      'totalQuestions': instance.totalQuestions,
      'longestStreak': instance.longestStreak,
      'lastExamDate': instance.lastExamDate?.toIso8601String(),
      'weeklyGoal': instance.weeklyGoal,
      'monthlyGoal': instance.monthlyGoal,
    };
