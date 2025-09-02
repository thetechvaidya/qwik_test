// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_exam_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineExamModelAdapter extends TypeAdapter<OfflineExamModel> {
  @override
  final int typeId = 10;

  @override
  OfflineExamModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineExamModel(
      id: fields[0] as String,
      exam: fields[1] as Exam,
      questions: (fields[2] as List).cast<Question>(),
      downloadedAt: fields[3] as DateTime,
      expiresAt: fields[4] as DateTime?,
      storageSizeBytes: fields[5] as int,
      version: fields[6] as String,
      metadata: (fields[7] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, OfflineExamModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.exam)
      ..writeByte(2)
      ..write(obj.questions)
      ..writeByte(3)
      ..write(obj.downloadedAt)
      ..writeByte(4)
      ..write(obj.expiresAt)
      ..writeByte(5)
      ..write(obj.storageSizeBytes)
      ..writeByte(6)
      ..write(obj.version)
      ..writeByte(7)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineExamModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
