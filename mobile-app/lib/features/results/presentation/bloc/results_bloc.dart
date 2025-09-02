import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_exam_results.dart';
import '../../domain/usecases/submit_exam_result.dart';
import '../../domain/usecases/get_question_results.dart';
import '../../domain/usecases/get_performance_analytics.dart';
import '../../domain/usecases/get_exam_analysis.dart';
import '../../domain/usecases/get_study_recommendations.dart';
import '../../domain/repositories/results_repository.dart';
import '../../domain/entities/exam_result.dart';
import 'results_event.dart';
import 'results_state.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  final GetExamResults getExamResults;
  final SubmitExamResult submitExamResult;
  final GetQuestionResults getQuestionResults;
  final GetPerformanceAnalytics getPerformanceAnalytics;
  final GetExamAnalysis getExamAnalysis;
  final GetStudyRecommendations getStudyRecommendations;
  final ResultsRepository resultsRepository;

  List<ExamResult> _allExamResults = [];

  ResultsBloc({
    required this.getExamResults,
    required this.submitExamResult,
    required this.getQuestionResults,
    required this.getPerformanceAnalytics,
    required this.getExamAnalysis,
    required this.getStudyRecommendations,
    required this.resultsRepository,
  }) : super(const ResultsInitial()) {
    on<LoadExamResults>(_onLoadExamResults);
    on<SubmitExamResultEvent>(_onSubmitExamResult);
    on<LoadQuestionResults>(_onLoadQuestionResults);
    on<LoadPerformanceAnalytics>(_onLoadPerformanceAnalytics);
    on<LoadExamAnalysis>(_onLoadExamAnalysis);
    on<LoadStudyRecommendations>(_onLoadStudyRecommendations);
    on<RefreshResults>(_onRefreshResults);
    on<ClearResultsCache>(_onClearResultsCache);
    on<FilterExamResults>(_onFilterExamResults);
    on<SortExamResults>(_onSortExamResults);
  }

  Future<void> _onLoadExamResults(
    LoadExamResults event,
    Emitter<ResultsState> emit,
  ) async {
    emit(const ExamResultsLoading());

    final result = await getExamResults(
      GetExamResultsParams(
        userId: event.userId,
        examId: event.examId,
        subject: event.subject,
        startDate: event.startDate,
        endDate: event.endDate,
        limit: event.limit,
        offset: event.offset,
      ),
    );

    result.fold(
      (failure) => emit(ExamResultsError(message: _mapFailureToMessage(failure))),
      (examResults) {
        _allExamResults = examResults;
        emit(ExamResultsLoaded(examResults: examResults));
      },
    );
  }

  Future<void> _onSubmitExamResult(
    SubmitExamResultEvent event,
    Emitter<ResultsState> emit,
  ) async {
    emit(const ExamResultSubmitting());

    final result = await submitExamResult(
      SubmitExamResultParams(
        userId: event.userId,
        examResult: event.examResult,
      ),
    );

    result.fold(
      (failure) => emit(ExamResultSubmissionError(message: _mapFailureToMessage(failure))),
      (examResult) {
        _allExamResults.insert(0, examResult); // Add to beginning of list
        emit(ExamResultSubmitted(examResult: examResult));
      },
    );
  }

  Future<void> _onLoadQuestionResults(
    LoadQuestionResults event,
    Emitter<ResultsState> emit,
  ) async {
    emit(const QuestionResultsLoading());

    final result = await getQuestionResults(
      GetQuestionResultsParams(
        userId: event.userId,
        examId: event.examId,
        questionId: event.questionId,
        topic: event.topic,
        difficulty: event.difficulty,
        isCorrect: event.isCorrect,
        limit: event.limit,
        offset: event.offset,
      ),
    );

    result.fold(
      (failure) => emit(QuestionResultsError(message: _mapFailureToMessage(failure))),
      (questionResults) => emit(QuestionResultsLoaded(questionResults: questionResults)),
    );
  }

  Future<void> _onLoadPerformanceAnalytics(
    LoadPerformanceAnalytics event,
    Emitter<ResultsState> emit,
  ) async {
    emit(const PerformanceAnalyticsLoading());

    final result = await getPerformanceAnalytics(
      GetPerformanceAnalyticsParams(
        userId: event.userId,
        period: event.period,
        subject: event.subject,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    result.fold(
      (failure) => emit(PerformanceAnalyticsError(message: _mapFailureToMessage(failure))),
      (analytics) => emit(PerformanceAnalyticsLoaded(analytics: analytics)),
    );
  }

  Future<void> _onLoadExamAnalysis(
    LoadExamAnalysis event,
    Emitter<ResultsState> emit,
  ) async {
    emit(const ExamAnalysisLoading());

    final result = await getExamAnalysis(
      GetExamAnalysisParams(
        userId: event.userId,
        examId: event.examId,
      ),
    );

    result.fold(
      (failure) => emit(ExamAnalysisError(message: _mapFailureToMessage(failure))),
      (analysis) => emit(ExamAnalysisLoaded(analysis: analysis)),
    );
  }

  Future<void> _onLoadStudyRecommendations(
    LoadStudyRecommendations event,
    Emitter<ResultsState> emit,
  ) async {
    emit(const StudyRecommendationsLoading());

    final result = await getStudyRecommendations(
      GetStudyRecommendationsParams(
        userId: event.userId,
        subject: event.subject,
        weakAreas: event.weakAreas,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) => emit(StudyRecommendationsError(message: _mapFailureToMessage(failure))),
      (recommendations) => emit(StudyRecommendationsLoaded(recommendations: recommendations)),
    );
  }

  Future<void> _onRefreshResults(
    RefreshResults event,
    Emitter<ResultsState> emit,
  ) async {
    if (state is ExamResultsLoaded) {
      final currentState = state as ExamResultsLoaded;
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(const ExamResultsLoading());
    }

    // Clear cache and refresh data
    await resultsRepository.clearCache();
    
    final result = await getExamResults(
      GetExamResultsParams(userId: event.userId),
    );

    result.fold(
      (failure) {
        if (state is ExamResultsLoaded) {
          final currentState = state as ExamResultsLoaded;
          emit(currentState.copyWith(isRefreshing: false));
          emit(ResultsError(
            message: _mapFailureToMessage(failure),
            previousResults: currentState.examResults,
          ));
        } else {
          emit(ResultsError(message: _mapFailureToMessage(failure)));
        }
      },
      (examResults) {
        _allExamResults = examResults;
        emit(ExamResultsLoaded(
          examResults: examResults,
          isRefreshing: false,
        ));
      },
    );
  }

  Future<void> _onClearResultsCache(
    ClearResultsCache event,
    Emitter<ResultsState> emit,
  ) async {
    await resultsRepository.clearCache();
    emit(const ResultsCacheCleared());
  }

  void _onFilterExamResults(
    FilterExamResults event,
    Emitter<ResultsState> emit,
  ) {
    List<ExamResult> filteredResults = List.from(_allExamResults);
    List<String> filterCriteria = [];

    if (event.subject != null) {
      filteredResults = filteredResults
          .where((result) => result.subject == event.subject)
          .toList();
      filterCriteria.add('Subject: ${event.subject}');
    }

    if (event.startDate != null) {
      filteredResults = filteredResults
          .where((result) => result.completedAt.isAfter(event.startDate!))
          .toList();
      filterCriteria.add('From: ${event.startDate!.toLocal().toString().split(' ')[0]}');
    }

    if (event.endDate != null) {
      filteredResults = filteredResults
          .where((result) => result.completedAt.isBefore(event.endDate!))
          .toList();
      filterCriteria.add('To: ${event.endDate!.toLocal().toString().split(' ')[0]}');
    }

    if (event.minScore != null) {
      filteredResults = filteredResults
          .where((result) => result.score >= event.minScore!)
          .toList();
      filterCriteria.add('Min Score: ${event.minScore}%');
    }

    if (event.maxScore != null) {
      filteredResults = filteredResults
          .where((result) => result.score <= event.maxScore!)
          .toList();
      filterCriteria.add('Max Score: ${event.maxScore}%');
    }

    emit(ExamResultsFiltered(
      filteredResults: filteredResults,
      filterCriteria: filterCriteria.join(', '),
    ));
  }

  void _onSortExamResults(
    SortExamResults event,
    Emitter<ResultsState> emit,
  ) {
    List<ExamResult> sortedResults = List.from(_allExamResults);

    switch (event.sortBy) {
      case 'date':
        sortedResults.sort((a, b) => event.ascending
            ? a.completedAt.compareTo(b.completedAt)
            : b.completedAt.compareTo(a.completedAt));
        break;
      case 'score':
        sortedResults.sort((a, b) => event.ascending
            ? a.score.compareTo(b.score)
            : b.score.compareTo(a.score));
        break;
      case 'subject':
        sortedResults.sort((a, b) => event.ascending
            ? a.subject.compareTo(b.subject)
            : b.subject.compareTo(a.subject));
        break;
    }

    emit(ExamResultsSorted(
      sortedResults: sortedResults,
      sortCriteria: event.sortBy,
      ascending: event.ascending,
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case CacheFailure:
        return 'Cache error occurred. Please refresh the data.';
      case NetworkFailure:
        return 'Network error. Please check your internet connection.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}