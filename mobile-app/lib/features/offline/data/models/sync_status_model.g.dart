// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_status_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncStatusModelAdapter extends TypeAdapter<SyncStatusModel> {
  @override
  final int typeId = 11;

  @override
  SyncStatusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncStatusModel(
      sessionId: fields[0] as String,
      examId: fields[1] as String,
      userId: fields[2] as String,
      statusString: fields[3] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      lastAttemptAt: fields[6] as DateTime?,
      retryCount: fields[7] as int,
      errorMessage: fields[8] as String?,
      conflictData: (fields[9] as Map?)?.cast<String, dynamic>(),
      metadata: (fields[10] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SyncStatusModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.examId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.statusString)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.lastAttemptAt)
      ..writeByte(7)
      ..write(obj.retryCount)
      ..writeByte(8)
      ..write(obj.errorMessage)
      ..writeByte(9)
      ..write(obj.conflictData)
      ..writeByte(10)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStatusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncStatusModel _$SyncStatusModelFromJson(Map<String, dynamic> json) =>
    SyncStatusModel(
      sessionId: json['sessionId'] as String,
      examId: json['examId'] as String,
      userId: json['userId'] as String,
      statusString: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastAttemptAt: json['lastAttemptAt'] == null
          ? null
          : DateTime.parse(json['lastAttemptAt'] as String),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      errorMessage: json['errorMessage'] as String?,
      conflictData: json['conflictData'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$SyncStatusModelToJson(SyncStatusModel instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'examId': instance.examId,
      'userId': instance.userId,
      'status': instance.statusString,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastAttemptAt': instance.lastAttemptAt?.toIso8601String(),
      'retryCount': instance.retryCount,
      'errorMessage': instance.errorMessage,
      'conflictData': instance.conflictData,
      'metadata': instance.metadata,
    };
