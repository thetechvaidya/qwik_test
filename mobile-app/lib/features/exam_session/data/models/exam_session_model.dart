import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/exam_session.dart';
import '../../../exams/domain/entities/exam.dart';
import '../../../exams/data/models/exam_model.dart';
import 'question_model.dart';
import 'answer_model.dart';

part 'exam_session_model.g.dart';

@HiveType(typeId: 21)
@JsonSerializable()
class ExamSessionModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'session_id')
  final String sessionId;

  @HiveField(1)
  @JsonKey(name: 'exam_id')
  final String examId;

  @HiveField(2)
  @JsonKey(name: 'exam')
  final ExamModel exam;

  @HiveField(3)
  @JsonKey(name: 'questions')
  final List<QuestionModel> questions;

  @HiveField(4)
  @JsonKey(name: 'answers')
  final List<AnswerModel> answers;

  @HiveField(5)
  @JsonKey(name: 'current_question_index')
  final int currentQuestionIndex;

  @HiveField(6)
  @JsonKey(name: 'started_at')
  final DateTime startedAt;

  @HiveField(7)
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  @HiveField(8)
  @JsonKey(name: 'remaining_time_seconds')
  final int remainingTimeSeconds;

  @HiveField(9)
  @JsonKey(name: 'status')
  final String status;

  @HiveField(10)
  @JsonKey(name: 'settings')
  final ExamSettingsModel settings;

  @HiveField(11)
  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;

  @HiveField(12)
  @JsonKey(name: 'paused_at')
  final DateTime? pausedAt;

  @HiveField(13)
  @JsonKey(name: 'total_pause_duration')
  final int totalPauseDuration;

  @HiveField(14)
  @JsonKey(name: 'submitted_at')
  final DateTime? submittedAt;

  ExamSessionModel({
    required this.sessionId,
    required this.examId,
    required this.exam,
    this.questions = const [],
    this.answers = const [],
    this.currentQuestionIndex = 0,
    required this.startedAt,
    required this.expiresAt,
    required this.remainingTimeSeconds,
    this.status = 'active',
    required this.settings,
    this.metadata,
    this.pausedAt,
    this.totalPauseDuration = 0,
    this.submittedAt,
  });

  /// Convert from JSON
  factory ExamSessionModel.fromJson(Map<String, dynamic> json) => _$ExamSessionModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ExamSessionModelToJson(this);

  /// Convert from domain entity
  factory ExamSessionModel.fromEntity(ExamSession session) {
    return ExamSessionModel(
      sessionId: session.sessionId,
      examId: session.examId,
      exam: ExamModel.fromEntity(session.exam),
      questions: session.questions.map((q) => QuestionModel.fromEntity(q)).toList(),
      answers: session.answers.values.map((a) => AnswerModel.fromEntity(a)).toList(),
      currentQuestionIndex: session.currentQuestionIndex,
      startedAt: session.startedAt,
      expiresAt: session.expiresAt,
      remainingTimeSeconds: session.remainingTimeSeconds,
      status: session.status.name,
      settings: ExamSettingsModel.fromEntity(session.settings),
      metadata: session.metadata,
      pausedAt: session.pausedAt,
      totalPauseDuration: session.totalPauseDuration,
      submittedAt: session.submittedAt,
    );
  }

  /// Convert to domain entity
  ExamSession toEntity() {
    return ExamSession(
      sessionId: sessionId,
      examId: examId,
      exam: exam.toEntity(),
      questions: questions.map((q) => q.toEntity()).toList(),
      answers: { for (final a in answers) a.questionId: a.toEntity() },
      currentQuestionIndex: currentQuestionIndex,
      startedAt: startedAt,
      expiresAt: expiresAt,
      remainingTimeSeconds: remainingTimeSeconds,
      status: _parseExamSessionStatus(status),
      settings: settings.toEntity(),
      metadata: metadata,
      pausedAt: pausedAt,
      totalPauseDuration: totalPauseDuration,
      submittedAt: submittedAt,
    );
  }

  /// Parse exam session status from string
  ExamSessionStatus _parseExamSessionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'not_started':
        return ExamSessionStatus.notStarted;
      case 'active':
        return ExamSessionStatus.active;
      case 'paused':
        return ExamSessionStatus.paused;
      case 'completed':
        return ExamSessionStatus.completed;
      case 'expired':
        return ExamSessionStatus.expired;
      case 'submitted':
        return ExamSessionStatus.submitted;
      default:
        return ExamSessionStatus.active;
    }
  }
}