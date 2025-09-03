import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/exam_result.dart';
import 'question_result_model.dart';

part 'exam_result_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExamResultModel extends ExamResult {
  @override
  final List<QuestionResultModel> questionResults;

  const ExamResultModel({
    required super.id,
    required super.examId,
    required super.examTitle,
    required super.userId,
    required this.questionResults,
    required super.totalScore,
    required super.maxScore,
    required super.timeSpent,
    required super.startedAt,
    required super.completedAt,
    required super.status,
    required super.category,
    required super.difficulty,
    super.tags,
    super.metadata,
    super.feedback,
    super.certificateUrl,
    super.sharedAt,
    super.notes,
  }) : super(questionResults: questionResults);

  factory ExamResultModel.fromJson(Map<String, dynamic> json) =>
      _$ExamResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResultModelToJson(this);

  /// Create from entity
  factory ExamResultModel.fromEntity(ExamResult entity) {
    return ExamResultModel(
      id: entity.id,
      examId: entity.examId,
      examTitle: entity.examTitle,
      userId: entity.userId,
      questionResults: entity.questionResults
          .map((e) => QuestionResultModel.fromEntity(e))
          .toList(),
      totalScore: entity.totalScore,
      maxScore: entity.maxScore,
      timeSpent: entity.timeSpent,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
      status: entity.status,
      category: entity.category,
      difficulty: entity.difficulty,
      tags: entity.tags,
      metadata: entity.metadata,
      feedback: entity.feedback,
      certificateUrl: entity.certificateUrl,
      sharedAt: entity.sharedAt,
      notes: entity.notes,
    );
  }

  /// Convert to entity
  @override
  ExamResult toEntity() {
    return ExamResult(
      id: id,
      examId: examId,
      examTitle: examTitle,
      userId: userId,
      questionResults: questionResults.map((e) => e.toEntity()).toList(),
      totalScore: totalScore,
      maxScore: maxScore,
      timeSpent: timeSpent,
      startedAt: startedAt,
      completedAt: completedAt,
      status: status,
      category: category,
      difficulty: difficulty,
      tags: tags,
      metadata: metadata,
      feedback: feedback,
      certificateUrl: certificateUrl,
      sharedAt: sharedAt,
      notes: notes,
    );
  }

  /// Copy with new values
  ExamResultModel copyWith({
    String? id,
    String? examId,
    String? examTitle,
    String? userId,
    List<QuestionResultModel>? questionResults,
    double? totalScore,
    double? maxScore,
    Duration? timeSpent,
    DateTime? startedAt,
    DateTime? completedAt,
    ExamStatus? status,
    String? category,
    ExamDifficulty? difficulty,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    String? feedback,
    String? certificateUrl,
    DateTime? sharedAt,
    String? notes,
  }) {
    return ExamResultModel(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      examTitle: examTitle ?? this.examTitle,
      userId: userId ?? this.userId,
      questionResults: questionResults ?? this.questionResults,
      totalScore: totalScore ?? this.totalScore,
      maxScore: maxScore ?? this.maxScore,
      timeSpent: timeSpent ?? this.timeSpent,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      feedback: feedback ?? this.feedback,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      sharedAt: sharedAt ?? this.sharedAt,
      notes: notes ?? this.notes,
    );
  }

  /// Create empty exam result
  factory ExamResultModel.empty({
    required String examId,
    required String examTitle,
    required String userId,
    required String category,
    ExamDifficulty difficulty = ExamDifficulty.medium,
  }) {
    return ExamResultModel(
      id: '',
      examId: examId,
      examTitle: examTitle,
      userId: userId,
      questionResults: [],
      totalScore: 0.0,
      maxScore: 0.0,
      timeSpent: Duration.zero,
      startedAt: DateTime.now(),
      completedAt: null,
      status: ExamStatus.notStarted,
      category: category,
      difficulty: difficulty,
      tags: [],
      metadata: {},
    );
  }

  /// Create sample exam results for testing
  static List<ExamResultModel> getSampleResults() {
    final now = DateTime.now();
    return [
      ExamResultModel(
        id: 'result_1',
        examId: 'exam_math_001',
        examTitle: 'Advanced Mathematics Quiz',
        userId: 'user_123',
        questionResults: QuestionResultModel.getSampleResults(),
        totalScore: 85.0,
        maxScore: 100.0,
        timeSpent: const Duration(minutes: 45),
        startedAt: now.subtract(const Duration(days: 1, hours: 1)),
        completedAt: now.subtract(const Duration(days: 1)),
        status: ExamStatus.completed,
        category: 'Mathematics',
        difficulty: ExamDifficulty.hard,
        tags: ['algebra', 'calculus', 'geometry'],
        metadata: {
          'version': '1.0',
          'source': 'mobile_app',
          'deviceInfo': 'iOS 17.0',
        },
        feedback: 'Great performance! Focus on geometry for improvement.',
      ),
      ExamResultModel(
        id: 'result_2',
        examId: 'exam_science_002',
        examTitle: 'Physics Fundamentals',
        userId: 'user_123',
        questionResults: QuestionResultModel.getSampleResults().take(15).toList(),
        totalScore: 72.0,
        maxScore: 100.0,
        timeSpent: const Duration(minutes: 30),
        startedAt: now.subtract(const Duration(days: 3, hours: 2)),
        completedAt: now.subtract(const Duration(days: 3, hours: 1, minutes: 30)),
        status: ExamStatus.completed,
        category: 'Science',
        difficulty: ExamDifficulty.medium,
        tags: ['physics', 'mechanics', 'thermodynamics'],
        metadata: {
          'version': '1.0',
          'source': 'mobile_app',
          'retakeCount': 0,
        },
        feedback: 'Good understanding of basic concepts. Practice more problems.',
      ),
      ExamResultModel(
        id: 'result_3',
        examId: 'exam_history_003',
        examTitle: 'World History: Ancient Civilizations',
        userId: 'user_123',
        questionResults: QuestionResultModel.getSampleResults().take(25).toList(),
        totalScore: 92.0,
        maxScore: 100.0,
        timeSpent: const Duration(minutes: 40),
        startedAt: now.subtract(const Duration(days: 7, hours: 3)),
        completedAt: now.subtract(const Duration(days: 7, hours: 2, minutes: 20)),
        status: ExamStatus.completed,
        category: 'History',
        difficulty: ExamDifficulty.easy,
        tags: ['ancient', 'civilizations', 'culture'],
        metadata: {
          'version': '1.0',
          'source': 'mobile_app',
          'perfectScore': false,
        },
        feedback: 'Excellent knowledge of ancient civilizations!',
        certificateUrl: 'https://example.com/certificates/cert_123.pdf',
      ),
      ExamResultModel(
        id: 'result_4',
        examId: 'exam_english_004',
        examTitle: 'English Literature Analysis',
        userId: 'user_123',
        questionResults: [],
        totalScore: 0.0,
        maxScore: 100.0,
        timeSpent: const Duration(minutes: 15),
        startedAt: now.subtract(const Duration(hours: 2)),
        completedAt: null,
        status: ExamStatus.inProgress,
        category: 'Literature',
        difficulty: ExamDifficulty.hard,
        tags: ['literature', 'analysis', 'poetry'],
        metadata: {
          'version': '1.0',
          'source': 'mobile_app',
          'pausedAt': now.subtract(const Duration(minutes: 30)).toIso8601String(),
        },
      ),
    ];
  }

  /// Create result with specific performance level
  factory ExamResultModel.withPerformance({
    required String examId,
    required String examTitle,
    required String userId,
    required String category,
    required ExamDifficulty difficulty,
    required PerformanceRating performance,
    int questionCount = 20,
  }) {
    final now = DateTime.now();
    final startTime = now.subtract(Duration(minutes: questionCount + 10));
    
    // Generate score based on performance rating
    double score;
    switch (performance) {
      case PerformanceRating.excellent:
        score = 90 + (10 * (questionCount / 20)).clamp(0, 10);
        break;
      case PerformanceRating.good:
        score = 75 + (15 * (questionCount / 20)).clamp(0, 15);
        break;
      case PerformanceRating.average:
        score = 60 + (20 * (questionCount / 20)).clamp(0, 20);
        break;
      case PerformanceRating.poor:
        score = 40 + (20 * (questionCount / 20)).clamp(0, 20);
        break;
      case PerformanceRating.beginner:
        score = 20 + (30 * (questionCount / 20)).clamp(0, 30);
        break;
    }

    return ExamResultModel(
      id: 'result_${DateTime.now().millisecondsSinceEpoch}',
      examId: examId,
      examTitle: examTitle,
      userId: userId,
      questionResults: List.generate(
        questionCount,
        (index) => QuestionResultModel.withCorrectness(
          questionId: 'q_${index + 1}',
          examResultId: 'result_${DateTime.now().millisecondsSinceEpoch}',
          isCorrect: (index / questionCount) < (score / 100),
        ),
      ),
      totalScore: score,
      maxScore: 100.0,
      timeSpent: Duration(minutes: questionCount + (performance.index * 5)),
      startedAt: startTime,
      completedAt: now,
      status: ExamStatus.completed,
      category: category,
      difficulty: difficulty,
      tags: [category.toLowerCase()],
      metadata: {
        'generatedPerformance': performance.name,
        'questionCount': questionCount,
      },
    );
  }

  @override
  String toString() {
    return 'ExamResultModel(id: $id, examTitle: $examTitle, score: $totalScore/$maxScore, status: $status)';
  }
}