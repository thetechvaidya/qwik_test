// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionResultModel _$QuestionResultModelFromJson(Map<String, dynamic> json) =>
    QuestionResultModel(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      examResultId: json['examResultId'] as String,
      questionText: json['questionText'] as String,
      questionType: $enumDecode(_$QuestionTypeEnumMap, json['questionType']),
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswers: (json['correctAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      userAnswers: (json['userAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      resultType: $enumDecode(_$QuestionResultTypeEnumMap, json['resultType']),
      pointsEarned: (json['pointsEarned'] as num).toDouble(),
      maxPoints: (json['maxPoints'] as num).toDouble(),
      timeSpent: Duration(microseconds: (json['timeSpent'] as num).toInt()),
      answeredAt: DateTime.parse(json['answeredAt'] as String),
      explanation: json['explanation'] as String?,
      topic: json['topic'] as String?,
      subtopic: json['subtopic'] as String?,
      difficulty: $enumDecode(_$QuestionDifficultyEnumMap, json['difficulty']),
      metadata: json['metadata'] as Map<String, dynamic>,
      isMarkedForReview: json['isMarkedForReview'] as bool,
      userNote: json['userNote'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QuestionResultModelToJson(
        QuestionResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'examResultId': instance.examResultId,
      'questionText': instance.questionText,
      'questionType': _$QuestionTypeEnumMap[instance.questionType]!,
      'options': instance.options,
      'correctAnswers': instance.correctAnswers,
      'userAnswers': instance.userAnswers,
      'resultType': _$QuestionResultTypeEnumMap[instance.resultType]!,
      'pointsEarned': instance.pointsEarned,
      'maxPoints': instance.maxPoints,
      'timeSpent': instance.timeSpent.inMicroseconds,
      'answeredAt': instance.answeredAt.toIso8601String(),
      'explanation': instance.explanation,
      'topic': instance.topic,
      'subtopic': instance.subtopic,
      'difficulty': _$QuestionDifficultyEnumMap[instance.difficulty]!,
      'metadata': instance.metadata,
      'isMarkedForReview': instance.isMarkedForReview,
      'userNote': instance.userNote,
      'tags': instance.tags,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'multipleChoice',
  QuestionType.multipleSelect: 'multipleSelect',
  QuestionType.trueFalse: 'trueFalse',
  QuestionType.fillInTheBlank: 'fillInTheBlank',
  QuestionType.shortAnswer: 'shortAnswer',
  QuestionType.essay: 'essay',
};

const _$QuestionResultTypeEnumMap = {
  QuestionResultType.correct: 'correct',
  QuestionResultType.incorrect: 'incorrect',
  QuestionResultType.skipped: 'skipped',
  QuestionResultType.partiallyCorrect: 'partiallyCorrect',
};

const _$QuestionDifficultyEnumMap = {
  QuestionDifficulty.easy: 'easy',
  QuestionDifficulty.medium: 'medium',
  QuestionDifficulty.hard: 'hard',
};
