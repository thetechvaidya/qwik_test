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
      theme: json['theme'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
    );

Map<String, dynamic> _$AppPreferencesModelToJson(
        AppPreferencesModel instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'language': instance.language,
    };
