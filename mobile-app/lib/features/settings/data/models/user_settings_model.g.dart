// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsModelAdapter extends TypeAdapter<UserSettingsModel> {
  @override
  final int typeId = 2;

  @override
  UserSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettingsModel(
      userId: fields[0] as String,
      notifications: fields[1] as NotificationSettingsModel,
      preferences: fields[2] as AppPreferencesModel,
      privacy: (fields[3] as Map).cast<String, dynamic>(),
      security: (fields[4] as Map).cast<String, dynamic>(),
      updatedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettingsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.notifications)
      ..writeByte(2)
      ..write(obj.preferences)
      ..writeByte(3)
      ..write(obj.privacy)
      ..writeByte(4)
      ..write(obj.security)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) =>
    UserSettingsModel(
      userId: json['userId'] as String,
      notifications: json['notifications'] == null
          ? const NotificationSettingsModel()
          : NotificationSettingsModel.fromJson(
              json['notifications'] as Map<String, dynamic>),
      preferences: json['preferences'] == null
          ? const AppPreferencesModel()
          : AppPreferencesModel.fromJson(
              json['preferences'] as Map<String, dynamic>),
      privacy: json['privacy'] as Map<String, dynamic>? ?? const {},
      security: json['security'] as Map<String, dynamic>? ?? const {},
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserSettingsModelToJson(UserSettingsModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'notifications': instance.notifications.toJson(),
      'preferences': instance.preferences.toJson(),
      'privacy': instance.privacy,
      'security': instance.security,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
