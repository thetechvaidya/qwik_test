// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingsModelAdapter
    extends TypeAdapter<NotificationSettingsModel> {
  @override
  final int typeId = 3;

  @override
  NotificationSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSettingsModel();
  }

  @override
  void write(BinaryWriter writer, NotificationSettingsModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettingsModel _$NotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    NotificationSettingsModel(
      examReminders: json['examReminders'] as bool? ?? true,
      achievementAlerts: json['achievementAlerts'] as bool? ?? true,
      studyReminders: json['studyReminders'] as bool? ?? true,
      systemUpdates: json['systemUpdates'] as bool? ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: json['quietHoursStart'] as String? ??
          const TimeOfDay(hour: 22, minute: 0),
      quietHoursEnd: json['quietHoursEnd'] as String? ??
          const TimeOfDay(hour: 8, minute: 0),
    );

Map<String, dynamic> _$NotificationSettingsModelToJson(
        NotificationSettingsModel instance) =>
    <String, dynamic>{
      'examReminders': instance.examReminders,
      'achievementAlerts': instance.achievementAlerts,
      'studyReminders': instance.studyReminders,
      'systemUpdates': instance.systemUpdates,
      'quietHoursEnabled': instance.quietHoursEnabled,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
    };
