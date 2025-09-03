// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppPreferencesModelAdapter extends TypeAdapter<AppPreferencesModel> {
  @override
  final int typeId = 4;

  @override
  AppPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppPreferencesModel();
  }

  @override
  void write(BinaryWriter writer, AppPreferencesModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppPreferencesModel _$AppPreferencesModelFromJson(Map<String, dynamic> json) =>
    AppPreferencesModel(
      language: json['language'] as String? ?? 'en',
      timezone: json['timezone'] as String? ?? 'UTC',
      fontSize: json['fontSize'] as String? ?? FontSize.medium,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      animationsEnabled: json['animationsEnabled'] as bool? ?? true,
      autoLockEnabled: json['autoLockEnabled'] as bool? ?? false,
      autoLockTimeout: (json['autoLockTimeout'] as num?)?.toInt() ??
          AutoLockTimeout.fiveMinutes,
    );

Map<String, dynamic> _$AppPreferencesModelToJson(
        AppPreferencesModel instance) =>
    <String, dynamic>{
      'language': instance.language,
      'timezone': instance.timezone,
      'fontSize': instance.fontSize,
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'autoLockEnabled': instance.autoLockEnabled,
      'autoLockTimeout': instance.autoLockTimeout,
      'animationsEnabled': instance.animationsEnabled,
    };
