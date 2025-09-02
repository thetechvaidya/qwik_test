// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamSessionModelAdapter extends TypeAdapter<ExamSessionModel> {
  @override
  final int typeId = 21;

  @override
  ExamSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamSessionModel(
      sessionId: fields[0] as String,
      examId: fields[1] as String,
      exam: fields[2] as ExamModel?,
      questions: (fields[3] as List).cast<QuestionModel>(),
      answers: (fields[4] as List).cast<AnswerModel>(),
      currentQuestionIndex: fields[5] as int,
      startedAt: fields[6] as DateTime,
      expiresAt: fields[7] as DateTime,
      remainingTimeSeconds: fields[8] as int,
      status: fields[9] as String,
      settings: (fields[10] as Map).cast<String, dynamic>(),
      metadata: (fields[11] as Map?)?.cast<String, dynamic>(),
      pausedAt: fields[12] as DateTime?,
      totalPauseDuration: fields[13] as int,
      submittedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ExamSessionModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.examId)
      ..writeByte(2)
      ..write(obj.exam)
      ..writeByte(3)
      ..write(obj.questions)
      ..writeByte(4)
      ..write(obj.answers)
      ..writeByte(5)
      ..write(obj.currentQuestionIndex)
      ..writeByte(6)
      ..write(obj.startedAt)
      ..writeByte(7)
      ..write(obj.expiresAt)
      ..writeByte(8)
      ..write(obj.remainingTimeSeconds)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.settings)
      ..writeByte(11)
      ..write(obj.metadata)
      ..writeByte(12)
      ..write(obj.pausedAt)
      ..writeByte(13)
      ..write(obj.totalPauseDuration)
      ..writeByte(14)
      ..write(obj.submittedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamSessionModel _$ExamSessionModelFromJson(Map<String, dynamic> json) =>
    ExamSessionModel(
      sessionId: json['session_id'] as String,
      examId: json['exam_id'] as String,
      exam: json['exam'] == null
          ? null
          : ExamModel.fromJson(json['exam'] as Map<String, dynamic>),
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentQuestionIndex:
          (json['current_question_index'] as num?)?.toInt() ?? 0,
      startedAt: DateTime.parse(json['started_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      remainingTimeSeconds: (json['remaining_time_seconds'] as num).toInt(),
      status: json['status'] as String? ?? 'active',
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      metadata: json['metadata'] as Map<String, dynamic>?,
      pausedAt: json['paused_at'] == null
          ? null
          : DateTime.parse(json['paused_at'] as String),
      totalPauseDuration: (json['total_pause_duration'] as num?)?.toInt() ?? 0,
      submittedAt: json['submitted_at'] == null
          ? null
          : DateTime.parse(json['submitted_at'] as String),
    );

Map<String, dynamic> _$ExamSessionModelToJson(ExamSessionModel instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'exam_id': instance.examId,
      'exam': instance.exam,
      'questions': instance.questions,
      'answers': instance.answers,
      'current_question_index': instance.currentQuestionIndex,
      'started_at': instance.startedAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
      'remaining_time_seconds': instance.remainingTimeSeconds,
      'status': instance.status,
      'settings': instance.settings,
      'metadata': instance.metadata,
      'paused_at': instance.pausedAt?.toIso8601String(),
      'total_pause_duration': instance.totalPauseDuration,
      'submitted_at': instance.submittedAt?.toIso8601String(),
    };
