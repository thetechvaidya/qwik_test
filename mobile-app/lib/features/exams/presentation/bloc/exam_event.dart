import 'package:equatable/equatable.dart';
import '../../domain/entities/exam.dart';

/// Base class for all exam events
abstract class ExamEvent extends Equatable {
  const ExamEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load exams with optional filters
class LoadExamsEvent extends ExamEvent {
  final String? categoryId;
  final String? difficulty;
  final String? examType;
  final bool? isActive;
  final String? sortBy;
  final String? sortOrder;
  final bool refresh;

  const LoadExamsEvent({
    this.categoryId,
    this.difficulty,
    this.examType,
    this.isActive,
    this.sortBy,
    this.sortOrder,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [
        categoryId,
        difficulty,
        examType,
        isActive,
        sortBy,
        sortOrder,
        refresh,
      ];
}

/// Event to load more exams (pagination)
class LoadMoreExamsEvent extends ExamEvent {
  const LoadMoreExamsEvent();
}

/// Event to refresh exams list
class RefreshExamsEvent extends ExamEvent {
  const RefreshExamsEvent();
}

/// Event to load exam details
class LoadExamDetailEvent extends ExamEvent {
  final String examId;
  final bool forceRefresh;

  const LoadExamDetailEvent({
    required this.examId,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [examId, forceRefresh];
}

/// Event to load categories
class LoadCategoriesEvent extends ExamEvent {
  final bool rootOnly;
  final bool refresh;

  const LoadCategoriesEvent({
    this.rootOnly = false,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [rootOnly, refresh];
}



/// Event to search exams
class SearchExamsEvent extends ExamEvent {
  final String query;
  final String? categoryId;
  final String? difficulty;
  final String? examType;
  final int? minDuration;
  final int? maxDuration;
  final bool? isActive;
  final bool refresh;

  const SearchExamsEvent({
    required this.query,
    this.categoryId,
    this.difficulty,
    this.examType,
    this.minDuration,
    this.maxDuration,
    this.isActive,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [
        query,
        categoryId,
        difficulty,
        examType,
        minDuration,
        maxDuration,
        isActive,
        refresh,
      ];
}

/// Event to clear search results
class ClearSearchEvent extends ExamEvent {
  const ClearSearchEvent();
}

/// Event to apply filters
class ApplyFiltersEvent extends ExamEvent {
  final String? categoryId;
  final String? difficulty;
  final String? examType;
  final bool? isActive;
  final String? sortBy;
  final String? sortOrder;

  const ApplyFiltersEvent({
    this.categoryId,
    this.difficulty,
    this.examType,
    this.isActive,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [
        categoryId,
        difficulty,
        examType,
        isActive,
        sortBy,
        sortOrder,
      ];
}

/// Event to clear all filters
class ClearFiltersEvent extends ExamEvent {
  const ClearFiltersEvent();
}

/// Event to toggle exam favorite status
class ToggleExamFavoriteEvent extends ExamEvent {
  final String examId;
  final bool isFavorite;

  const ToggleExamFavoriteEvent({
    required this.examId,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [examId, isFavorite];
}

/// Event to start an exam
class StartExamEvent extends ExamEvent {
  final String examId;

  const StartExamEvent({required this.examId});

  @override
  List<Object?> get props => [examId];
}

/// Event to resume an exam
class ResumeExamEvent extends ExamEvent {
  final String examId;

  const ResumeExamEvent({required this.examId});

  @override
  List<Object?> get props => [examId];
}

/// Event to retry loading after error
class RetryLoadingEvent extends ExamEvent {
  const RetryLoadingEvent();
}

/// Event to update exam progress
class UpdateExamProgressEvent extends ExamEvent {
  final String examId;
  final int questionsAnswered;
  final int correctAnswers;
  final int timeSpent;
  final bool isCompleted;

  const UpdateExamProgressEvent({
    required this.examId,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.timeSpent,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [
        examId,
        questionsAnswered,
        correctAnswers,
        timeSpent,
        isCompleted,
      ];
}

/// Event to change sorting
class ChangeSortingEvent extends ExamEvent {
  final String sortBy;
  final String sortOrder;

  const ChangeSortingEvent({
    required this.sortBy,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [sortBy, sortOrder];
}

/// Event to change view mode (list/grid)
class ChangeViewModeEvent extends ExamEvent {
  final ExamViewMode viewMode;

  const ChangeViewModeEvent({required this.viewMode});

  @override
  List<Object?> get props => [viewMode];
}

/// Enum for exam view modes
enum ExamViewMode {
  list,
  grid,
}

/// Extension for ExamViewMode
extension ExamViewModeExtension on ExamViewMode {
  String get displayName {
    switch (this) {
      case ExamViewMode.list:
        return 'List View';
      case ExamViewMode.grid:
        return 'Grid View';
    }
  }

  String get iconName {
    switch (this) {
      case ExamViewMode.list:
        return 'list';
      case ExamViewMode.grid:
        return 'grid_view';
    }
  }
}