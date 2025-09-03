// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflinePreferencesModelAdapter
    extends TypeAdapter<OfflinePreferencesModel> {
  @override
  final int typeId = 5;

  @override
  OfflinePreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflinePreferencesModel();
  }

  @override
  void write(BinaryWriter writer, OfflinePreferencesModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflinePreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfflinePreferencesModel _$OfflinePreferencesModelFromJson(
        Map<String, dynamic> json) =>
    OfflinePreferencesModel(
      maxOfflineExams: (json['maxOfflineExams'] as num?)?.toInt() ?? 10,
      autoDownloadEnabled: json['autoDownloadEnabled'] as bool? ?? false,
      wifiOnlyDownload: json['wifiOnlyDownload'] as bool? ?? true,
      autoSyncEnabled: json['autoSyncEnabled'] as bool? ?? true,
      downloadQuality: $enumDecodeNullable(
              _$DownloadQualityEnumMap, json['downloadQuality']) ??
          DownloadQuality.medium,
      maxStorageUsageMB: (json['maxStorageUsageMB'] as num?)?.toInt() ?? 500,
      deleteAfterDays: (json['deleteAfterDays'] as num?)?.toInt() ?? 30,
      syncOnStartup: json['syncOnStartup'] as bool? ?? true,
      backgroundSyncEnabled: json['backgroundSyncEnabled'] as bool? ?? false,
      compressContent: json['compressContent'] as bool? ?? true,
    );

Map<String, dynamic> _$OfflinePreferencesModelToJson(
        OfflinePreferencesModel instance) =>
    <String, dynamic>{
      'maxOfflineExams': instance.maxOfflineExams,
      'autoDownloadEnabled': instance.autoDownloadEnabled,
      'wifiOnlyDownload': instance.wifiOnlyDownload,
      'autoSyncEnabled': instance.autoSyncEnabled,
      'downloadQuality': _$DownloadQualityEnumMap[instance.downloadQuality]!,
      'maxStorageUsageMB': instance.maxStorageUsageMB,
      'deleteAfterDays': instance.deleteAfterDays,
      'syncOnStartup': instance.syncOnStartup,
      'backgroundSyncEnabled': instance.backgroundSyncEnabled,
      'compressContent': instance.compressContent,
    };

const _$DownloadQualityEnumMap = {
  DownloadQuality.low: 'low',
  DownloadQuality.medium: 'medium',
  DownloadQuality.high: 'high',
};
