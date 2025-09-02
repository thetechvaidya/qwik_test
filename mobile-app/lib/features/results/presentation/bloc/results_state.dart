import 'package:equatable/equatable.dart';
import '../../domain/entities/exam_result.dart';
import '../../domain/entities/question_result.dart';

abstract class ResultsState extends Equatable {
  const ResultsState();

  @override
  List<Object?> get props => [];
}

class ResultsInitial extends ResultsState {
  const ResultsInitial();
}

class ResultsLoading extends ResultsState {
  const ResultsLoading();
}

class ExamResultsLoaded extends ResultsState {
  final List<ExamResult> examResults;
  final bool isRefreshing;
  final String? currentFilter;
  final String? currentSort;

  const ExamResultsLoaded({
    required this.examResults,
    this.isRefreshing = false,
    this.currentFilter,
    this.currentSort,
  });

  ExamResultsLoaded copyWith({
    List<ExamResult>? examResults,
    bool? isRefreshing,
    String? currentFilter,
    String? currentSort,
  }) {
    return ExamResultsLoaded(
      examResults: examResults ?? this.examResults,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentFilter: currentFilter ?? this.currentFilter,
      currentSort: currentSort ?? this.currentSort,
    );
  }

  @override
  List<Object?> get props => [
        examResults,
        isRefreshing,
        currentFilter,
        currentSort,
      ];
}

class ExamResultSubmitted extends ResultsState {
  final ExamResult examResult;

  const ExamResultSubmitted({required this.examResult});

  @override
  List<Object?> get props => [examResult];
}

class QuestionResultsLoaded extends ResultsState {
  final List<QuestionResult> questionResults;

  const QuestionResultsLoaded({required this.questionResults});

  @override
  List<Object?> get props => [questionResults];
}

class PerformanceAnalyticsLoaded extends ResultsState {
  final Map<String, dynamic> analytics;

  const PerformanceAnalyticsLoaded({required this.analytics});

  @override
  List<Object?> get props => [analytics];
}

class ExamAnalysisLoaded extends ResultsState {
  final Map<String, dynamic> analysis;

  const ExamAnalysisLoaded({required this.analysis});

  @override
  List<Object?> get props => [analysis];
}

class StudyRecommendationsLoaded extends ResultsState {
  final Map<String, dynamic> recommendations;

  const StudyRecommendationsLoaded({required this.recommendations});

  @override
  List<Object?> get props => [recommendations];
}

class ResultsError extends ResultsState {
  final String message;
  final List<ExamResult>? previousResults;

  const ResultsError({
    required this.message,
    this.previousResults,
  });

  @override
  List<Object?> get props => [message, previousResults];
}

class ResultsCacheCleared extends ResultsState {
  const ResultsCacheCleared();
}

class ExamResultsFiltered extends ResultsState {
  final List<ExamResult> filteredResults;
  final String filterCriteria;

  const ExamResultsFiltered({
    required this.filteredResults,
    required this.filterCriteria,
  });

  @override
  List<Object?> get props => [filteredResults, filterCriteria];
}

class ExamResultsSorted extends ResultsState {
  final List<ExamResult> sortedResults;
  final String sortCriteria;
  final bool ascending;

  const ExamResultsSorted({
    required this.sortedResults,
    required this.sortCriteria,
    required this.ascending,
  });

  @override
  List<Object?> get props => [sortedResults, sortCriteria, ascending];
}

// Specific loading states for different operations
class ExamResultsLoading extends ResultsState {
  const ExamResultsLoading();
}

class ExamResultSubmitting extends ResultsState {
  const ExamResultSubmitting();
}

class QuestionResultsLoading extends ResultsState {
  const QuestionResultsLoading();
}

class PerformanceAnalyticsLoading extends ResultsState {
  const PerformanceAnalyticsLoading();
}

class ExamAnalysisLoading extends ResultsState {
  const ExamAnalysisLoading();
}

class StudyRecommendationsLoading extends ResultsState {
  const StudyRecommendationsLoading();
}

// Specific error states
class ExamResultsError extends ResultsState {
  final String message;

  const ExamResultsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ExamResultSubmissionError extends ResultsState {
  final String message;

  const ExamResultSubmissionError({required this.message});

  @override
  List<Object?> get props => [message];
}

class QuestionResultsError extends ResultsState {
  final String message;

  const QuestionResultsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PerformanceAnalyticsError extends ResultsState {
  final String message;

  const PerformanceAnalyticsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ExamAnalysisError extends ResultsState {
  final String message;

  const ExamAnalysisError({required this.message});

  @override
  List<Object?> get props => [message];
}

class StudyRecommendationsError extends ResultsState {
  final String message;

  const StudyRecommendationsError({required this.message});

  @override
  List<Object?> get props => [message];
}