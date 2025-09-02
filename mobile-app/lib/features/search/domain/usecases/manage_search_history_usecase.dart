import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_history.dart';
import '../repositories/search_repository.dart';

/// Use case for managing search history
class ManageSearchHistoryUseCase {
  final SearchRepository _repository;

  ManageSearchHistoryUseCase({required SearchRepository repository})
      : _repository = repository;

  /// Get search history
  Future<Either<Failure, List<SearchHistory>>> getHistory({int? limit}) async {
    return await _repository.getSearchHistory(limit: limit);
  }

  /// Save search to history
  Future<Either<Failure, void>> saveToHistory({
    required String query,
    String? categoryId,
    String? categoryName,
    Map<String, dynamic>? filters,
  }) async {
    return await _repository.saveSearchHistory(
      query: query,
      categoryId: categoryId,
      categoryName: categoryName,
      filters: filters,
    );
  }

  /// Remove specific search history item
  Future<Either<Failure, void>> removeHistoryItem(String id) async {
    return await _repository.removeSearchHistory(id);
  }

  /// Clear all search history
  Future<Either<Failure, void>> clearHistory() async {
    return await _repository.clearSearchHistory();
  }

  /// Check if search history exists
  Future<Either<Failure, bool>> hasHistory(String query, {String? categoryId}) async {
    return await _repository.hasSearchHistory(query, categoryId: categoryId);
  }

  /// Get popular search queries
  Future<Either<Failure, List<String>>> getPopularQueries({int limit = 10}) async {
    return await _repository.getPopularSearchQueries(limit: limit);
  }

  /// Get trending searches
  Future<Either<Failure, List<String>>> getTrendingSearches({int limit = 10}) async {
    return await _repository.getTrendingSearches(limit: limit);
  }
}

/// Use case for getting search history
class GetSearchHistoryUseCase implements UseCase<List<SearchHistory>, GetSearchHistoryParams> {
  final ManageSearchHistoryUseCase _manageSearchHistoryUseCase;

  GetSearchHistoryUseCase({required ManageSearchHistoryUseCase manageSearchHistoryUseCase})
      : _manageSearchHistoryUseCase = manageSearchHistoryUseCase;

  @override
  Future<Either<Failure, List<SearchHistory>>> call(GetSearchHistoryParams params) async {
    return await _manageSearchHistoryUseCase.getHistory(limit: params.limit);
  }
}

/// Use case for clearing search history
class ClearSearchHistoryUseCase implements UseCase<void, NoParams> {
  final ManageSearchHistoryUseCase _manageSearchHistoryUseCase;

  ClearSearchHistoryUseCase({required ManageSearchHistoryUseCase manageSearchHistoryUseCase})
      : _manageSearchHistoryUseCase = manageSearchHistoryUseCase;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _manageSearchHistoryUseCase.clearHistory();
  }
}

/// Use case for removing search history item
class RemoveSearchHistoryUseCase implements UseCase<void, RemoveSearchHistoryParams> {
  final ManageSearchHistoryUseCase _manageSearchHistoryUseCase;

  RemoveSearchHistoryUseCase({required ManageSearchHistoryUseCase manageSearchHistoryUseCase})
      : _manageSearchHistoryUseCase = manageSearchHistoryUseCase;

  @override
  Future<Either<Failure, void>> call(RemoveSearchHistoryParams params) async {
    return await _manageSearchHistoryUseCase.removeHistoryItem(params.id);
  }
}

/// Parameters for getting search history
class GetSearchHistoryParams {
  final int? limit;

  const GetSearchHistoryParams({this.limit});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetSearchHistoryParams && other.limit == limit;
  }

  @override
  int get hashCode => limit.hashCode;

  @override
  String toString() => 'GetSearchHistoryParams(limit: $limit)';
}