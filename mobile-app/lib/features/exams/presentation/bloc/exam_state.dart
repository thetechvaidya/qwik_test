import 'package:equatable/equatable.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/exam.dart';
import 'exam_event.dart';

/// Base class for all exam states
abstract class ExamState extends Equatable {
  const ExamState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ExamInitial extends ExamState {
  const ExamInitial();
}

/// Loading state
class ExamLoading extends ExamState {
  final bool isRefresh;
  final bool isLoadingMore;

  const ExamLoading({
    this.isRefresh = false,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [isRefresh, isLoadingMore];
}

/// Loaded state with exam data
class ExamLoaded extends ExamState {
  final List<Exam> exams;
  final List<Category> categories;

  final List<Exam> searchResults;
  final PaginationState paginationState;
  final ExamFilters filters;
  final ExamSorting sorting;
  final ExamViewMode viewMode;
  final String? searchQuery;
  final bool isSearching;
  final bool hasReachedMax;
  final DateTime lastUpdated;

  const ExamLoaded({
    this.exams = const [],
    this.categories = const [],
    this.searchResults = const [],
    this.paginationState = const PaginationState(),
    this.filters = const ExamFilters(),
    this.sorting = const ExamSorting(),
    this.viewMode = ExamViewMode.list,
    this.searchQuery,
    this.isSearching = false,
    this.hasReachedMax = false,
    required this.lastUpdated,
  });

  /// Create a copy with updated properties
  ExamLoaded copyWith({
    List<Exam>? exams,
    List<Category>? categories,
    List<Exam>? searchResults,
    PaginationState? paginationState,
    ExamFilters? filters,
    ExamSorting? sorting,
    ExamViewMode? viewMode,
    String? searchQuery,
    bool? isSearching,
    bool? hasReachedMax,
    DateTime? lastUpdated,
  }) {
    return ExamLoaded(
      exams: exams ?? this.exams,
      categories: categories ?? this.categories,
      searchResults: searchResults ?? this.searchResults,
      paginationState: paginationState ?? this.paginationState,
      filters: filters ?? this.filters,
      sorting: sorting ?? this.sorting,
      viewMode: viewMode ?? this.viewMode,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Clear search results
  ExamLoaded clearSearch() {
    return copyWith(
      searchResults: [],
      searchQuery: null,
      isSearching: false,
    );
  }

  /// Clear filters
  ExamLoaded clearFilters() {
    return copyWith(
      filters: const ExamFilters(),
      paginationState: const PaginationState(),
    );
  }

  /// Get current display list based on search state
  List<Exam> get currentExams {
    return isSearching ? searchResults : exams;
  }

  /// Check if any filters are applied
  bool get hasFilters => filters.hasFilters;

  /// Check if search is active
  bool get hasActiveSearch => searchQuery != null && searchQuery!.isNotEmpty;

  @override
  List<Object?> get props => [
        exams,
        categories,
        searchResults,
        paginationState,
        filters,
        sorting,
        viewMode,
        searchQuery,
        isSearching,
        hasReachedMax,
        lastUpdated,
      ];
}

/// Error state
class ExamError extends ExamState {
  final String message;
  final String? errorCode;
  final bool canRetry;
  final ExamLoaded? previousState;

  const ExamError({
    required this.message,
    this.errorCode,
    this.canRetry = true,
    this.previousState,
  });

  @override
  List<Object?> get props => [message, errorCode, canRetry, previousState];
}

/// Exam detail loading state
class ExamDetailLoading extends ExamState {
  final String examId;

  const ExamDetailLoading({required this.examId});

  @override
  List<Object?> get props => [examId];
}

/// Exam detail loaded state
class ExamDetailLoaded extends ExamState {
  final Exam exam;
  final DateTime lastUpdated;

  const ExamDetailLoaded({
    required this.exam,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [exam, lastUpdated];
}

/// Exam detail error state
class ExamDetailError extends ExamState {
  final String examId;
  final String message;
  final String? errorCode;
  final bool canRetry;

  const ExamDetailError({
    required this.examId,
    required this.message,
    this.errorCode,
    this.canRetry = true,
  });

  @override
  List<Object?> get props => [examId, message, errorCode, canRetry];
}

/// Exam filters class
class ExamFilters extends Equatable {
  final String? categoryId;
  final String? difficulty;
  final String? examType;
  final bool? isActive;
  final int? minDuration;
  final int? maxDuration;

  const ExamFilters({
    this.categoryId,
    this.difficulty,
    this.examType,
    this.isActive,
    this.minDuration,
    this.maxDuration,
  });

  /// Create a copy with updated filters
  ExamFilters copyWith({
    String? categoryId,
    String? difficulty,
    String? examType,
    bool? isActive,
    int? minDuration,
    int? maxDuration,
  }) {
    return ExamFilters(
      categoryId: categoryId ?? this.categoryId,
      difficulty: difficulty ?? this.difficulty,
      examType: examType ?? this.examType,
      isActive: isActive ?? this.isActive,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
    );
  }

  /// Clear all filters
  ExamFilters clear() {
    return const ExamFilters();
  }

  /// Check if any filters are applied
  bool get hasFilters {
    return categoryId != null ||
        difficulty != null ||
        examType != null ||
        isActive != null ||
        minDuration != null ||
        maxDuration != null;
  }

  /// Get filter count
  int get filterCount {
    int count = 0;
    if (categoryId != null) count++;
    if (difficulty != null) count++;
    if (examType != null) count++;
    if (isActive != null) count++;
    if (minDuration != null) count++;
    if (maxDuration != null) count++;
    return count;
  }

  /// Convert to map for API calls
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (categoryId != null) map['categoryId'] = categoryId;
    if (difficulty != null) map['difficulty'] = difficulty;
    if (examType != null) map['examType'] = examType;
    if (isActive != null) map['isActive'] = isActive;
    if (minDuration != null) map['minDuration'] = minDuration;
    if (maxDuration != null) map['maxDuration'] = maxDuration;
    return map;
  }

  @override
  List<Object?> get props => [
        categoryId,
        difficulty,
        examType,
        isActive,
        minDuration,
        maxDuration,
      ];
}

/// Exam sorting class
class ExamSorting extends Equatable {
  final String sortBy;
  final String sortOrder;

  const ExamSorting({
    this.sortBy = 'createdAt',
    this.sortOrder = 'desc',
  });

  /// Create a copy with updated sorting
  ExamSorting copyWith({
    String? sortBy,
    String? sortOrder,
  }) {
    return ExamSorting(
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Toggle sort order
  ExamSorting toggleOrder() {
    return copyWith(
      sortOrder: sortOrder == 'asc' ? 'desc' : 'asc',
    );
  }

  /// Check if sorting is ascending
  bool get isAscending => sortOrder == 'asc';

  /// Check if sorting is descending
  bool get isDescending => sortOrder == 'desc';

  /// Get display name for sort field
  String get sortByDisplayName {
    switch (sortBy) {
      case 'title':
        return 'Title';
      case 'difficulty':
        return 'Difficulty';
      case 'duration':
        return 'Duration';
      case 'totalQuestions':
        return 'Questions';
      case 'createdAt':
        return 'Date Created';
      case 'updatedAt':
        return 'Last Updated';
      case 'popularity':
        return 'Popularity';
      default:
        return 'Date Created';
    }
  }

  @override
  List<Object?> get props => [sortBy, sortOrder];
}

/// Available sort options
class SortOption {
  final String value;
  final String displayName;
  final String icon;

  const SortOption({
    required this.value,
    required this.displayName,
    required this.icon,
  });

  static const List<SortOption> availableOptions = [
    SortOption(
      value: 'createdAt',
      displayName: 'Date Created',
      icon: 'calendar_today',
    ),
    SortOption(
      value: 'title',
      displayName: 'Title',
      icon: 'sort_by_alpha',
    ),
    SortOption(
      value: 'difficulty',
      displayName: 'Difficulty',
      icon: 'trending_up',
    ),
    SortOption(
      value: 'duration',
      displayName: 'Duration',
      icon: 'timer',
    ),
    SortOption(
      value: 'totalQuestions',
      displayName: 'Questions',
      icon: 'quiz',
    ),
    SortOption(
      value: 'popularity',
      displayName: 'Popularity',
      icon: 'star',
    ),
  ];
}