// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OptionModelAdapter extends TypeAdapter<OptionModel> {
  @override
  final int typeId = 18;

  @override
  OptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OptionModel(
      id: fields[0] as String,
      text: fields[1] as String,
      isCorrect: fields[2] as bool,
      order: fields[3] as int,
      explanation: fields[4] as String?,
      imageUrl: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OptionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isCorrect)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.explanation)
      ..writeByte(5)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionModel _$OptionModelFromJson(Map<String, dynamic> json) => OptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
      order: (json['order'] as num).toInt(),
      explanation: json['explanation'] as String?,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$OptionModelToJson(OptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'is_correct': instance.isCorrect,
      'order': instance.order,
      'explanation': instance.explanation,
      'image_url': instance.imageUrl,
    };
