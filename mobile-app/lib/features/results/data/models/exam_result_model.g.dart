// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamResultModel _$ExamResultModelFromJson(Map<String, dynamic> json) =>
    ExamResultModel(
      id: json['id'] as String,
      examId: json['examId'] as String,
      examTitle: json['examTitle'] as String,
      userId: json['userId'] as String,
      questionResults: (json['questionResults'] as List<dynamic>)
          .map((e) => QuestionResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalScore: (json['totalScore'] as num).toDouble(),
      maxScore: (json['maxScore'] as num).toDouble(),
      timeSpent: Duration(microseconds: (json['timeSpent'] as num).toInt()),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
      status: $enumDecode(_$ExamStatusEnumMap, json['status']),
      category: json['category'] as String,
      difficulty: $enumDecode(_$ExamDifficultyEnumMap, json['difficulty']),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>,
      feedback: json['feedback'] as String?,
    );

Map<String, dynamic> _$ExamResultModelToJson(ExamResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'examId': instance.examId,
      'examTitle': instance.examTitle,
      'userId': instance.userId,
      'totalScore': instance.totalScore,
      'maxScore': instance.maxScore,
      'timeSpent': instance.timeSpent.inMicroseconds,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt.toIso8601String(),
      'status': _$ExamStatusEnumMap[instance.status]!,
      'category': instance.category,
      'metadata': instance.metadata,
      'tags': instance.tags,
      'feedback': instance.feedback,
      'difficulty': _$ExamDifficultyEnumMap[instance.difficulty]!,
      'questionResults':
          instance.questionResults.map((e) => e.toJson()).toList(),
    };

const _$ExamStatusEnumMap = {
  ExamStatus.inProgress: 'inProgress',
  ExamStatus.completed: 'completed',
  ExamStatus.abandoned: 'abandoned',
  ExamStatus.timedOut: 'timedOut',
};

const _$ExamDifficultyEnumMap = {
  ExamDifficulty.easy: 'easy',
  ExamDifficulty.medium: 'medium',
  ExamDifficulty.hard: 'hard',
};
