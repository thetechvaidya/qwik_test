import 'package:equatable/equatable.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/entities/search_history.dart';

/// Base class for all search-related states
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state when search feature is first loaded
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// State when search operations are in progress
class SearchLoading extends SearchState {
  final bool isLoadingSuggestions;
  final bool isLoadingHistory;
  final bool isSavingHistory;
  final bool isLoadingTrending;

  const SearchLoading({
    this.isLoadingSuggestions = false,
    this.isLoadingHistory = false,
    this.isSavingHistory = false,
    this.isLoadingTrending = false,
  });

  @override
  List<Object?> get props => [
        isLoadingSuggestions,
        isLoadingHistory,
        isSavingHistory,
        isLoadingTrending,
      ];
}

/// State when search data has been successfully loaded
class SearchLoaded extends SearchState {
  final List<SearchSuggestion> suggestions;
  final List<SearchHistory> searchHistory;
  final List<String> trendingSearches;
  final List<String> popularQueries;
  final String? currentQuery;
  final bool isLoadingSuggestions;
  final bool hasMoreHistory;

  const SearchLoaded({
    this.suggestions = const [],
    this.searchHistory = const [],
    this.trendingSearches = const [],
    this.popularQueries = const [],
    this.currentQuery,
    this.isLoadingSuggestions = false,
    this.hasMoreHistory = false,
  });

  /// Creates a copy of this state with updated values
  SearchLoaded copyWith({
    List<SearchSuggestion>? suggestions,
    List<SearchHistory>? searchHistory,
    List<String>? trendingSearches,
    List<String>? popularQueries,
    String? currentQuery,
    bool? isLoadingSuggestions,
    bool? hasMoreHistory,
  }) {
    return SearchLoaded(
      suggestions: suggestions ?? this.suggestions,
      searchHistory: searchHistory ?? this.searchHistory,
      trendingSearches: trendingSearches ?? this.trendingSearches,
      popularQueries: popularQueries ?? this.popularQueries,
      currentQuery: currentQuery ?? this.currentQuery,
      isLoadingSuggestions: isLoadingSuggestions ?? this.isLoadingSuggestions,
      hasMoreHistory: hasMoreHistory ?? this.hasMoreHistory,
    );
  }

  /// Checks if there are any suggestions available
  bool get hasSuggestions => suggestions.isNotEmpty;

  /// Checks if there is any search history
  bool get hasHistory => searchHistory.isNotEmpty;

  /// Checks if there are trending searches
  bool get hasTrendingSearches => trendingSearches.isNotEmpty;

  /// Checks if there are popular queries
  bool get hasPopularQueries => popularQueries.isNotEmpty;

  /// Gets suggestions filtered by type
  List<SearchSuggestion> getSuggestionsByType(SearchSuggestionType type) {
    return suggestions.where((s) => s.type == type).toList();
  }

  /// Gets recent search history (last 5 items)
  List<SearchHistory> get recentHistory {
    return searchHistory.take(5).toList();
  }

  /// Gets frequently searched queries
  List<SearchHistory> get frequentHistory {
    final sorted = List<SearchHistory>.from(searchHistory)
      ..sort((a, b) => b.frequency.compareTo(a.frequency));
    return sorted.take(5).toList();
  }

  @override
  List<Object?> get props => [
        suggestions,
        searchHistory,
        trendingSearches,
        popularQueries,
        currentQuery,
        isLoadingSuggestions,
        hasMoreHistory,
      ];
}

/// State when a search operation encounters an error
class SearchError extends SearchState {
  final String message;
  final SearchState? previousState;
  final String? errorCode;
  final bool isNetworkError;

  const SearchError({
    required this.message,
    this.previousState,
    this.errorCode,
    this.isNetworkError = false,
  });

  /// Checks if this is a recoverable error
  bool get isRecoverable => previousState != null;

  /// Gets the previous state if available, otherwise returns initial state
  SearchState get fallbackState => previousState ?? const SearchInitial();

  @override
  List<Object?> get props => [
        message,
        previousState,
        errorCode,
        isNetworkError,
      ];
}

/// State when search history is being updated
class SearchHistoryUpdating extends SearchState {
  final SearchLoaded previousState;
  final String operation; // 'saving', 'removing', 'clearing'

  const SearchHistoryUpdating({
    required this.previousState,
    required this.operation,
  });

  @override
  List<Object?> get props => [previousState, operation];
}

/// State when search suggestions are being fetched
class SearchSuggestionsLoading extends SearchState {
  final SearchLoaded previousState;
  final String query;

  const SearchSuggestionsLoading({
    required this.previousState,
    required this.query,
  });

  @override
  List<Object?> get props => [previousState, query];
}