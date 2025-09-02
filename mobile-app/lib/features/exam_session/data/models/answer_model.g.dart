// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnswerModelAdapter extends TypeAdapter<AnswerModel> {
  @override
  final int typeId = 20;

  @override
  AnswerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnswerModel(
      questionId: fields[0] as String,
      selectedOptionIds: (fields[1] as List).cast<String>(),
      timeSpent: fields[2] as int,
      answeredAt: fields[3] as DateTime?,
      isCorrect: fields[4] as bool?,
      score: fields[5] as double?,
      isSkipped: fields[6] as bool,
      isMarkedForReview: fields[7] as bool,
      metadata: (fields[8] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnswerModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.selectedOptionIds)
      ..writeByte(2)
      ..write(obj.timeSpent)
      ..writeByte(3)
      ..write(obj.answeredAt)
      ..writeByte(4)
      ..write(obj.isCorrect)
      ..writeByte(5)
      ..write(obj.score)
      ..writeByte(6)
      ..write(obj.isSkipped)
      ..writeByte(7)
      ..write(obj.isMarkedForReview)
      ..writeByte(8)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerModel _$AnswerModelFromJson(Map<String, dynamic> json) => AnswerModel(
      questionId: json['question_id'] as String,
      selectedOptionIds: (json['selected_option_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      timeSpent: (json['time_spent'] as num?)?.toInt() ?? 0,
      answeredAt: json['answered_at'] == null
          ? null
          : DateTime.parse(json['answered_at'] as String),
      isCorrect: json['is_correct'] as bool?,
      score: (json['score'] as num?)?.toDouble(),
      isSkipped: json['is_skipped'] as bool? ?? false,
      isMarkedForReview: json['is_marked_for_review'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AnswerModelToJson(AnswerModel instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'selected_option_ids': instance.selectedOptionIds,
      'time_spent': instance.timeSpent,
      'answered_at': instance.answeredAt?.toIso8601String(),
      'is_correct': instance.isCorrect,
      'score': instance.score,
      'is_skipped': instance.isSkipped,
      'is_marked_for_review': instance.isMarkedForReview,
      'metadata': instance.metadata,
    };
