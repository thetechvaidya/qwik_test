import 'package:equatable/equatable.dart';

/// Entity representing a search history item
class SearchHistory extends Equatable {
  final String id;
  final String query;
  final DateTime searchedAt;
  final int resultCount;
  final int frequency;
  final String? category;
  final Map<String, dynamic>? filters;
  final Map<String, dynamic>? metadata;

  const SearchHistory({
    required this.id,
    required this.query,
    required this.searchedAt,
    this.resultCount = 0,
    this.frequency = 1,
    this.category,
    this.filters,
    this.metadata,
  });

  /// Create a copy with updated properties
  SearchHistory copyWith({
    String? id,
    String? query,
    DateTime? searchedAt,
    int? resultCount,
    int? frequency,
    String? category,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? metadata,
  }) {
    return SearchHistory(
      id: id ?? this.id,
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
      resultCount: resultCount ?? this.resultCount,
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      filters: filters ?? this.filters,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        query,
        searchedAt,
        resultCount,
        frequency,
        category,
        filters,
        metadata,
      ];

  @override
  String toString() {
    return 'SearchHistory(id: $id, query: $query, searchedAt: $searchedAt, resultCount: $resultCount, frequency: $frequency)';
  }
}