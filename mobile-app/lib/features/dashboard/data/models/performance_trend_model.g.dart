// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_trend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformanceTrendModel _$PerformanceTrendModelFromJson(
        Map<String, dynamic> json) =>
    PerformanceTrendModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      score: (json['score'] as num).toDouble(),
      examCount: (json['examCount'] as num).toInt(),
      totalTimeSpent:
          Duration(microseconds: (json['totalTimeSpent'] as num).toInt()),
      category: json['category'] as String,
      period: $enumDecode(_$TrendPeriodEnumMap, json['period']),
      metadata: json['metadata'] as Map<String, dynamic>,
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      questionsAnswered: (json['questionsAnswered'] as num?)?.toInt(),
      correctAnswers: (json['correctAnswers'] as num?)?.toInt(),
      averageTimePerQuestion:
          (json['averageTimePerQuestion'] as num?)?.toDouble(),
      examIds:
          (json['examIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PerformanceTrendModelToJson(
        PerformanceTrendModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'score': instance.score,
      'examCount': instance.examCount,
      'totalTimeSpent': instance.totalTimeSpent.inMicroseconds,
      'category': instance.category,
      'period': _$TrendPeriodEnumMap[instance.period]!,
      'metadata': instance.metadata,
      'accuracy': instance.accuracy,
      'questionsAnswered': instance.questionsAnswered,
      'correctAnswers': instance.correctAnswers,
      'averageTimePerQuestion': instance.averageTimePerQuestion,
      'examIds': instance.examIds,
    };

const _$TrendPeriodEnumMap = {
  TrendPeriod.daily: 'daily',
  TrendPeriod.weekly: 'weekly',
  TrendPeriod.monthly: 'monthly',
  TrendPeriod.yearly: 'yearly',
};
