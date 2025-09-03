// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionModelAdapter extends TypeAdapter<QuestionModel> {
  @override
  final int typeId = 19;

  @override
  QuestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionModel(
      id: fields[0] as String,
      type: fields[1] as String,
      questionText: fields[2] as String,
      options: (fields[3] as List).cast<OptionModel>(),
      timeLimit: fields[4] as int?,
      explanation: fields[5] as String?,
      difficulty: fields[6] as String,
      marks: fields[7] as double,
      imageUrl: fields[8] as String?,
      audioUrl: fields[9] as String?,
      videoUrl: fields[10] as String?,
      order: fields[11] as int,
      isRequired: fields[12] as bool,
      metadata: (fields[13] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.questionText)
      ..writeByte(3)
      ..write(obj.options)
      ..writeByte(4)
      ..write(obj.timeLimit)
      ..writeByte(5)
      ..write(obj.explanation)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.marks)
      ..writeByte(8)
      ..write(obj.imageUrl)
      ..writeByte(9)
      ..write(obj.audioUrl)
      ..writeByte(10)
      ..write(obj.videoUrl)
      ..writeByte(11)
      ..write(obj.order)
      ..writeByte(12)
      ..write(obj.isRequired)
      ..writeByte(13)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      questionText: json['question_text'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      timeLimit: (json['time_limit'] as num?)?.toInt(),
      explanation: json['explanation'] as String?,
      difficulty: json['difficulty'] as String? ?? 'medium',
      marks: (json['marks'] as num?)?.toDouble() ?? 1.0,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      videoUrl: json['video_url'] as String?,
      order: (json['order'] as num).toInt(),
      isRequired: json['is_required'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'question_text': instance.questionText,
      'options': instance.options,
      'time_limit': instance.timeLimit,
      'explanation': instance.explanation,
      'difficulty': instance.difficulty,
      'marks': instance.marks,
      'image_url': instance.imageUrl,
      'audio_url': instance.audioUrl,
      'video_url': instance.videoUrl,
      'order': instance.order,
      'is_required': instance.isRequired,
      'metadata': instance.metadata,
    };
