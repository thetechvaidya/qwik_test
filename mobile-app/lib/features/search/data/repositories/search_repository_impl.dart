import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/data/models/paginated_response.dart';
import '../../domain/entities/search_history.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_datasource.dart';
import '../datasources/search_remote_datasource.dart';
import '../models/search_history_model.dart';

/// Implementation of search repository
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;
  final SearchLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final Uuid _uuid;

  SearchRepositoryImpl({
    required SearchRemoteDataSource remoteDataSource,
    required SearchLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    Uuid? uuid,
  })
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo,
        _uuid = uuid ?? const Uuid();

  @override
  Future<Either<Failure, PaginatedResponse<SearchResult>>> search({
    required String query,
    String? type,
    String? categoryId,
    String? difficulty,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final results = await _remoteDataSource.search(
          query: query,
          type: type,
          categoryId: categoryId,
          difficulty: difficulty,
          page: page,
          limit: limit,
        );
        return Right(results);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchHistory({
    required String query,
    String? categoryId,
    String? categoryName,
    Map<String, dynamic>? filters,
  }) async {
    try {
      // Validate query
      if (query.trim().isEmpty) {
        return const Left(ValidationFailure(message: 'Search query cannot be empty'));
      }

      // Check if history already exists
      final hasHistory = await _localDataSource.hasSearchHistory(query, categoryId: categoryId);
      
      if (hasHistory) {
        // Update frequency
        await _localDataSource.updateSearchHistoryFrequency(query, categoryId);
      } else {
        // Create new history entry
        final searchHistory = SearchHistoryModel(
          id: _uuid.v4(),
          query: query.trim(),
          searchedAt: DateTime.now(),
          frequency: 1,
          categoryId: categoryId,
          categoryName: categoryName,
          filters: filters,
        );
        
        await _localDataSource.saveSearchHistory(searchHistory);
      }

      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SearchHistory>>> getSearchHistory({int? limit}) async {
    try {
      final historyModels = await _localDataSource.getSearchHistory(limit: limit);
      final historyEntities = historyModels.map((model) => model.toEntity()).toList();
      
      return Right(historyEntities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    try {
      await _localDataSource.clearSearchHistory();
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeSearchHistory(String id) async {
    try {
      await _localDataSource.removeSearchHistory(id);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SearchSuggestion>>> getSearchSuggestions({
    String? query,
    int limit = 10,
  }) async {
    try {
      List<SearchSuggestion> allSuggestions = [];

      // Get suggestions from multiple sources
      if (await _networkInfo.isConnected) {
        try {
          // Get remote suggestions
          final remoteSuggestions = await _remoteDataSource.getSearchSuggestions(
            query: query,
            limit: limit,
          );
          
          // Cache remote suggestions
          await _localDataSource.cacheSearchSuggestions(remoteSuggestions);
          
          // Convert to entities
          allSuggestions.addAll(
            remoteSuggestions.map((model) => model.toEntity()),
          );
        } catch (e) {
          // If remote fails, continue with local suggestions
          print('Failed to get remote suggestions: $e');
        }
      }

      // Get cached suggestions if we don't have enough from remote
      if (allSuggestions.length < limit) {
        try {
          final cachedSuggestions = await _localDataSource.getCachedSearchSuggestions(
            query: query,
          );
          
          final cachedEntities = cachedSuggestions.map((model) => model.toEntity());
          
          // Add cached suggestions that aren't already in the list
          for (final cached in cachedEntities) {
            if (!allSuggestions.any((existing) => existing.id == cached.id)) {
              allSuggestions.add(cached);
            }
          }
        } catch (e) {
          print('Failed to get cached suggestions: $e');
        }
      }

      // Get history-based suggestions
      if (query != null && query.isNotEmpty) {
        try {
          final historyModels = await _localDataSource.getSearchHistory(limit: 5);
          
          // Filter history that matches the query
          final matchingHistory = historyModels.where((history) {
            return history.query.toLowerCase().contains(query.toLowerCase()) &&
                history.query.toLowerCase() != query.toLowerCase();
          });
          
          // Convert to suggestions
          final historySuggestions = matchingHistory.map((history) {
            return SearchSuggestion(
              id: 'history_${history.id}',
              text: history.query,
              type: SearchSuggestionType.history,
              popularity: history.frequency,
              categoryId: history.categoryId,
              categoryName: history.categoryName,
            );
          });
          
          // Add history suggestions that aren't already in the list
          for (final historySuggestion in historySuggestions) {
            if (!allSuggestions.any((existing) => 
                existing.text.toLowerCase() == historySuggestion.text.toLowerCase())) {
              allSuggestions.add(historySuggestion);
            }
          }
        } catch (e) {
          print('Failed to get history suggestions: $e');
        }
      }

      // Sort suggestions by relevance and priority
      _sortSuggestions(allSuggestions, query);
      
      // Limit results
      if (allSuggestions.length > limit) {
        allSuggestions = allSuggestions.take(limit).toList();
      }

      return Right(allSuggestions);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getTrendingSearches({int limit = 10}) async {
    try {
      if (await _networkInfo.isConnected) {
        try {
          final trending = await _remoteDataSource.getTrendingSearches(limit: limit);
          return Right(trending);
        } catch (e) {
          // If remote fails, fall back to popular local searches
          return await getPopularSearchQueries(limit: limit);
        }
      } else {
        // No internet, get popular local searches
        return await getPopularSearchQueries(limit: limit);
      }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPopularSearchQueries({int limit = 10}) async {
    try {
      final popularQueries = await _localDataSource.getPopularSearchQueries(limit: limit);
      return Right(popularQueries);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> hasSearchHistory(String query, {String? categoryId}) async {
    try {
      final hasHistory = await _localDataSource.hasSearchHistory(query, categoryId: categoryId);
      return Right(hasHistory);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<void> reportSearchAnalytics({
    required String query,
    String? categoryId,
    int? resultCount,
    bool? hasResults,
  }) async {
    // Fire and forget - don't wait for completion or handle errors
    if (await _networkInfo.isConnected) {
      _remoteDataSource.reportSearchAnalytics(
        query: query,
        categoryId: categoryId,
        resultCount: resultCount,
        hasResults: hasResults,
      ).catchError((e) {
        // Silently handle errors for analytics
        print('Search analytics failed: $e');
      });
    }
  }

  @override
  Future<void> trackSearchAnalytics({
    required String query,
    required int resultCount,
    String? categoryId,
    Map<String, dynamic>? filters,
  }) async {
    // Fire and forget - don't wait for completion or handle errors
    if (await _networkInfo.isConnected) {
      _remoteDataSource.trackSearchAnalytics(
        query: query,
        resultCount: resultCount,
        categoryId: categoryId,
        filters: filters,
      ).catchError((e) {
        // Silently handle errors for analytics
        print('Search analytics tracking failed: $e');
      });
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchSuggestions() async {
    try {
      await _localDataSource.clearSearchSuggestions();
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Sort suggestions by relevance and priority
  void _sortSuggestions(List<SearchSuggestion> suggestions, String? query) {
    suggestions.sort((a, b) {
      if (query != null && query.isNotEmpty) {
        final queryLower = query.toLowerCase();
        
        // Exact matches first
        final aExact = a.text.toLowerCase() == queryLower;
        final bExact = b.text.toLowerCase() == queryLower;
        if (aExact && !bExact) return -1;
        if (!aExact && bExact) return 1;
        
        // Starts with query
        final aStartsWith = a.text.toLowerCase().startsWith(queryLower);
        final bStartsWith = b.text.toLowerCase().startsWith(queryLower);
        if (aStartsWith && !bStartsWith) return -1;
        if (!aStartsWith && bStartsWith) return 1;
        
        // Contains query
        final aContains = a.text.toLowerCase().contains(queryLower);
        final bContains = b.text.toLowerCase().contains(queryLower);
        if (aContains && !bContains) return -1;
        if (!aContains && bContains) return 1;
      }
      
      // Type priority
      final typeComparison = b.type.priority.compareTo(a.type.priority);
      if (typeComparison != 0) return typeComparison;
      
      // Popularity
      return b.popularity.compareTo(a.popularity);
    });
  }

  /// Map exceptions to failures
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else if (exception is UnauthorizedException) {
      return AuthFailure(message: exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        errors: exception.errors,
      );
    } else {
      return ServerFailure(message: 'An unexpected error occurred');
    }
  }
}