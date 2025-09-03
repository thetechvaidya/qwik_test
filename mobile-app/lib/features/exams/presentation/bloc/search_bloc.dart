import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../search/domain/usecases/get_search_suggestions_usecase.dart';
import '../../../search/domain/usecases/manage_search_history_usecase.dart';
import '../../../search/domain/usecases/report_search_analytics_usecase.dart';
import '../../../../core/error/failures.dart';
import 'search_event.dart';
import 'search_state.dart';

/// BLoC for managing search functionality including suggestions and history
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetSearchSuggestionsUseCase _getSearchSuggestionsUseCase;
  final ManageSearchHistoryUseCase _manageSearchHistoryUseCase;
  final ReportSearchAnalyticsUseCase _reportSearchAnalyticsUseCase;

  SearchBloc({
    required GetSearchSuggestionsUseCase getSearchSuggestionsUseCase,
    required ManageSearchHistoryUseCase manageSearchHistoryUseCase,
    required ReportSearchAnalyticsUseCase reportSearchAnalyticsUseCase,
  })
      : _getSearchSuggestionsUseCase = getSearchSuggestionsUseCase,
        _manageSearchHistoryUseCase = manageSearchHistoryUseCase,
        _reportSearchAnalyticsUseCase = reportSearchAnalyticsUseCase,
        super(const SearchInitial()) {
    on<GetSearchSuggestionsEvent>(_onGetSearchSuggestions);
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<SaveSearchHistoryEvent>(_onSaveSearchHistory);
    on<RemoveSearchHistoryEvent>(_onRemoveSearchHistory);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
    on<GetTrendingSearchesEvent>(_onGetTrendingSearches);
    on<GetPopularQueriesEvent>(_onGetPopularQueries);
    on<ReportSearchAnalyticsEvent>(_onReportSearchAnalytics);
    on<ClearCachedSuggestionsEvent>(_onClearCachedSuggestions);
  }

  Future<void> _onGetSearchSuggestions(
    GetSearchSuggestionsEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    
    // Update loading state while keeping existing data
    if (currentState is SearchLoaded) {
      emit(currentState.copyWith(
        isLoadingSuggestions: true,
        currentQuery: event.query,
      ));
    } else {
      emit(const SearchLoading(isLoadingSuggestions: true));
    }

    final result = await _getSearchSuggestionsUseCase(
      GetSearchSuggestionsParams(
        query: event.query,
        categoryId: event.categoryId,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) {
        emit(SearchError(
          message: _mapFailureToMessage(failure),
          previousState: currentState,
          isNetworkError: failure is NetworkFailure,
        ));
      },
      (suggestions) {
        if (currentState is SearchLoaded) {
          emit(currentState.copyWith(
            suggestions: suggestions,
            isLoadingSuggestions: false,
            currentQuery: event.query,
          ));
        } else {
          emit(SearchLoaded(
            suggestions: suggestions,
            currentQuery: event.query,
            isLoadingSuggestions: false,
          ));
        }
      },
    );
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is! SearchLoaded) {
      emit(const SearchLoading(isLoadingHistory: true));
    }

    final result = await _manageSearchHistoryUseCase.getHistory(
      GetSearchHistoryParams(limit: event.limit),
    );

    result.fold(
      (failure) {
        emit(SearchError(
          message: _mapFailureToMessage(failure),
          previousState: currentState,
        ));
      },
      (history) {
        if (currentState is SearchLoaded) {
          emit(currentState.copyWith(
            searchHistory: history,
          ));
        } else {
          emit(SearchLoaded(
            searchHistory: history,
          ));
        }
      },
    );
  }

  Future<void> _onSaveSearchHistory(
    SaveSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is SearchLoaded) {
      emit(SearchHistoryUpdating(
        previousState: currentState,
        operation: 'saving',
      ));
    }

    final result = await _manageSearchHistoryUseCase.saveToHistory(
      query: event.query,
      categoryId: event.categoryId,
      categoryName: event.categoryName,
      filters: event.filters,
    );

    result.fold(
      (failure) {
        emit(SearchError(
          message: _mapFailureToMessage(failure),
          previousState: currentState,
        ));
      },
      (_) {
        // Reload search history to reflect the new entry
        add(const LoadSearchHistoryEvent());
      },
    );
  }

  Future<void> _onRemoveSearchHistory(
    RemoveSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is SearchLoaded) {
      emit(SearchHistoryUpdating(
        previousState: currentState,
        operation: 'removing',
      ));
    }

    final result = await _manageSearchHistoryUseCase.removeHistoryItem(
      RemoveSearchHistoryParams(historyId: event.historyId),
    );

    result.fold(
      (failure) {
        emit(SearchError(
          message: _mapFailureToMessage(failure),
          previousState: currentState,
        ));
      },
      (_) {
        if (currentState is SearchLoaded) {
          // Remove the item from current state immediately for better UX
          final updatedHistory = currentState.searchHistory
              .where((item) => item.id != event.historyId)
              .toList();
          
          emit(currentState.copyWith(
            searchHistory: updatedHistory,
          ));
        }
      },
    );
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is SearchLoaded) {
      emit(SearchHistoryUpdating(
        previousState: currentState,
        operation: 'clearing',
      ));
    }

    final result = await _manageSearchHistoryUseCase.clearHistory();

    result.fold(
      (failure) {
        emit(SearchError(
          message: _mapFailureToMessage(failure),
          previousState: currentState,
        ));
      },
      (_) {
        if (currentState is SearchLoaded) {
          emit(currentState.copyWith(
            searchHistory: [],
          ));
        }
      },
    );
  }

  Future<void> _onGetTrendingSearches(
    GetTrendingSearchesEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is! SearchLoaded) {
      emit(const SearchLoading(isLoadingTrending: true));
    }

    final result = await _manageSearchHistoryUseCase.getTrendingSearches(
      limit: event.limit,
    );

    result.fold(
      (failure) {
        emit(SearchError(
          message: _mapFailureToMessage(failure),
          previousState: currentState,
        ));
      },
      (trending) {
        if (currentState is SearchLoaded) {
          emit(currentState.copyWith(
            trendingSearches: trending,
          ));
        } else {
          emit(SearchLoaded(
            trendingSearches: trending,
          ));
        }
      },
    );
  }

  Future<void> _onGetPopularQueries(
    GetPopularQueriesEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;

    final result = await _manageSearchHistoryUseCase.getPopularQueries(
      limit: event.limit,
    );

    result.fold(
      (failure) {
        emit(SearchError(
          message: _mapFailureToMessage(failure),
          previousState: currentState,
        ));
      },
      (popular) {
        if (currentState is SearchLoaded) {
          emit(currentState.copyWith(
            popularQueries: popular,
          ));
        } else {
          emit(SearchLoaded(
            popularQueries: popular,
          ));
        }
      },
    );
  }

  Future<void> _onReportSearchAnalytics(
    ReportSearchAnalyticsEvent event,
    Emitter<SearchState> emit,
  ) async {
    // Report analytics in the background without affecting UI state
    await _reportSearchAnalyticsUseCase(
      ReportSearchAnalyticsParams(
        query: event.query,
        resultCount: event.resultCount,
        categoryId: event.categoryId,
        hasResults: event.resultCount > 0,
      ),
    );
  }

  Future<void> _onClearCachedSuggestions(
    ClearCachedSuggestionsEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is SearchLoaded) {
      emit(currentState.copyWith(
        suggestions: [],
        currentQuery: null,
      ));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case NetworkFailure:
        return 'No internet connection. Please check your network.';
      case CacheFailure:
        return 'Local storage error occurred.';
      case ValidationFailure:
        return 'Invalid search query. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}