// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) =>
    UserStatsModel(
      totalExamsTaken: (json['totalExamsTaken'] as num?)?.toInt() ?? 0,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      certificatesEarned: (json['certificatesEarned'] as num?)?.toInt() ?? 0,
      studyHours: (json['studyHours'] as num?)?.toInt() ?? 0,
      correctAnswers: (json['correctAnswers'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserStatsModelToJson(UserStatsModel instance) =>
    <String, dynamic>{
      'totalExamsTaken': instance.totalExamsTaken,
      'totalPoints': instance.totalPoints,
      'averageScore': instance.averageScore,
      'rank': instance.rank,
      'streakDays': instance.streakDays,
      'certificatesEarned': instance.certificatesEarned,
      'studyHours': instance.studyHours,
      'correctAnswers': instance.correctAnswers,
      'totalQuestions': instance.totalQuestions,
    };
