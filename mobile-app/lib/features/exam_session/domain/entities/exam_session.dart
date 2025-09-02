import 'package:equatable/equatable.dart';
import '../../exams/domain/entities/exam.dart';
import 'question.dart';
import 'answer.dart';

/// Exam session status enumeration
enum ExamSessionStatus {
  notStarted,
  active,
  paused,
  completed,
  expired,
  submitted,
  abandoned;

  String get displayName {
    switch (this) {
      case ExamSessionStatus.notStarted:
        return 'Not Started';
      case ExamSessionStatus.active:
        return 'Active';
      case ExamSessionStatus.paused:
        return 'Paused';
      case ExamSessionStatus.completed:
        return 'Completed';
      case ExamSessionStatus.expired:
        return 'Expired';
      case ExamSessionStatus.submitted:
        return 'Submitted';
      case ExamSessionStatus.abandoned:
        return 'Abandoned';
    }
  }
}

/// Exam session entity for managing active exam taking
class ExamSession extends Equatable {
  final String sessionId;
  final String examId;
  final Exam exam;
  final List<Question> questions;
  final Map<String, Answer> answers; // keyed by questionId
  final int currentQuestionIndex;
  final DateTime startedAt;
  final DateTime expiresAt;
  final int remainingTimeSeconds;
  final ExamSessionStatus status;
  final ExamSettings settings;
  final Map<String, dynamic>? metadata;
  final DateTime? pausedAt;
  final int totalPauseDuration; // in seconds
  final DateTime? submittedAt;

  const ExamSession({
    required this.sessionId,
    required this.examId,
    required this.exam,
    required this.questions,
    this.answers = const {},
    this.currentQuestionIndex = 0,
    required this.startedAt,
    required this.expiresAt,
    required this.remainingTimeSeconds,
    this.status = ExamSessionStatus.active,
    required this.settings,
    this.metadata,
    this.pausedAt,
    this.totalPauseDuration = 0,
    this.submittedAt,
  });

  /// Get current question
  Question? getCurrentQuestion() {
    if (currentQuestionIndex < 0 || currentQuestionIndex >= questions.length) {
      return null;
    }
    return questions[currentQuestionIndex];
  }

  /// Get next question
  Question? getNextQuestion() {
    final nextIndex = currentQuestionIndex + 1;
    if (nextIndex >= questions.length) return null;
    return questions[nextIndex];
  }

  /// Get previous question
  Question? getPreviousQuestion() {
    final prevIndex = currentQuestionIndex - 1;
    if (prevIndex < 0) return null;
    return questions[prevIndex];
  }

  /// Get question by index
  Question? getQuestionAt(int index) {
    if (index < 0 || index >= questions.length) return null;
    return questions[index];
  }

  /// Get answer for a question
  Answer? getAnswer(String questionId) {
    return answers[questionId];
  }

  /// Get progress percentage (0.0 to 1.0)
  double getProgress() {
    if (questions.isEmpty) return 0.0;
    return (currentQuestionIndex + 1) / questions.length;
  }

  /// Get answered questions count
  int getAnsweredCount() {
    return answers.values.where((answer) => answer.isAnswered).length;
  }

  /// Get unanswered questions count
  int getUnansweredCount() {
    return questions.length - getAnsweredCount();
  }

  /// Get skipped questions count
  int getSkippedCount() {
    return answers.values.where((answer) => answer.isSkipped).length;
  }

  /// Get marked for review count
  int getMarkedForReviewCount() {
    return answers.values.where((answer) => answer.isMarkedForReview).length;
  }

  /// Check if can navigate back
  bool canNavigateBack() {
    if (!settings.allowBackNavigation) return false;
    return currentQuestionIndex > 0;
  }

  /// Check if can navigate next
  bool canNavigateNext() {
    return currentQuestionIndex < questions.length - 1;
  }

  /// Check if can navigate to specific index
  bool canNavigateTo(int index) {
    if (index < 0 || index >= questions.length) return false;
    if (!settings.allowBackNavigation && index < currentQuestionIndex) return false;
    return true;
  }

  /// Check if time is expired
  bool isTimeExpired() {
    return DateTime.now().isAfter(expiresAt) || remainingTimeSeconds <= 0;
  }

  /// Check if session is active
  bool get isActive => status == ExamSessionStatus.active;

  /// Check if session is paused
  bool get isPaused => status == ExamSessionStatus.paused;

  /// Check if session is completed
  bool get isCompleted => status == ExamSessionStatus.completed || status == ExamSessionStatus.submitted;

  /// Check if all required questions are answered
  bool get allRequiredQuestionsAnswered {
    final requiredQuestions = questions.where((q) => q.isRequired);
    for (final question in requiredQuestions) {
      final answer = getAnswer(question.id);
      if (answer == null || !answer.isAnswered) {
        return false;
      }
    }
    return true;
  }

  /// Get total time spent (excluding pause duration)
  Duration getTotalTimeSpent() {
    final now = DateTime.now();
    final elapsed = now.difference(startedAt).inSeconds - totalPauseDuration;
    return Duration(seconds: elapsed.clamp(0, double.infinity).toInt());
  }

  /// Get formatted remaining time
  String getFormattedRemainingTime() {
    final hours = remainingTimeSeconds ~/ 3600;
    final minutes = (remainingTimeSeconds % 3600) ~/ 60;
    final seconds = remainingTimeSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get completion percentage
  double getCompletionPercentage() {
    if (questions.isEmpty) return 0.0;
    return getAnsweredCount() / questions.length;
  }

  /// Create copy with updated values
  ExamSession copyWith({
    String? sessionId,
    String? examId,
    Exam? exam,
    List<Question>? questions,
    Map<String, Answer>? answers,
    int? currentQuestionIndex,
    DateTime? startedAt,
    DateTime? expiresAt,
    int? remainingTimeSeconds,
    ExamSessionStatus? status,
    ExamSettings? settings,
    Map<String, dynamic>? metadata,
    DateTime? pausedAt,
    int? totalPauseDuration,
    DateTime? submittedAt,
  }) {
    return ExamSession(
      sessionId: sessionId ?? this.sessionId,
      examId: examId ?? this.examId,
      exam: exam ?? this.exam,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      startedAt: startedAt ?? this.startedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      remainingTimeSeconds: remainingTimeSeconds ?? this.remainingTimeSeconds,
      status: status ?? this.status,
      settings: settings ?? this.settings,
      metadata: metadata ?? this.metadata,
      pausedAt: pausedAt ?? this.pausedAt,
      totalPauseDuration: totalPauseDuration ?? this.totalPauseDuration,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        examId,
        exam,
        questions,
        answers,
        currentQuestionIndex,
        startedAt,
        expiresAt,
        remainingTimeSeconds,
        status,
        settings,
        metadata,
        pausedAt,
        totalPauseDuration,
        submittedAt,
      ];

  @override
  String toString() {
    return 'ExamSession(sessionId: $sessionId, examId: $examId, status: $status, currentQuestion: $currentQuestionIndex/${questions.length}, remainingTime: ${remainingTimeSeconds}s)';
  }
}