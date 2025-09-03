import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/exam_session_bloc.dart';
import '../../domain/entities/answer.dart';
import '../widgets/exam_header_widget.dart';
import '../widgets/question_content_widget.dart';
import '../widgets/answer_options_widget.dart';
import '../widgets/navigation_controls_widget.dart';
import '../widgets/question_palette_widget.dart';
import '../widgets/exam_timer_widget.dart';
import '../widgets/exam_progress_widget.dart';
import '../widgets/exam_submission_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';

/// Main page for taking an exam session
class ExamTakingPage extends StatefulWidget {
  final String? sessionId;
  final String? examId; // For starting new session

  const ExamTakingPage({
    super.key,
    this.sessionId,
    this.examId,
  }) : assert(sessionId != null || examId != null, 'Either sessionId or examId must be provided');

  @override
  State<ExamTakingPage> createState() => _ExamTakingPageState();
}

class _ExamTakingPageState extends State<ExamTakingPage>
    with WidgetsBindingObserver {
  late ExamSessionBloc _examSessionBloc;
  bool _isPaletteVisible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _examSessionBloc = sl<ExamSessionBloc>();
    
    // Load or start exam session
    if (widget.examId != null) {
      _examSessionBloc.add(StartExamSessionEvent(examId: widget.examId!));
    } else if (widget.sessionId != null) {
      _examSessionBloc.add(LoadExamSessionEvent(sessionId: widget.sessionId!));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _examSessionBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Handle app lifecycle changes for exam session
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _examSessionBloc.add(const PauseExamSessionEvent());
        break;
      case AppLifecycleState.resumed:
        _examSessionBloc.add(const ResumeExamSessionEvent());
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _examSessionBloc,
      child: BlocListener<ExamSessionBloc, ExamSessionState>(
        listener: _handleStateChanges,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          body: BlocBuilder<ExamSessionBloc, ExamSessionState>(
            builder: (context, state) {
              return _buildContent(context, state);
            },
          ),
          endDrawer: _isPaletteVisible ? _buildQuestionPalette() : null,
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ExamSessionState state) {
    if (state is ExamSessionError) {
      _showErrorSnackBar(context, state.message);
    } else if (state is ExamSessionCompleted) {
      _showCompletionDialog(context, state);
    } else if (state is ExamSessionAbandoned) {
      _showAbandonedDialog(context, state);
    }
  }

  Widget _buildContent(BuildContext context, ExamSessionState state) {
    if (state is ExamSessionLoading) {
      return _buildLoadingState();
    } else if (state is ExamSessionError) {
      return _buildErrorState(context, state);
    } else if (state is ExamSessionActive) {
      return _buildActiveExamState(context, state);
    } else if (state is ExamSessionCompleted) {
      return _buildCompletedState(context, state);
    } else if (state is ExamSessionAbandoned) {
      return _buildAbandonedState(context, state);
    }
    
    return _buildInitialState();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading exam session...',
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ExamSessionError state) {
    return Center(
      child: CustomErrorWidget(
        message: state.message,
        onRetry: () {
          _examSessionBloc.add(const RetryExamSessionEvent());
        },
      ),
    );
  }

  Widget _buildActiveExamState(BuildContext context, ExamSessionActive state) {
    return WillPopScope(
      onWillPop: () => _handleBackPress(context, state),
      child: Column(
        children: [
          // Header with timer and progress
          ExamHeaderWidget(
            session: state.session,
            timeRemaining: state.remainingTimeSeconds,
            onPaletteToggle: _toggleQuestionPalette,
            onSubmit: () => _showSubmissionDialog(context, state),
          ),
          
          // Main content area
          Expanded(
            child: Row(
              children: [
                // Main question area
                Expanded(
                  flex: _isPaletteVisible ? 3 : 1,
                  child: _buildQuestionArea(context, state),
                ),
                
                // Question palette (if visible)
                if (_isPaletteVisible)
                  Expanded(
                    flex: 1,
                    child: _buildQuestionPalette(),
                  ),
              ],
            ),
          ),
          
          // Navigation controls
          NavigationControlsWidget(
            session: state.session,
            onPrevious: state.canNavigatePrevious
                ? () => _examSessionBloc.add(const PreviousQuestionEvent())
                : null,
            onNext: state.canNavigateNext
                ? () => _examSessionBloc.add(const NextQuestionEvent())
                : null,
            onSkip: () => _examSessionBloc.add(SkipQuestionEvent(questionId: state.currentQuestion.id)),
            onMarkForReview: () => _examSessionBloc.add(MarkForReviewEvent(
                questionId: state.currentQuestion.id,
                isMarked: !state.isCurrentQuestionMarkedForReview,
            )),
            onClearAnswer: () => _examSessionBloc.add(SubmitAnswerEvent(
                answer: Answer(
                  id: '',
                  questionId: state.currentQuestion.id,
                  selectedOptionIds: [],
                  timeSpent: 0,
                  answeredAt: DateTime.now(),
                ),
                autoNavigate: false,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionArea(BuildContext context, ExamSessionActive state) {
    final currentQuestion = state.currentQuestion;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question progress indicator
          ExamProgressWidget(
            currentIndex: state.session.currentQuestionIndex,
            totalQuestions: state.session.questions.length,
          ),
          
          const SizedBox(height: 16),
          
          // Question content
          QuestionContentWidget(
            question: currentQuestion,
            questionNumber: state.session.currentQuestionIndex + 1,
          ),
          
          const SizedBox(height: 24),
          
          // Answer options
          AnswerOptionsWidget(
            question: currentQuestion,
            selectedAnswer: state.currentAnswer,
            onAnswerSelected: (answer) {
              _examSessionBloc.add(SubmitAnswerEvent(answer: answer));
            },
          ),
          
          const SizedBox(height: 24),
          
          // Question explanation (if available)
          if (currentQuestion.explanation != null)
            _buildExplanation(currentQuestion.explanation!),
        ],
      ),
    );
  }

  Widget _buildExplanation(String explanation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Explanation',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPalette() {
    return BlocBuilder<ExamSessionBloc, ExamSessionState>(
      builder: (context, state) {
        if (state is ExamSessionActive) {
          return QuestionPaletteWidget(
            session: state.session,
            answers: state.answers,
            onQuestionTap: (index) {
              _examSessionBloc.add(NavigateToQuestionEvent(questionIndex: index));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCompletedState(BuildContext context, ExamSessionCompleted state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 80,
            color: AppColors.success,
          ),
          const SizedBox(height: 16),
          Text(
            'Exam Completed!',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your exam has been submitted successfully.',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back to Exams'),
          ),
        ],
      ),
    );
  }

  Widget _buildAbandonedState(BuildContext context, ExamSessionAbandoned state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cancel,
            size: 80,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Exam Abandoned',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.reason ?? 'The exam session was abandoned.',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back to Exams'),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Text(
        'Initializing exam session...',
        style: AppTextStyles.bodyLarge,
      ),
    );
  }

  void _toggleQuestionPalette() {
    setState(() {
      _isPaletteVisible = !_isPaletteVisible;
    });
  }

  Future<bool> _handleBackPress(BuildContext context, ExamSessionActive state) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Exam?'),
        content: const Text(
          'Are you sure you want to exit the exam? Your progress will be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    
    if (shouldExit == true) {
      _examSessionBloc.add(const PauseExamSessionEvent());
    }
    
    return shouldExit ?? false;
  }

  void _showSubmissionDialog(BuildContext context, ExamSessionActive state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ExamSubmissionDialog(
        session: state.session,
        answers: state.answers,
        onSubmit: () {
          Navigator.of(context).pop();
          _examSessionBloc.add(const SubmitExamEvent());
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, ExamSessionCompleted state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Exam Completed'),
        content: const Text('Your exam has been submitted successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Safe navigation back to exams
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              } else {
                context.go(AppRouter.exams);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAbandonedDialog(BuildContext context, ExamSessionAbandoned state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Exam Abandoned'),
        content: Text(state.reason ?? 'The exam session was abandoned.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Safe navigation back to exams
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              } else {
                context.go(AppRouter.exams);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            _examSessionBloc.add(const RetryExamSessionEvent());
          },
        ),
      ),
    );
  }
}