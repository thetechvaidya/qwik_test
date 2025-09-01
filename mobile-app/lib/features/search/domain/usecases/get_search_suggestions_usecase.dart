import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_suggestion.dart';
import '../repositories/search_repository.dart';

/// Use case for getting search suggestions
class GetSearchSuggestionsUseCase implements UseCase<List<SearchSuggestion>, GetSearchSuggestionsParams> {
  final SearchRepository _repository;

  GetSearchSuggestionsUseCase({required SearchRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<SearchSuggestion>>> call(GetSearchSuggestionsParams params) async {
    return await _repository.getSearchSuggestions(
      query: params.query,
      limit: params.limit,
    );
  }
}

/// Parameters for getting search suggestions
class GetSearchSuggestionsParams {
  final String? query;
  final int limit;

  const GetSearchSuggestionsParams({
    this.query,
    this.limit = 10,
  });

  /// Create a copy with updated parameters
  GetSearchSuggestionsParams copyWith({
    String? query,
    int? limit,
  }) {
    return GetSearchSuggestionsParams(
      query: query ?? this.query,
      limit: limit ?? this.limit,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is GetSearchSuggestionsParams &&
        other.query == query &&
        other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(query, limit);

  @override
  String toString() {
    return 'GetSearchSuggestionsParams(query: $query, limit: $limit)';
  }
}