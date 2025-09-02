import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/usecases/search_usecase.dart';
import '../../domain/usecases/get_search_suggestions_usecase.dart';
import '../../domain/usecases/manage_search_history_usecase.dart';
import '../../domain/usecases/get_search_history_usecase.dart';
import '../../domain/usecases/clear_search_history_usecase.dart';
import '../../domain/usecases/remove_search_history_usecase.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/entities/search_history.dart';

// Events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearchEvent extends SearchEvent {
  final String query;
  final String? type;
  final String? categoryId;
  final String? difficulty;
  final bool saveToHistory;
  final bool trackAnalytics;

  const PerformSearchEvent({
    required this.query,
    this.type,
    this.categoryId,
    this.difficulty,
    this.saveToHistory = true,
    this.trackAnalytics = true,
  });

  @override
  List<Object?> get props => [
        query,
        type,
        categoryId,
        difficulty,
        saveToHistory,
        trackAnalytics,
      ];
}

class LoadMoreSearchResultsEvent extends SearchEvent {
  const LoadMoreSearchResultsEvent();
}

class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}

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

class GetSearchHistoryEvent extends SearchEvent {
  final int? limit;

  const GetSearchHistoryEvent({this.limit});

  @override
  List<Object?> get props => [limit];
}

class ClearSearchHistoryEvent extends SearchEvent {
  const ClearSearchHistoryEvent();
}

class RemoveSearchHistoryEvent extends SearchEvent {
  final String id;

  const RemoveSearchHistoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// States
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<SearchResult> results;
  final String query;
  final int currentPage;
  final int totalPages;
  final bool hasMorePages;
  final bool isLoadingMore;
  final String? type;
  final String? categoryId;
  final String? difficulty;

  const SearchLoaded({
    required this.results,
    required this.query,
    required this.currentPage,
    required this.totalPages,
    required this.hasMorePages,
    this.isLoadingMore = false,
    this.type,
    this.categoryId,
    this.difficulty,
  });

  SearchLoaded copyWith({
    List<SearchResult>? results,
    String? query,
    int? currentPage,
    int? totalPages,
    bool? hasMorePages,
    bool? isLoadingMore,
    String? type,
    String? categoryId,
    String? difficulty,
  }) {
    return SearchLoaded(
      results: results ?? this.results,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object?> get props => [
        results,
        query,
        currentPage,
        totalPages,
        hasMorePages,
        isLoadingMore,
        type,
        categoryId,
        difficulty,
      ];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchSuggestionsLoaded extends SearchState {
  final List<SearchSuggestion> suggestions;
  final String query;

  const SearchSuggestionsLoaded({
    required this.suggestions,
    required this.query,
  });

  @override
  List<Object?> get props => [suggestions, query];
}

class SearchHistoryLoaded extends SearchState {
  final List<SearchHistory> history;

  const SearchHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

// BLoC
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUseCase _searchUseCase;
  final GetSearchSuggestionsUseCase _getSearchSuggestionsUseCase;
  final ManageSearchHistoryUseCase _manageSearchHistoryUseCase;
  final GetSearchHistoryUseCase _getSearchHistoryUseCase;
  final ClearSearchHistoryUseCase _clearSearchHistoryUseCase;
  final RemoveSearchHistoryUseCase _removeSearchHistoryUseCase;

  SearchBloc({
    required SearchUseCase searchUseCase,
    required GetSearchSuggestionsUseCase getSearchSuggestionsUseCase,
    required ManageSearchHistoryUseCase manageSearchHistoryUseCase,
    required GetSearchHistoryUseCase getSearchHistoryUseCase,
    required ClearSearchHistoryUseCase clearSearchHistoryUseCase,
    required RemoveSearchHistoryUseCase removeSearchHistoryUseCase,
  })  : _searchUseCase = searchUseCase,
        _getSearchSuggestionsUseCase = getSearchSuggestionsUseCase,
        _manageSearchHistoryUseCase = manageSearchHistoryUseCase,
        _getSearchHistoryUseCase = getSearchHistoryUseCase,
        _clearSearchHistoryUseCase = clearSearchHistoryUseCase,
        _removeSearchHistoryUseCase = removeSearchHistoryUseCase,
        super(const SearchInitial()) {
    on<PerformSearchEvent>(_onPerformSearch);
    on<LoadMoreSearchResultsEvent>(_onLoadMoreSearchResults);
    on<ClearSearchEvent>(_onClearSearch);
    on<GetSearchSuggestionsEvent>(_onGetSearchSuggestions);
    on<GetSearchHistoryEvent>(_onGetSearchHistory);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
    on<RemoveSearchHistoryEvent>(_onRemoveSearchHistory);
  }

  Future<void> _onPerformSearch(
    PerformSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading());

    final params = SearchParams(
      query: event.query,
      type: event.type,
      categoryId: event.categoryId,
      difficulty: event.difficulty,
      page: 1,
      limit: 20,
      saveToHistory: event.saveToHistory,
      trackAnalytics: event.trackAnalytics,
    );

    final result = await _searchUseCase(params);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (paginatedResponse) => emit(
        SearchLoaded(
          results: paginatedResponse.data,
          query: event.query,
          currentPage: paginatedResponse.currentPage,
          totalPages: paginatedResponse.totalPages ?? 1,
          hasMorePages: paginatedResponse.hasNextPage,
          type: event.type,
          categoryId: event.categoryId,
          difficulty: event.difficulty,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResultsEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SearchLoaded || !currentState.hasMorePages) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final params = SearchParams(
      query: currentState.query,
      type: currentState.type,
      categoryId: currentState.categoryId,
      difficulty: currentState.difficulty,
      page: currentState.currentPage + 1,
      limit: 20,
      saveToHistory: false, // Don't save pagination to history
      trackAnalytics: false, // Don't track pagination
    );

    final result = await _searchUseCase(params);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (paginatedResponse) => emit(
        currentState.copyWith(
          results: [...currentState.results, ...paginatedResponse.data],
          currentPage: paginatedResponse.currentPage,
          totalPages: paginatedResponse.totalPages ?? currentState.totalPages,
          hasMorePages: paginatedResponse.hasNextPage,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchInitial());
  }

  Future<void> _onGetSearchSuggestions(
    GetSearchSuggestionsEvent event,
    Emitter<SearchState> emit,
  ) async {
    final params = GetSearchSuggestionsParams(
      query: event.query,
      categoryId: event.categoryId,
      limit: event.limit,
    );

    final result = await _getSearchSuggestionsUseCase(params);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (suggestions) => emit(
        SearchSuggestionsLoaded(
          suggestions: suggestions,
          query: event.query,
        ),
      ),
    );
  }

  Future<void> _onGetSearchHistory(
    GetSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final params = GetSearchHistoryParams(limit: event.limit);
    final result = await _getSearchHistoryUseCase(params);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (history) => emit(SearchHistoryLoaded(history)),
    );
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final result = await _clearSearchHistoryUseCase(const NoParams());

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (_) {
        // Refresh history after clearing
        add(const GetSearchHistoryEvent());
      },
    );
  }

  Future<void> _onRemoveSearchHistory(
    RemoveSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final params = RemoveSearchHistoryParams(id: event.id);
    final result = await _removeSearchHistoryUseCase(params);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (_) {
        // Refresh history after removing item
        add(const GetSearchHistoryEvent());
      },
    );
  }
}