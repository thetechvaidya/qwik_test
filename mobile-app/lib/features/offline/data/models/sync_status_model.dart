import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/sync_status.dart';

part 'sync_status_model.g.dart';

@HiveType(typeId: 11)
@JsonSerializable()
class SyncStatusModel extends HiveObject {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final String examId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  @JsonKey(name: 'status')
  final String statusString;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final DateTime? lastAttemptAt;

  @HiveField(7)
  final int retryCount;

  @HiveField(8)
  final String? errorMessage;

  @HiveField(9)
  final Map<String, dynamic>? conflictData;

  @HiveField(10)
  final Map<String, dynamic> metadata;

  SyncStatusModel({
    required this.sessionId,
    required this.examId,
    required this.userId,
    required this.statusString,
    required this.createdAt,
    required this.updatedAt,
    this.lastAttemptAt,
    this.retryCount = 0,
    this.errorMessage,
    this.conflictData,
    this.metadata = const {},
  });

  /// Convert from domain entity
  factory SyncStatusModel.fromEntity(SyncStatus entity) {
    return SyncStatusModel(
      sessionId: entity.sessionId,
      examId: entity.examId,
      userId: entity.userId,
      statusString: entity.status.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastAttemptAt: entity.lastAttemptAt,
      retryCount: entity.retryCount,
      errorMessage: entity.errorMessage,
      conflictData: entity.conflictData,
      metadata: entity.metadata,
    );
  }

  /// Convert to domain entity
  SyncStatus toEntity() {
    return SyncStatus(
      sessionId: sessionId,
      examId: examId,
      userId: userId,
      status: SyncStatusType.values.firstWhere(
        (e) => e.name == statusString,
        orElse: () => SyncStatusType.pending,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastAttemptAt: lastAttemptAt,
      retryCount: retryCount,
      errorMessage: errorMessage,
      conflictData: conflictData,
      metadata: metadata,
    );
  }

  /// JSON serialization
  factory SyncStatusModel.fromJson(Map<String, dynamic> json) =>
      _$SyncStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncStatusModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncStatusModel &&
        other.sessionId == sessionId &&
        other.examId == examId &&
        other.userId == userId;
  }

  @override
  int get hashCode => sessionId.hashCode ^ examId.hashCode ^ userId.hashCode;
}