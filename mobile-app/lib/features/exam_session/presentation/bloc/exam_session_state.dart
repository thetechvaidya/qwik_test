import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import '../../domain/entities/exam_session.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/answer.dart';

/// Base class for all exam session states
abstract class ExamSessionState extends Equatable {
  const ExamSessionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ExamSessionInitial extends ExamSessionState {
  const ExamSessionInitial();
}

/// Loading state when starting or loading session
class ExamSessionLoading extends ExamSessionState {
  final String? message;
  final bool isStarting;
  final bool isSubmitting;
  final bool isSyncing;

  const ExamSessionLoading({
    this.message,
    this.isStarting = false,
    this.isSubmitting = false,
    this.isSyncing = false,
  });

  @override
  List<Object?> get props => [message, isStarting, isSubmitting, isSyncing];
}

/// Active exam session state
class ExamSessionActive extends ExamSessionState {
  final ExamSession session;
  final Question currentQuestion;
  final List<Answer> answers;
  final int remainingTimeSeconds;
  final bool isPaused;
  final bool isQuestionPaletteVisible;
  final bool isSubmittingAnswer;
  final bool isSyncing;
  final String? currentError;
  final DateTime lastUpdated;

  const ExamSessionActive({
    required this.session,
    required this.currentQuestion,
    required this.answers,
    required this.remainingTimeSeconds,
    this.isPaused = false,
    this.isQuestionPaletteVisible = false,
    this.isSubmittingAnswer = false,
    this.isSyncing = false,
    this.currentError,
    required this.lastUpdated,
  });

  /// Create a copy with updated properties
  ExamSessionActive copyWith({
    ExamSession? session,
    Question? currentQuestion,
    List<Answer>? answers,
    int? remainingTimeSeconds,
    bool? isPaused,
    bool? isQuestionPaletteVisible,
    bool? isSubmittingAnswer,
    bool? isSyncing,
    String? currentError,
    DateTime? lastUpdated,
  }) {
    return ExamSessionActive(
      session: session ?? this.session,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      answers: answers ?? this.answers,
      remainingTimeSeconds: remainingTimeSeconds ?? this.remainingTimeSeconds,
      isPaused: isPaused ?? this.isPaused,
      isQuestionPaletteVisible: isQuestionPaletteVisible ?? this.isQuestionPaletteVisible,
      isSubmittingAnswer: isSubmittingAnswer ?? this.isSubmittingAnswer,
      isSyncing: isSyncing ?? this.isSyncing,
      currentError: currentError,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Clear error state
  ExamSessionActive clearError() {
    return copyWith(currentError: null);
  }

  /// Get answer for current question
  Answer? get currentAnswer {
    return answers.firstWhereOrNull((answer) => answer.questionId == currentQuestion.id);
  }

  /// Get progress percentage
  double get progressPercentage {
    if (session.questions.isEmpty) return 0.0;
    final answeredCount = answers.where((answer) => !answer.isSkipped).length;
    return (answeredCount / session.questions.length) * 100;
  }

  /// Get answered questions count
  int get answeredQuestionsCount {
    return answers.where((answer) => !answer.isSkipped).length;
  }

  /// Get skipped questions count
  int get skippedQuestionsCount {
    return answers.where((answer) => answer.isSkipped).length;
  }

  /// Get marked for review questions count
  int get markedForReviewCount {
    return answers.where((answer) => answer.isMarkedForReview).length;
  }

  /// Check if current question is answered
  bool get isCurrentQuestionAnswered {
    return currentAnswer != null && !currentAnswer!.isSkipped;
  }

  /// Check if current question is marked for review
  bool get isCurrentQuestionMarkedForReview {
    return currentAnswer?.isMarkedForReview ?? false;
  }

  /// Check if can navigate to next question
  bool get canNavigateNext {
    return session.currentQuestionIndex < session.questions.length - 1;
  }

  /// Check if can navigate to previous question
  bool get canNavigatePrevious {
    return session.currentQuestionIndex > 0;
  }

  /// Check if exam is ready to submit
  bool get canSubmitExam {
    return answeredQuestionsCount > 0 || session.isTimeExpired;
  }

  /// Get time remaining formatted
  String get formattedTimeRemaining {
    final hours = remainingTimeSeconds ~/ 3600;
    final minutes = (remainingTimeSeconds % 3600) ~/ 60;
    final seconds = remainingTimeSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Check if time is running low (less than 5 minutes)
  bool get isTimeRunningLow {
    return remainingTimeSeconds <= 300; // 5 minutes
  }

  /// Check if time is critical (less than 1 minute)
  bool get isTimeCritical {
    return remainingTimeSeconds <= 60; // 1 minute
  }

  @override
  List<Object?> get props => [
        session,
        currentQuestion,
        answers,
        remainingTimeSeconds,
        isPaused,
        isQuestionPaletteVisible,
        isSubmittingAnswer,
        isSyncing,
        currentError,
        lastUpdated,
      ];
}

/// Exam session completed state
class ExamSessionCompleted extends ExamSessionState {
  final ExamSession session;
  final List<Answer> answers;
  final int totalScore;
  final int maxScore;
  final double percentage;
  final bool isPassed;
  final DateTime completedAt;

  const ExamSessionCompleted({
    required this.session,
    required this.answers,
    required this.totalScore,
    required this.maxScore,
    required this.percentage,
    required this.isPassed,
    required this.completedAt,
  });

  /// Get correct answers count
  int get correctAnswersCount {
    return answers.where((answer) => answer.isCorrect).length;
  }

  /// Get incorrect answers count
  int get incorrectAnswersCount {
    return answers.where((answer) => !answer.isCorrect && !answer.isSkipped).length;
  }

  /// Get skipped questions count
  int get skippedQuestionsCount {
    return answers.where((answer) => answer.isSkipped).length;
  }

  /// Get total time spent formatted
  String get formattedTotalTimeSpent {
    final totalSeconds = answers.fold<int>(0, (sum, answer) => sum + answer.timeSpent);
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  List<Object?> get props => [
        session,
        answers,
        totalScore,
        maxScore,
        percentage,
        isPassed,
        completedAt,
      ];
}

/// Exam session abandoned state
class ExamSessionAbandoned extends ExamSessionState {
  final String sessionId;
  final String? reason;
  final DateTime abandonedAt;

  const ExamSessionAbandoned({
    required this.sessionId,
    this.reason,
    required this.abandonedAt,
  });

  @override
  List<Object?> get props => [sessionId, reason, abandonedAt];
}

/// Error state
class ExamSessionError extends ExamSessionState {
  final String message;
  final String? errorCode;
  final bool canRetry;
  final ExamSessionState? previousState;
  final DateTime occurredAt;

  const ExamSessionError({
    required this.message,
    this.errorCode,
    this.canRetry = true,
    this.previousState,
    required this.occurredAt,
  });

  @override
  List<Object?> get props => [message, errorCode, canRetry, previousState, occurredAt];
}

/// Extension for Answer list
extension AnswerListExtension on List<Answer> {
  Answer? firstWhereOrNull(bool Function(Answer) test) {
    for (final answer in this) {
      if (test(answer)) return answer;
    }
    return null;
  }
}