import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/search_history.dart';
import '../entities/search_suggestion.dart';

/// Abstract repository interface for search operations
abstract class SearchRepository {
  /// Save search query to history
  Future<Either<Failure, void>> saveSearchHistory({
    required String query,
    String? categoryId,
    String? categoryName,
    Map<String, dynamic>? filters,
  });

  /// Get search history with optional limit
  Future<Either<Failure, List<SearchHistory>>> getSearchHistory({int? limit});

  /// Clear all search history
  Future<Either<Failure, void>> clearSearchHistory();

  /// Remove specific search history item
  Future<Either<Failure, void>> removeSearchHistory(String id);

  /// Get search suggestions based on query
  Future<Either<Failure, List<SearchSuggestion>>> getSearchSuggestions({
    String? query,
    int limit = 10,
  });

  /// Get trending search queries
  Future<Either<Failure, List<String>>> getTrendingSearches({int limit = 10});

  /// Get popular search queries from local history
  Future<Either<Failure, List<String>>> getPopularSearchQueries({int limit = 10});

  /// Check if search history exists for query
  Future<Either<Failure, bool>> hasSearchHistory(String query, {String? categoryId});

  /// Report search analytics (fire and forget)
  Future<void> reportSearchAnalytics({
    required String query,
    String? categoryId,
    int? resultCount,
    bool? hasResults,
  });

  /// Clear cached search suggestions
  Future<Either<Failure, void>> clearSearchSuggestions();
}