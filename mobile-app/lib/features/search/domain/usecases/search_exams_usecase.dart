import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../exams/domain/entities/exam.dart';
import '../../../exams/domain/repositories/exam_repository.dart';
import '../repositories/search_repository.dart';

/// Use case for searching exams with analytics tracking
class SearchExamsUseCase implements UseCase<List<Exam>, SearchExamsParams> {
  final ExamRepository _examRepository;
  final SearchRepository _searchRepository;

  SearchExamsUseCase({
    required ExamRepository examRepository,
    required SearchRepository searchRepository,
  })
      : _examRepository = examRepository,
        _searchRepository = searchRepository;

  @override
  Future<Either<Failure, List<Exam>>> call(SearchExamsParams params) async {
    // Validate search query
    if (params.query.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Search query cannot be empty'));
    }

    try {
      // Perform the search
      final result = await _examRepository.searchExams(
        query: params.query,
        categoryId: params.categoryId,
        difficulty: params.difficulty,
        examType: params.examType,
        minDuration: params.minDuration,
        maxDuration: params.maxDuration,
        isActive: params.isActive,
        page: params.page,
        limit: params.limit,
      );

      return result.fold(
        (failure) => Left(failure),
        (paginatedResponse) async {
          final exams = paginatedResponse.data;
          
          // Save search to history if it returned results
          if (exams.isNotEmpty && params.saveToHistory) {
            await _searchRepository.saveSearchHistory(
              query: params.query,
              categoryId: params.categoryId,
              categoryName: params.categoryName,
              filters: params.toFiltersMap(),
            );
          }

          // Report search analytics (fire and forget)
          _searchRepository.reportSearchAnalytics(
            query: params.query,
            categoryId: params.categoryId,
            resultCount: exams.length,
            hasResults: exams.isNotEmpty,
          );

          return Right(exams);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search exams: ${e.toString()}'));
    }
  }
}

/// Parameters for searching exams
class SearchExamsParams {
  final String query;
  final String? categoryId;
  final String? categoryName;
  final String? difficulty;
  final String? examType;
  final int? minDuration;
  final int? maxDuration;
  final bool? isActive;
  final int page;
  final int limit;
  final bool saveToHistory;

  const SearchExamsParams({
    required this.query,
    this.categoryId,
    this.categoryName,
    this.difficulty,
    this.examType,
    this.minDuration,
    this.maxDuration,
    this.isActive,
    this.page = 1,
    this.limit = 20,
    this.saveToHistory = true,
  });

  /// Create a copy with updated parameters
  SearchExamsParams copyWith({
    String? query,
    String? categoryId,
    String? categoryName,
    String? difficulty,
    String? examType,
    int? minDuration,
    int? maxDuration,
    bool? isActive,
    int? page,
    int? limit,
    bool? saveToHistory,
  }) {
    return SearchExamsParams(
      query: query ?? this.query,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      difficulty: difficulty ?? this.difficulty,
      examType: examType ?? this.examType,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      isActive: isActive ?? this.isActive,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      saveToHistory: saveToHistory ?? this.saveToHistory,
    );
  }

  /// Clear all filters except query
  SearchExamsParams clearFilters() {
    return SearchExamsParams(
      query: query,
      page: 1,
      limit: limit,
      saveToHistory: saveToHistory,
    );
  }

  /// Check if any filters are applied
  bool get hasFilters {
    return categoryId != null ||
        difficulty != null ||
        examType != null ||
        minDuration != null ||
        maxDuration != null ||
        isActive != null;
  }

  /// Check if query is valid for searching
  bool get isValidQuery {
    return query.trim().isNotEmpty && query.trim().length >= 2;
  }

  /// Convert filters to map for storage
  Map<String, dynamic> toFiltersMap() {
    final filters = <String, dynamic>{};
    
    if (difficulty != null) filters['difficulty'] = difficulty;
    if (examType != null) filters['examType'] = examType;
    if (minDuration != null) filters['minDuration'] = minDuration;
    if (maxDuration != null) filters['maxDuration'] = maxDuration;
    if (isActive != null) filters['isActive'] = isActive;
    
    return filters;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is SearchExamsParams &&
        other.query == query &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.difficulty == difficulty &&
        other.examType == examType &&
        other.minDuration == minDuration &&
        other.maxDuration == maxDuration &&
        other.isActive == isActive &&
        other.page == page &&
        other.limit == limit &&
        other.saveToHistory == saveToHistory;
  }

  @override
  int get hashCode {
    return Object.hash(
      query,
      categoryId,
      categoryName,
      difficulty,
      examType,
      minDuration,
      maxDuration,
      isActive,
      page,
      limit,
      saveToHistory,
    );
  }

  @override
  String toString() {
    return 'SearchExamsParams('
        'query: $query, '
        'categoryId: $categoryId, '
        'categoryName: $categoryName, '
        'difficulty: $difficulty, '
        'examType: $examType, '
        'minDuration: $minDuration, '
        'maxDuration: $maxDuration, '
        'isActive: $isActive, '
        'page: $page, '
        'limit: $limit, '
        'saveToHistory: $saveToHistory'
        ')';
  }
}