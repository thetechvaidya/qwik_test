import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/data/models/paginated_response.dart';
import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

/// Use case for unified search across exams, quizzes, and categories
class SearchUseCase implements UseCase<PaginatedResponse<SearchResult>, SearchParams> {
  final SearchRepository _searchRepository;

  SearchUseCase({
    required SearchRepository searchRepository,
  }) : _searchRepository = searchRepository;

  @override
  Future<Either<Failure, PaginatedResponse<SearchResult>>> call(SearchParams params) async {
    // Validate search query
    if (params.query.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Search query cannot be empty'));
    }

    if (params.query.trim().length < 2) {
      return const Left(ValidationFailure(message: 'Search query must be at least 2 characters'));
    }

    try {
      // Perform the unified search
      final result = await _searchRepository.search(
        query: params.query,
        type: params.type,
        categoryId: params.categoryId,
        difficulty: params.difficulty,
        page: params.page,
        limit: params.limit,
      );

      return result.fold(
        (failure) => Left(failure),
        (paginatedResponse) async {
          final results = paginatedResponse.data;
          
          // Save search to history if it returned results
          if (results.isNotEmpty && params.saveToHistory) {
            await _searchRepository.saveSearchHistory(
              query: params.query,
              categoryId: params.categoryId,
              filters: {
                if (params.type != null) 'type': params.type!,
                if (params.difficulty != null) 'difficulty': params.difficulty!,
              },
            );
          }

          // Track search analytics
          if (params.trackAnalytics) {
            await _searchRepository.trackSearchAnalytics(
              query: params.query,
              resultCount: results.length,
              categoryId: params.categoryId,
              filters: {
                if (params.type != null) 'type': params.type!,
                if (params.difficulty != null) 'difficulty': params.difficulty!,
              },
            );
          }

          return Right(paginatedResponse);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Search failed: ${e.toString()}'));
    }
  }
}

/// Parameters for unified search
class SearchParams {
  final String query;
  final String? type; // 'exam', 'quiz', 'category'
  final String? categoryId;
  final String? difficulty;
  final int page;
  final int limit;
  final bool saveToHistory;
  final bool trackAnalytics;

  const SearchParams({
    required this.query,
    this.type,
    this.categoryId,
    this.difficulty,
    this.page = 1,
    this.limit = 20,
    this.saveToHistory = true,
    this.trackAnalytics = true,
  });

  /// Create copy with updated properties
  SearchParams copyWith({
    String? query,
    String? type,
    String? categoryId,
    String? difficulty,
    int? page,
    int? limit,
    bool? saveToHistory,
    bool? trackAnalytics,
  }) {
    return SearchParams(
      query: query ?? this.query,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      difficulty: difficulty ?? this.difficulty,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      saveToHistory: saveToHistory ?? this.saveToHistory,
      trackAnalytics: trackAnalytics ?? this.trackAnalytics,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchParams &&
        other.query == query &&
        other.type == type &&
        other.categoryId == categoryId &&
        other.difficulty == difficulty &&
        other.page == page &&
        other.limit == limit &&
        other.saveToHistory == saveToHistory &&
        other.trackAnalytics == trackAnalytics;
  }

  @override
  int get hashCode {
    return Object.hash(
      query,
      type,
      categoryId,
      difficulty,
      page,
      limit,
      saveToHistory,
      trackAnalytics,
    );
  }

  @override
  String toString() {
    return 'SearchParams(query: $query, type: $type, categoryId: $categoryId, difficulty: $difficulty, page: $page, limit: $limit, saveToHistory: $saveToHistory, trackAnalytics: $trackAnalytics)';
  }
}