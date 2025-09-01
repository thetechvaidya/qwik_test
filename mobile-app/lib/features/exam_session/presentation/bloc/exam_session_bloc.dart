import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/answer.dart';
import '../../domain/entities/exam_session.dart';
import '../../domain/entities/question.dart';
import '../../domain/usecases/abandon_exam_session_usecase.dart';
import '../../domain/usecases/get_exam_session_usecase.dart';
import '../../domain/usecases/start_exam_session_usecase.dart';
import '../../domain/usecases/submit_answer_usecase.dart';
import '../../domain/usecases/submit_exam_usecase.dart';
import '../../domain/usecases/update_exam_session_usecase.dart';
import 'exam_session_event.dart';
import 'exam_session_state.dart';

/// BLoC for managing exam session state and operations
class ExamSessionBloc extends Bloc<ExamSessionEvent, ExamSessionState> {
  final StartExamSessionUseCase _startExamSessionUseCase;
  final GetExamSessionUseCase _getExamSessionUseCase;
  final SubmitAnswerUseCase _submitAnswerUseCase;
  final SubmitExamUseCase _submitExamUseCase;
  final UpdateExamSessionUseCase _updateExamSessionUseCase;
  final AbandonExamSessionUseCase _abandonExamSessionUseCase;

  Timer? _timer;
  StreamSubscription? _timerSubscription;

  ExamSessionBloc({
    required StartExamSessionUseCase startExamSessionUseCase,
    required GetExamSessionUseCase getExamSessionUseCase,
    required SubmitAnswerUseCase submitAnswerUseCase,
    required SubmitExamUseCase submitExamUseCase,
    required UpdateExamSessionUseCase updateExamSessionUseCase,
    required AbandonExamSessionUseCase abandonExamSessionUseCase,
  })
      : _startExamSessionUseCase = startExamSessionUseCase,
        _getExamSessionUseCase = getExamSessionUseCase,
        _submitAnswerUseCase = submitAnswerUseCase,
        _submitExamUseCase = submitExamUseCase,
        _updateExamSessionUseCase = updateExamSessionUseCase,
        _abandonExamSessionUseCase = abandonExamSessionUseCase,
        super(const ExamSessionInitial()) {
    on<StartExamSessionEvent>(_onStartExamSession);
    on<LoadExamSessionEvent>(_onLoadExamSession);
    on<NextQuestionEvent>(_onNextQuestion);
    on<PreviousQuestionEvent>(_onPreviousQuestion);
    on<NavigateToQuestionEvent>(_onNavigateToQuestion);
    on<SubmitAnswerEvent>(_onSubmitAnswer);
    on<MarkForReviewEvent>(_onMarkForReview);
    on<SkipQuestionEvent>(_onSkipQuestion);
    on<PauseExamSessionEvent>(_onPauseExamSession);
    on<ResumeExamSessionEvent>(_onResumeExamSession);
    on<SubmitExamEvent>(_onSubmitExam);
    on<AbandonExamSessionEvent>(_onAbandonExamSession);
    on<UpdateSessionProgressEvent>(_onUpdateSessionProgress);
    on<SyncSessionDataEvent>(_onSyncSessionData);
    on<TimerTickEvent>(_onTimerTick);
    on<TimerExpiredEvent>(_onTimerExpired);
    on<RetryExamSessionEvent>(_onRetryExamSession);
    on<ClearErrorEvent>(_onClearError);
    on<ShowQuestionExplanationEvent>(_onShowQuestionExplanation);
    on<ToggleQuestionPaletteEvent>(_onToggleQuestionPalette);
    on<UpdateSessionSettingsEvent>(_onUpdateSessionSettings);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timerSubscription?.cancel();
    return super.close();
  }

  /// Start a new exam session
  Future<void> _onStartExamSession(
    StartExamSessionEvent event,
    Emitter<ExamSessionState> emit,
  ) async {
    emit(const ExamSessionLoading(isStarting: true, message: 'Starting exam session...'));

    final result = await _startExamSessionUseCase(
      StartExamSessionParams(
        examId: event.examId,
        settings: event.settings,
      ),
    );

    result.fold(
      (failure) => emit(ExamSessionError(
        message: _mapFailureToMessage(failure),
        errorCode: failure.runtimeType.toString(),
        occurredAt: DateTime.now(),
      )),
      (session) {
        if (session.questions.isNotEmpty) {
          _startTimer(session.remainingTimeSeconds);
          emit(ExamSessionActive(
            session: session,
            currentQuestion: session.questions[session.currentQuestionIndex],
            answers: session.answers,
            remainingTimeSeconds: session.remainingTimeSeconds,
            lastUpdated: DateTime.now(),
          ));
        } else {
          emit(ExamSessionError(
            message: 'No questions found in exam session',
            occurredAt: DateTime.now(),
          ));
        }
      },
    );
  }

  /// Load an existing exam session
  Future<void> _onLoadExamSession(
    LoadExamSessionEvent event,
    Emitter<ExamSessionState> emit,
  ) async {
    emit(const ExamSessionLoading(message: 'Loading exam session...'));

    final result = await _getExamSessionUseCase(
      GetExamSessionParams(sessionId: event.sessionId),
    );

    result.fold(
      (failure) => emit(ExamSessionError(
        message: _mapFailureToMessage(failure),
        errorCode: failure.runtimeType.toString(),
        occurredAt: DateTime.now(),
      )),
      (session) {
        if (session.status == ExamSessionStatus.completed) {
          _emitCompletedState(session, emit);
        } else if (session.status == ExamSessionStatus.abandoned) {
          emit(ExamSessionAbandoned(
            sessionId: session.sessionId,
            reason: 'Session was previously abandoned',
            abandonedAt: session.submittedAt ?? DateTime.now(),
          ));
        } else {
          _startTimer(session.remainingTimeSeconds);
          emit(ExamSessionActive(
            session: session,
            currentQuestion: session.questions[session.currentQuestionIndex],
            answers: session.answers,
            remainingTimeSeconds: session.remainingTimeSeconds,
            isPaused: session.status == ExamSessionStatus.paused,
            lastUpdated: DateTime.now(),
          ));
        }
      },
    );
  }

  /// Navigate to next question
  void _onNextQuestion(
    NextQuestionEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      if (currentState.canNavigateNext) {
        final newIndex = currentState.session.currentQuestionIndex + 1;
        final updatedSession = currentState.session.copyWith(
          currentQuestionIndex: newIndex,
        );
        emit(currentState.copyWith(
          session: updatedSession,
          currentQuestion: updatedSession.questions[newIndex],
          lastUpdated: DateTime.now(),
        ));
      }
    }
  }

  /// Navigate to previous question
  void _onPreviousQuestion(
    PreviousQuestionEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      if (currentState.canNavigatePrevious) {
        final newIndex = currentState.session.currentQuestionIndex - 1;
        final updatedSession = currentState.session.copyWith(
          currentQuestionIndex: newIndex,
        );
        emit(currentState.copyWith(
          session: updatedSession,
          currentQuestion: updatedSession.questions[newIndex],
          lastUpdated: DateTime.now(),
        ));
      }
    }
  }

  /// Navigate to specific question
  void _onNavigateToQuestion(
    NavigateToQuestionEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      if (event.questionIndex >= 0 && event.questionIndex < currentState.session.questions.length) {
        final updatedSession = currentState.session.copyWith(
          currentQuestionIndex: event.questionIndex,
        );
        emit(currentState.copyWith(
          session: updatedSession,
          currentQuestion: updatedSession.questions[event.questionIndex],
          lastUpdated: DateTime.now(),
        ));
      }
    }
  }

  /// Submit an answer
  Future<void> _onSubmitAnswer(
    SubmitAnswerEvent event,
    Emitter<ExamSessionState> emit,
  ) async {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      emit(currentState.copyWith(isSubmittingAnswer: true));

      final result = await _submitAnswerUseCase(
        SubmitAnswerParams(
          sessionId: currentState.session.sessionId,
          answer: event.answer,
        ),
      );

      result.fold(
        (failure) => emit(currentState.copyWith(
          isSubmittingAnswer: false,
          currentError: _mapFailureToMessage(failure),
        )),
        (answer) {
          // Update answers list
          final updatedAnswers = List<Answer>.from(currentState.answers);
          final existingIndex = updatedAnswers.indexWhere(
            (a) => a.questionId == answer.questionId,
          );
          
          if (existingIndex >= 0) {
            updatedAnswers[existingIndex] = answer;
          } else {
            updatedAnswers.add(answer);
          }

          emit(currentState.copyWith(
            answers: updatedAnswers,
            isSubmittingAnswer: false,
            currentError: null,
            lastUpdated: DateTime.now(),
          ));

          // Auto-navigate to next question if enabled
          if (event.autoNavigate && currentState.canNavigateNext) {
            add(const NextQuestionEvent());
          }
        },
      );
    }
  }

  /// Mark question for review
  void _onMarkForReview(
    MarkForReviewEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      final updatedAnswers = List<Answer>.from(currentState.answers);
      
      final existingIndex = updatedAnswers.indexWhere(
        (a) => a.questionId == event.questionId,
      );
      
      if (existingIndex >= 0) {
        updatedAnswers[existingIndex] = updatedAnswers[existingIndex].copyWith(
          isMarkedForReview: event.isMarked,
        );
      } else {
        // Create a new answer marked for review
        updatedAnswers.add(Answer.markedForReview(
          questionId: event.questionId,
        ));
      }

      emit(currentState.copyWith(
        answers: updatedAnswers,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Skip current question
  void _onSkipQuestion(
    SkipQuestionEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      final updatedAnswers = List<Answer>.from(currentState.answers);
      
      final existingIndex = updatedAnswers.indexWhere(
        (a) => a.questionId == event.questionId,
      );
      
      if (existingIndex >= 0) {
        updatedAnswers[existingIndex] = Answer.skipped(
          questionId: event.questionId,
        );
      } else {
        updatedAnswers.add(Answer.skipped(
          questionId: event.questionId,
        ));
      }

      emit(currentState.copyWith(
        answers: updatedAnswers,
        lastUpdated: DateTime.now(),
      ));

      // Auto-navigate to next question
      if (currentState.canNavigateNext) {
        add(const NextQuestionEvent());
      }
    }
  }

  /// Pause exam session
  void _onPauseExamSession(
    PauseExamSessionEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      _timer?.cancel();
      
      emit(currentState.copyWith(
        isPaused: true,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Resume exam session
  void _onResumeExamSession(
    ResumeExamSessionEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      _startTimer(currentState.remainingTimeSeconds);
      
      emit(currentState.copyWith(
        isPaused: false,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Submit entire exam
  Future<void> _onSubmitExam(
    SubmitExamEvent event,
    Emitter<ExamSessionState> emit,
  ) async {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      emit(const ExamSessionLoading(isSubmitting: true, message: 'Submitting exam...'));
      
      _timer?.cancel();

      final result = await _submitExamUseCase(
        SubmitExamParams(
          sessionId: currentState.session.sessionId,
          forceSubmit: event.forceSubmit,
        ),
      );

      result.fold(
        (failure) => emit(ExamSessionError(
          message: _mapFailureToMessage(failure),
          errorCode: failure.runtimeType.toString(),
          previousState: currentState,
          occurredAt: DateTime.now(),
        )),
        (session) => _emitCompletedState(session, emit),
      );
    }
  }

  /// Abandon exam session
  Future<void> _onAbandonExamSession(
    AbandonExamSessionEvent event,
    Emitter<ExamSessionState> emit,
  ) async {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      _timer?.cancel();

      final result = await _abandonExamSessionUseCase(
        AbandonExamSessionParams(
          sessionId: currentState.session.sessionId,
          reason: event.reason,
        ),
      );

      result.fold(
        (failure) => emit(ExamSessionError(
          message: _mapFailureToMessage(failure),
          errorCode: failure.runtimeType.toString(),
          previousState: currentState,
          occurredAt: DateTime.now(),
        )),
        (_) => emit(ExamSessionAbandoned(
          sessionId: currentState.session.sessionId,
          reason: event.reason,
          abandonedAt: DateTime.now(),
        )),
      );
    }
  }

  /// Update session progress
  Future<void> _onUpdateSessionProgress(
    UpdateSessionProgressEvent event,
    Emitter<ExamSessionState> emit,
  ) async {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      emit(currentState.copyWith(isSyncing: true));

      final result = await _updateExamSessionUseCase(
        UpdateExamSessionParams(
          sessionId: currentState.session.sessionId,
          updates: event.updates,
        ),
      );

      result.fold(
        (failure) => emit(currentState.copyWith(
          isSyncing: false,
          currentError: _mapFailureToMessage(failure),
        )),
        (session) => emit(currentState.copyWith(
          session: session,
          isSyncing: false,
          currentError: null,
          lastUpdated: DateTime.now(),
        )),
      );
    }
  }

  /// Sync session data
  void _onSyncSessionData(
    SyncSessionDataEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    // Implementation for syncing session data
    // This could involve syncing answers, progress, etc.
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      emit(currentState.copyWith(isSyncing: true));
      
      // Simulate sync completion
      Future.delayed(const Duration(seconds: 1), () {
        if (state is ExamSessionActive) {
          emit((state as ExamSessionActive).copyWith(
            isSyncing: false,
            lastUpdated: DateTime.now(),
          ));
        }
      });
    }
  }

  /// Handle timer tick
  void _onTimerTick(
    TimerTickEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      if (!currentState.isPaused) {
        emit(currentState.copyWith(
          remainingTimeSeconds: event.remainingSeconds,
          lastUpdated: DateTime.now(),
        ));
      }
    }
  }

  /// Handle timer expiry
  void _onTimerExpired(
    TimerExpiredEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    _timer?.cancel();
    add(const SubmitExamEvent(forceSubmit: true));
  }

  /// Retry after error
  void _onRetryExamSession(
    RetryExamSessionEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionError) {
      final errorState = state as ExamSessionError;
      if (errorState.previousState != null) {
        emit(errorState.previousState!);
      } else {
        emit(const ExamSessionInitial());
      }
    }
  }

  /// Clear error state
  void _onClearError(
    ClearErrorEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      emit(currentState.clearError());
    }
  }

  /// Show question explanation
  void _onShowQuestionExplanation(
    ShowQuestionExplanationEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    // This could trigger a UI change to show explanation
    // Implementation depends on UI requirements
  }

  /// Toggle question palette visibility
  void _onToggleQuestionPalette(
    ToggleQuestionPaletteEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      emit(currentState.copyWith(
        isQuestionPaletteVisible: !currentState.isQuestionPaletteVisible,
      ));
    }
  }

  /// Update session settings
  void _onUpdateSessionSettings(
    UpdateSessionSettingsEvent event,
    Emitter<ExamSessionState> emit,
  ) {
    if (state is ExamSessionActive) {
      final currentState = state as ExamSessionActive;
      final updatedSession = currentState.session.copyWith(
        settings: {...currentState.session.settings ?? {}, ...event.settings},
      );
      emit(currentState.copyWith(
        session: updatedSession,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Start the exam timer
  void _startTimer(int initialSeconds) {
    _timer?.cancel();
    
    int remainingSeconds = initialSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        add(TimerTickEvent(remainingSeconds: remainingSeconds));
      } else {
        timer.cancel();
        add(const TimerExpiredEvent());
      }
    });
  }

  /// Emit completed state with calculated results
  void _emitCompletedState(ExamSession session, Emitter<ExamSessionState> emit) {
    final answers = session.answers;
    final totalScore = answers.fold<int>(0, (sum, answer) => sum + answer.score);
    final maxScore = session.questions.fold<int>(0, (sum, question) => sum + question.marks);
    final percentage = maxScore > 0 ? (totalScore / maxScore) * 100 : 0.0;
    final isPassed = session.exam?.passingScore != null 
        ? percentage >= session.exam!.passingScore 
        : false;

    emit(ExamSessionCompleted(
      session: session,
      answers: answers,
      totalScore: totalScore,
      maxScore: maxScore,
      percentage: percentage,
      isPassed: isPassed,
      completedAt: session.submittedAt ?? DateTime.now(),
    ));
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again.';
      case NetworkFailure:
        return 'Network connection error. Please check your internet connection.';
      case CacheFailure:
        return 'Local storage error occurred.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}