import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/exam.dart';

part 'exam_model.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class ExamModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final String id;

  @HiveField(1)
  @JsonKey(name: 'title')
  final String title;

  @HiveField(2)
  @JsonKey(name: 'description')
  final String description;

  @HiveField(3)
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @HiveField(4)
  @JsonKey(name: 'duration')
  final int duration;

  @HiveField(5)
  @JsonKey(name: 'total_questions')
  final int totalQuestions;

  @HiveField(6)
  @JsonKey(name: 'total_marks')
  final int totalMarks;

  @HiveField(7)
  @JsonKey(name: 'passing_score')
  final double passingScore;

  @HiveField(8)
  @JsonKey(name: 'difficulty')
  final String difficulty;

  @HiveField(9)
  @JsonKey(name: 'category')
  final String category;

  @HiveField(10)
  @JsonKey(name: 'subcategory')
  final String? subcategory;

  @HiveField(11)
  @JsonKey(name: 'tags')
  final List<String> tags;

  @HiveField(12)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @HiveField(13)
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @HiveField(14)
  @JsonKey(name: 'scheduled_at')
  final DateTime? scheduledAt;

  @HiveField(15)
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  @HiveField(16)
  @JsonKey(name: 'is_active')
  final bool isActive;

  @HiveField(17)
  @JsonKey(name: 'is_paid')
  final bool isPaid;

  @HiveField(18)
  @JsonKey(name: 'price')
  final double? price;

  @HiveField(19)
  @JsonKey(name: 'currency')
  final String? currency;

  @HiveField(20)
  @JsonKey(name: 'status')
  final String status;

  @HiveField(21)
  @JsonKey(name: 'type')
  final String type;

  @HiveField(22)
  @JsonKey(name: 'stats')
  final ExamStatsModel? stats;

  ExamModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.duration,
    required this.totalQuestions,
    required this.totalMarks,
    required this.passingScore,
    required this.difficulty,
    required this.category,
    this.subcategory,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.scheduledAt,
    this.expiresAt,
    this.isActive = true,
    this.isPaid = false,
    this.price,
    this.currency,
    this.status = 'draft',
    this.type = 'practice',
    this.stats,
  });

  /// Convert from JSON
  factory ExamModel.fromJson(Map<String, dynamic> json) => _$ExamModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ExamModelToJson(this);

  /// Convert from domain entity
  factory ExamModel.fromEntity(Exam exam) {
    return ExamModel(
      id: exam.id,
      title: exam.title,
      description: exam.description,
      imageUrl: exam.imageUrl,
      duration: exam.duration,
      totalQuestions: exam.totalQuestions,
      totalMarks: exam.totalMarks,
      passingScore: exam.passingScore,
      difficulty: exam.difficulty,
      category: exam.category,
      subcategory: exam.subcategory,
      tags: exam.tags,
      createdAt: exam.createdAt,
      updatedAt: exam.updatedAt,
      scheduledAt: exam.scheduledAt,
      expiresAt: exam.expiresAt,
      isActive: exam.isActive,
      isPaid: exam.isPaid,
      price: exam.price,
      currency: exam.currency,
      status: exam.status.name,
      type: exam.type.name,
      stats: exam.stats != null ? ExamStatsModel.fromEntity(exam.stats!) : null,
    );
  }

  /// Convert to domain entity
  Exam toEntity() {
    return Exam(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      duration: duration,
      totalQuestions: totalQuestions,
      totalMarks: totalMarks,
      passingScore: passingScore,
      difficulty: difficulty,
      category: category,
      subcategory: subcategory,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
      scheduledAt: scheduledAt,
      expiresAt: expiresAt,
      isActive: isActive,
      isPaid: isPaid,
      price: price,
      currency: currency,
      status: _parseExamStatus(status),
      type: _parseExamType(type),
      stats: stats?.toEntity(),
    );
  }

  /// Parse exam status from string
  ExamStatus _parseExamStatus(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return ExamStatus.draft;
      case 'published':
        return ExamStatus.published;
      case 'archived':
        return ExamStatus.archived;
      case 'suspended':
        return ExamStatus.suspended;
      default:
        return ExamStatus.draft;
    }
  }

  /// Parse exam type from string
  ExamType _parseExamType(String type) {
    switch (type.toLowerCase()) {
      case 'practice':
        return ExamType.practice;
      case 'mock':
        return ExamType.mock;
      case 'live':
        return ExamType.live;
      case 'assessment':
        return ExamType.assessment;
      default:
        return ExamType.practice;
    }
  }
}



@HiveType(typeId: 12)
@JsonSerializable()
class ExamStatsModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'total_attempts')
  final int totalAttempts;

  @HiveField(1)
  @JsonKey(name: 'average_score')
  final double averageScore;

  @HiveField(2)
  @JsonKey(name: 'highest_score')
  final double highestScore;

  @HiveField(3)
  @JsonKey(name: 'lowest_score')
  final double lowestScore;

  @HiveField(4)
  @JsonKey(name: 'pass_count')
  final int passCount;

  @HiveField(5)
  @JsonKey(name: 'fail_count')
  final int failCount;

  @HiveField(6)
  @JsonKey(name: 'pass_rate')
  final double passRate;

  @HiveField(7)
  @JsonKey(name: 'average_completion_time_minutes')
  final int averageCompletionTimeMinutes;

  ExamStatsModel({
    required this.totalAttempts,
    required this.averageScore,
    required this.highestScore,
    required this.lowestScore,
    required this.passCount,
    required this.failCount,
    required this.passRate,
    required this.averageCompletionTimeMinutes,
  });

  factory ExamStatsModel.fromJson(Map<String, dynamic> json) => _$ExamStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExamStatsModelToJson(this);

  factory ExamStatsModel.fromEntity(ExamStats stats) {
    return ExamStatsModel(
      totalAttempts: stats.totalAttempts,
      averageScore: stats.averageScore,
      highestScore: stats.highestScore,
      lowestScore: stats.lowestScore,
      passCount: stats.passCount,
      failCount: stats.failCount,
      passRate: stats.passRate,
      averageCompletionTimeMinutes: stats.averageCompletionTime.inMinutes,
    );
  }

  ExamStats toEntity() {
    return ExamStats(
      totalAttempts: totalAttempts,
      averageScore: averageScore,
      highestScore: highestScore,
      lowestScore: lowestScore,
      passCount: passCount,
      failCount: failCount,
      passRate: passRate,
      averageCompletionTime: Duration(minutes: averageCompletionTimeMinutes),
    );
  }
}