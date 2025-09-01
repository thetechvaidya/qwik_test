import 'package:equatable/equatable.dart';
import '../../domain/entities/answer.dart';

/// Base class for all exam session events
abstract class ExamSessionEvent extends Equatable {
  const ExamSessionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start a new exam session
class StartExamSessionEvent extends ExamSessionEvent {
  final String examId;
  final Map<String, dynamic>? settings;

  const StartExamSessionEvent({
    required this.examId,
    this.settings,
  });

  @override
  List<Object?> get props => [examId, settings];
}

/// Event to load an existing exam session
class LoadExamSessionEvent extends ExamSessionEvent {
  final String sessionId;
  final bool forceRefresh;

  const LoadExamSessionEvent({
    required this.sessionId,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [sessionId, forceRefresh];
}

/// Event to navigate to next question
class NextQuestionEvent extends ExamSessionEvent {
  const NextQuestionEvent();
}

/// Event to navigate to previous question
class PreviousQuestionEvent extends ExamSessionEvent {
  const PreviousQuestionEvent();
}

/// Event to navigate to a specific question
class NavigateToQuestionEvent extends ExamSessionEvent {
  final int questionIndex;

  const NavigateToQuestionEvent({required this.questionIndex});

  @override
  List<Object?> get props => [questionIndex];
}

/// Event to submit an answer
class SubmitAnswerEvent extends ExamSessionEvent {
  final Answer answer;
  final bool autoNavigate;

  const SubmitAnswerEvent({
    required this.answer,
    this.autoNavigate = true,
  });

  @override
  List<Object?> get props => [answer, autoNavigate];
}

/// Event to mark question for review
class MarkForReviewEvent extends ExamSessionEvent {
  final String questionId;
  final bool isMarked;

  const MarkForReviewEvent({
    required this.questionId,
    required this.isMarked,
  });

  @override
  List<Object?> get props => [questionId, isMarked];
}

/// Event to skip current question
class SkipQuestionEvent extends ExamSessionEvent {
  final String questionId;

  const SkipQuestionEvent({required this.questionId});

  @override
  List<Object?> get props => [questionId];
}

/// Event to pause the exam session
class PauseExamSessionEvent extends ExamSessionEvent {
  const PauseExamSessionEvent();
}

/// Event to resume the exam session
class ResumeExamSessionEvent extends ExamSessionEvent {
  const ResumeExamSessionEvent();
}

/// Event to submit the entire exam
class SubmitExamEvent extends ExamSessionEvent {
  final bool forceSubmit;

  const SubmitExamEvent({this.forceSubmit = false});

  @override
  List<Object?> get props => [forceSubmit];
}

/// Event to abandon the exam session
class AbandonExamSessionEvent extends ExamSessionEvent {
  final String? reason;

  const AbandonExamSessionEvent({this.reason});

  @override
  List<Object?> get props => [reason];
}

/// Event to update session progress
class UpdateSessionProgressEvent extends ExamSessionEvent {
  final Map<String, dynamic> updates;

  const UpdateSessionProgressEvent({required this.updates});

  @override
  List<Object?> get props => [updates];
}

/// Event to sync session data
class SyncSessionDataEvent extends ExamSessionEvent {
  const SyncSessionDataEvent();
}

/// Event to handle timer tick
class TimerTickEvent extends ExamSessionEvent {
  final int remainingSeconds;

  const TimerTickEvent({required this.remainingSeconds});

  @override
  List<Object?> get props => [remainingSeconds];
}

/// Event to handle timer expiry
class TimerExpiredEvent extends ExamSessionEvent {
  const TimerExpiredEvent();
}

/// Event to retry after error
class RetryExamSessionEvent extends ExamSessionEvent {
  const RetryExamSessionEvent();
}

/// Event to clear error state
class ClearErrorEvent extends ExamSessionEvent {
  const ClearErrorEvent();
}

/// Event to show question explanation
class ShowQuestionExplanationEvent extends ExamSessionEvent {
  final String questionId;

  const ShowQuestionExplanationEvent({required this.questionId});

  @override
  List<Object?> get props => [questionId];
}

/// Event to toggle question palette visibility
class ToggleQuestionPaletteEvent extends ExamSessionEvent {
  const ToggleQuestionPaletteEvent();
}

/// Event to update session settings
class UpdateSessionSettingsEvent extends ExamSessionEvent {
  final Map<String, dynamic> settings;

  const UpdateSessionSettingsEvent({required this.settings});

  @override
  List<Object?> get props => [settings];
}