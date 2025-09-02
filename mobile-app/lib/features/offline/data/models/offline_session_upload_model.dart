import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/offline_session_upload.dart';
import '../../../exam_session/domain/entities/answer.dart';

part 'offline_session_upload_model.g.dart';

@HiveType(typeId: 12)
@JsonSerializable()
class OfflineSessionUploadModel extends HiveObject {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final String examId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final List<Answer> answers;

  @HiveField(4)
  final DateTime startTime;

  @HiveField(5)
  final DateTime endTime;

  @HiveField(6)
  final DeviceInfoModel deviceInfo;

  @HiveField(7)
  final Map<String, dynamic> metadata;

  @HiveField(8)
  final double uploadProgress;

  @HiveField(9)
  final DateTime? lastUploadAttempt;

  @HiveField(10)
  final String? uploadError;

  OfflineSessionUploadModel({
    required this.sessionId,
    required this.examId,
    required this.userId,
    required this.answers,
    required this.startTime,
    required this.endTime,
    required this.deviceInfo,
    this.metadata = const {},
    this.uploadProgress = 0.0,
    this.lastUploadAttempt,
    this.uploadError,
  });

  /// Convert from domain entity
  factory OfflineSessionUploadModel.fromEntity(OfflineSessionUpload entity) {
    return OfflineSessionUploadModel(
      sessionId: entity.sessionId,
      examId: entity.examId,
      userId: entity.userId,
      answers: entity.answers,
      startTime: entity.startTime,
      endTime: entity.endTime,
      deviceInfo: DeviceInfoModel.fromEntity(entity.deviceInfo),
      metadata: entity.metadata,
      uploadProgress: entity.uploadProgress,
      lastUploadAttempt: entity.lastUploadAttempt,
      uploadError: entity.uploadError,
    );
  }

  /// Convert to domain entity
  OfflineSessionUpload toEntity() {
    return OfflineSessionUpload(
      sessionId: sessionId,
      examId: examId,
      userId: userId,
      answers: answers,
      startTime: startTime,
      endTime: endTime,
      deviceInfo: deviceInfo.toEntity(),
      metadata: metadata,
      uploadProgress: uploadProgress,
      lastUploadAttempt: lastUploadAttempt,
      uploadError: uploadError,
    );
  }

  /// JSON serialization
  factory OfflineSessionUploadModel.fromJson(Map<String, dynamic> json) =>
      _$OfflineSessionUploadModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfflineSessionUploadModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OfflineSessionUploadModel &&
        other.sessionId == sessionId &&
        other.examId == examId &&
        other.userId == userId;
  }

  @override
  int get hashCode => sessionId.hashCode ^ examId.hashCode ^ userId.hashCode;
}

@HiveType(typeId: 13)
@JsonSerializable()
class DeviceInfoModel extends HiveObject {
  @HiveField(0)
  final String platform;

  @HiveField(1)
  final String version;

  @HiveField(2)
  final String model;

  @HiveField(3)
  final String? appVersion;

  @HiveField(4)
  final String? networkType;

  @HiveField(5)
  final double? batteryLevel;

  DeviceInfoModel({
    required this.platform,
    required this.version,
    required this.model,
    this.appVersion,
    this.networkType,
    this.batteryLevel,
  });

  /// Convert from domain entity
  factory DeviceInfoModel.fromEntity(DeviceInfo entity) {
    return DeviceInfoModel(
      platform: entity.platform,
      version: entity.version,
      model: entity.model,
      appVersion: entity.appVersion,
      networkType: entity.networkType,
      batteryLevel: entity.batteryLevel,
    );
  }

  /// Convert to domain entity
  DeviceInfo toEntity() {
    return DeviceInfo(
      platform: platform,
      version: version,
      model: model,
      appVersion: appVersion,
      networkType: networkType,
      batteryLevel: batteryLevel,
    );
  }

  /// JSON serialization
  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceInfoModel &&
        other.platform == platform &&
        other.version == version &&
        other.model == model;
  }

  @override
  int get hashCode => platform.hashCode ^ version.hashCode ^ model.hashCode;
}