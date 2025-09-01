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
  @JsonKey(name: 'settings')
  final ExamSettingsModel settings;

  @HiveField(23)
  @JsonKey(name: 'stats')
  final ExamStatsModel? stats;

  @HiveField(24)
  @JsonKey(name: 'user_progress')
  final UserExamProgressModel? userProgress;

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
    required this.settings,
    this.stats,
    this.userProgress,
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
      settings: ExamSettingsModel.fromEntity(exam.settings),
      stats: exam.stats != null ? ExamStatsModel.fromEntity(exam.stats!) : null,
      userProgress: exam.userProgress != null ? UserExamProgressModel.fromEntity(exam.userProgress!) : null,
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
      settings: settings.toEntity(),
      stats: stats?.toEntity(),
      userProgress: userProgress?.toEntity(),
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

@HiveType(typeId: 11)
@JsonSerializable()
class ExamSettingsModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'allow_review')
  final bool allowReview;

  @HiveField(1)
  @JsonKey(name: 'show_results')
  final bool showResults;

  @HiveField(2)
  @JsonKey(name: 'shuffle_questions')
  final bool shuffleQuestions;

  @HiveField(3)
  @JsonKey(name: 'shuffle_options')
  final bool shuffleOptions;

  @HiveField(4)
  @JsonKey(name: 'allow_back_navigation')
  final bool allowBackNavigation;

  @HiveField(5)
  @JsonKey(name: 'show_timer')
  final bool showTimer;

  @HiveField(6)
  @JsonKey(name: 'auto_submit')
  final bool autoSubmit;

  @HiveField(7)
  @JsonKey(name: 'max_attempts')
  final int? maxAttempts;

  @HiveField(8)
  @JsonKey(name: 'require_camera')
  final bool requireCamera;

  @HiveField(9)
  @JsonKey(name: 'require_microphone')
  final bool requireMicrophone;

  @HiveField(10)
  @JsonKey(name: 'prevent_copy_paste')
  final bool preventCopyPaste;

  @HiveField(11)
  @JsonKey(name: 'full_screen_mode')
  final bool fullScreenMode;

  @HiveField(12)
  @JsonKey(name: 'allowed_devices')
  final List<String> allowedDevices;

  ExamSettingsModel({
    this.allowReview = true,
    this.showResults = true,
    this.shuffleQuestions = false,
    this.shuffleOptions = false,
    this.allowBackNavigation = true,
    this.showTimer = true,
    this.autoSubmit = true,
    this.maxAttempts,
    this.requireCamera = false,
    this.requireMicrophone = false,
    this.preventCopyPaste = false,
    this.fullScreenMode = false,
    this.allowedDevices = const [],
  });

  factory ExamSettingsModel.fromJson(Map<String, dynamic> json) => _$ExamSettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExamSettingsModelToJson(this);

  factory ExamSettingsModel.fromEntity(ExamSettings settings) {
    return ExamSettingsModel(
      allowReview: settings.allowReview,
      showResults: settings.showResults,
      shuffleQuestions: settings.shuffleQuestions,
      shuffleOptions: settings.shuffleOptions,
      allowBackNavigation: settings.allowBackNavigation,
      showTimer: settings.showTimer,
      autoSubmit: settings.autoSubmit,
      maxAttempts: settings.maxAttempts,
      requireCamera: settings.requireCamera,
      requireMicrophone: settings.requireMicrophone,
      preventCopyPaste: settings.preventCopyPaste,
      fullScreenMode: settings.fullScreenMode,
      allowedDevices: settings.allowedDevices,
    );
  }

  ExamSettings toEntity() {
    return ExamSettings(
      allowReview: allowReview,
      showResults: showResults,
      shuffleQuestions: shuffleQuestions,
      shuffleOptions: shuffleOptions,
      allowBackNavigation: allowBackNavigation,
      showTimer: showTimer,
      autoSubmit: autoSubmit,
      maxAttempts: maxAttempts,
      requireCamera: requireCamera,
      requireMicrophone: requireMicrophone,
      preventCopyPaste: preventCopyPaste,
      fullScreenMode: fullScreenMode,
      allowedDevices: allowedDevices,
    );
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

@HiveType(typeId: 13)
@JsonSerializable()
class UserExamProgressModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'exam_id')
  final String examId;

  @HiveField(1)
  @JsonKey(name: 'user_id')
  final String userId;

  @HiveField(2)
  @JsonKey(name: 'attempt_count')
  final int attemptCount;

  @HiveField(3)
  @JsonKey(name: 'best_score')
  final double? bestScore;

  @HiveField(4)
  @JsonKey(name: 'best_score_percentage')
  final double? bestScorePercentage;

  @HiveField(5)
  @JsonKey(name: 'last_score')
  final double? lastScore;

  @HiveField(6)
  @JsonKey(name: 'last_score_percentage')
  final double? lastScorePercentage;

  @HiveField(7)
  @JsonKey(name: 'last_attempt_at')
  final DateTime? lastAttemptAt;

  @HiveField(8)
  @JsonKey(name: 'first_attempt_at')
  final DateTime? firstAttemptAt;

  @HiveField(9)
  @JsonKey(name: 'is_started')
  final bool isStarted;

  @HiveField(10)
  @JsonKey(name: 'is_completed')
  final bool isCompleted;

  @HiveField(11)
  @JsonKey(name: 'is_passed')
  final bool isPassed;

  @HiveField(12)
  @JsonKey(name: 'best_completion_time_minutes')
  final int? bestCompletionTimeMinutes;

  @HiveField(13)
  @JsonKey(name: 'last_completion_time_minutes')
  final int? lastCompletionTimeMinutes;

  UserExamProgressModel({
    required this.examId,
    required this.userId,
    this.attemptCount = 0,
    this.bestScore,
    this.bestScorePercentage,
    this.lastScore,
    this.lastScorePercentage,
    this.lastAttemptAt,
    this.firstAttemptAt,
    this.isStarted = false,
    this.isCompleted = false,
    this.isPassed = false,
    this.bestCompletionTimeMinutes,
    this.lastCompletionTimeMinutes,
  });

  factory UserExamProgressModel.fromJson(Map<String, dynamic> json) => _$UserExamProgressModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserExamProgressModelToJson(this);

  factory UserExamProgressModel.fromEntity(UserExamProgress progress) {
    return UserExamProgressModel(
      examId: progress.examId,
      userId: progress.userId,
      attemptCount: progress.attemptCount,
      bestScore: progress.bestScore,
      bestScorePercentage: progress.bestScorePercentage,
      lastScore: progress.lastScore,
      lastScorePercentage: progress.lastScorePercentage,
      lastAttemptAt: progress.lastAttemptAt,
      firstAttemptAt: progress.firstAttemptAt,
      isStarted: progress.isStarted,
      isCompleted: progress.isCompleted,
      isPassed: progress.isPassed,
      bestCompletionTimeMinutes: progress.bestCompletionTime?.inMinutes,
      lastCompletionTimeMinutes: progress.lastCompletionTime?.inMinutes,
    );
  }

  UserExamProgress toEntity() {
    return UserExamProgress(
      examId: examId,
      userId: userId,
      attemptCount: attemptCount,
      bestScore: bestScore,
      bestScorePercentage: bestScorePercentage,
      lastScore: lastScore,
      lastScorePercentage: lastScorePercentage,
      lastAttemptAt: lastAttemptAt,
      firstAttemptAt: firstAttemptAt,
      isStarted: isStarted,
      isCompleted: isCompleted,
      isPassed: isPassed,
      bestCompletionTime: bestCompletionTimeMinutes != null ? Duration(minutes: bestCompletionTimeMinutes!) : null,
      lastCompletionTime: lastCompletionTimeMinutes != null ? Duration(minutes: lastCompletionTimeMinutes!) : null,
    );
  }
}