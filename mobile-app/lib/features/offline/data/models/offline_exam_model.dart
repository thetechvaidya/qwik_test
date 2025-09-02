import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/offline_exam.dart';
import '../../../exams/domain/entities/exam.dart';
import '../../../exam_session/domain/entities/question.dart';

part 'offline_exam_model.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class OfflineExamModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Exam exam;

  @HiveField(2)
  final List<Question> questions;

  @HiveField(3)
  final DateTime downloadedAt;

  @HiveField(4)
  final DateTime? expiresAt;

  @HiveField(5)
  final int storageSizeBytes;

  @HiveField(6)
  final String version;

  @HiveField(7)
  final Map<String, dynamic> metadata;

  OfflineExamModel({
    required this.id,
    required this.exam,
    required this.questions,
    required this.downloadedAt,
    this.expiresAt,
    required this.storageSizeBytes,
    required this.version,
    this.metadata = const {},
  });

  /// Convert from domain entity
  factory OfflineExamModel.fromEntity(OfflineExam entity) {
    return OfflineExamModel(
      id: entity.id,
      exam: entity.exam,
      questions: entity.questions,
      downloadedAt: entity.downloadedAt,
      expiresAt: entity.expiresAt,
      storageSizeBytes: entity.storageSizeBytes,
      version: entity.version,
      metadata: entity.metadata,
    );
  }

  /// Convert to domain entity
  OfflineExam toEntity() {
    return OfflineExam(
      id: id,
      exam: exam,
      questions: questions,
      downloadedAt: downloadedAt,
      expiresAt: expiresAt,
      storageSizeBytes: storageSizeBytes,
      version: version,
      metadata: metadata,
    );
  }

  /// JSON serialization
  factory OfflineExamModel.fromJson(Map<String, dynamic> json) =>
      _$OfflineExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfflineExamModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OfflineExamModel &&
        other.id == id &&
        other.version == version;
  }

  @override
  int get hashCode => id.hashCode ^ version.hashCode;
}