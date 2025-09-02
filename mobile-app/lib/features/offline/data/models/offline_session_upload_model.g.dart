// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_session_upload_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineSessionUploadModelAdapter
    extends TypeAdapter<OfflineSessionUploadModel> {
  @override
  final int typeId = 12;

  @override
  OfflineSessionUploadModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineSessionUploadModel(
      sessionId: fields[0] as String,
      examId: fields[1] as String,
      userId: fields[2] as String,
      answers: (fields[3] as List).cast<Answer>(),
      startTime: fields[4] as DateTime,
      endTime: fields[5] as DateTime,
      deviceInfo: fields[6] as DeviceInfoModel,
      metadata: (fields[7] as Map).cast<String, dynamic>(),
      uploadProgress: fields[8] as double,
      lastUploadAttempt: fields[9] as DateTime?,
      uploadError: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineSessionUploadModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.examId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.answers)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.deviceInfo)
      ..writeByte(7)
      ..write(obj.metadata)
      ..writeByte(8)
      ..write(obj.uploadProgress)
      ..writeByte(9)
      ..write(obj.lastUploadAttempt)
      ..writeByte(10)
      ..write(obj.uploadError);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineSessionUploadModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceInfoModelAdapter extends TypeAdapter<DeviceInfoModel> {
  @override
  final int typeId = 13;

  @override
  DeviceInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceInfoModel(
      platform: fields[0] as String,
      version: fields[1] as String,
      model: fields[2] as String,
      appVersion: fields[3] as String?,
      networkType: fields[4] as String?,
      batteryLevel: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceInfoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.platform)
      ..writeByte(1)
      ..write(obj.version)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.appVersion)
      ..writeByte(4)
      ..write(obj.networkType)
      ..writeByte(5)
      ..write(obj.batteryLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
