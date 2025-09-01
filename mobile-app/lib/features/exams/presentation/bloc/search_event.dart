import 'package:equatable/equatable.dart';

/// Base class for all search-related events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get search suggestions based on query
class GetSearchSuggestionsEvent extends SearchEvent {
  final String query;
  final String? categoryId;
  final int limit;

  const GetSearchSuggestionsEvent({
    required this.query,
    this.categoryId,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [query, categoryId, limit];
}

/// Event to load search history
class LoadSearchHistoryEvent extends SearchEvent {
  final int limit;

  const LoadSearchHistoryEvent({
    this.limit = 10,
  });

  @override
  List<Object?> get props => [limit];
}

/// Event to save a search query to history
class SaveSearchHistoryEvent extends SearchEvent {
  final String query;
  final String? categoryId;
  final String? categoryName;
  final Map<String, dynamic>? filters;

  const SaveSearchHistoryEvent({
    required this.query,
    this.categoryId,
    this.categoryName,
    this.filters,
  });

  @override
  List<Object?> get props => [query, categoryId, categoryName, filters];
}

/// Event to remove a specific search history item
class RemoveSearchHistoryEvent extends SearchEvent {
  final String historyId;

  const RemoveSearchHistoryEvent({
    required this.historyId,
  });

  @override
  List<Object?> get props => [historyId];
}

/// Event to clear all search history
class ClearSearchHistoryEvent extends SearchEvent {
  const ClearSearchHistoryEvent();
}

/// Event to get trending searches
class GetTrendingSearchesEvent extends SearchEvent {
  final int limit;

  const GetTrendingSearchesEvent({
    this.limit = 5,
  });

  @override
  List<Object?> get props => [limit];
}

/// Event to get popular search queries
class GetPopularQueriesEvent extends SearchEvent {
  final int limit;

  const GetPopularQueriesEvent({
    this.limit = 5,
  });

  @override
  List<Object?> get props => [limit];
}

/// Event to report search analytics
class ReportSearchAnalyticsEvent extends SearchEvent {
  final String query;
  final int resultCount;
  final String? categoryId;
  final Map<String, dynamic>? filters;

  const ReportSearchAnalyticsEvent({
    required this.query,
    required this.resultCount,
    this.categoryId,
    this.filters,
  });

  @override
  List<Object?> get props => [query, resultCount, categoryId, filters];
}

/// Event to clear cached suggestions
class ClearCachedSuggestionsEvent extends SearchEvent {
  const ClearCachedSuggestionsEvent();
}