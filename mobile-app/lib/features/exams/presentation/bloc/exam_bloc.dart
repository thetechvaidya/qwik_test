import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../../domain/entities/exam.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_exams_usecase.dart';
import '../../domain/usecases/get_exam_detail_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_featured_exams_usecase.dart';
import '../../domain/usecases/get_recent_exams_usecase.dart';
import '../../domain/usecases/get_popular_exams_usecase.dart';
import '../../domain/usecases/search_exams_usecase.dart';
import '../../../search/domain/usecases/search_exams_usecase.dart' as search;
import 'exam_event.dart';
import 'exam_state.dart';

/// BLoC for managing exam-related state and business logic
class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final GetExamsUseCase _getExamsUseCase;
  final GetExamDetailUseCase _getExamDetailUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetFeaturedExamsUseCase _getFeaturedExamsUseCase;
  final GetRecentExamsUseCase _getRecentExamsUseCase;
  final GetPopularExamsUseCase _getPopularExamsUseCase;
  final SearchExamsUseCase _searchExamsUseCase;
  final search.SearchExamsUseCase _searchWithHistoryUseCase;

  // Pagination controller
  late PaginationController _paginationController;

  // Current filters and sorting
  ExamFilters _currentFilters = const ExamFilters();
  ExamSorting _currentSorting = const ExamSorting();
  ExamViewMode _currentViewMode = ExamViewMode.list;
  String? _currentSearchQuery;

  ExamBloc({
    required GetExamsUseCase getExamsUseCase,
    required GetExamDetailUseCase getExamDetailUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetFeaturedExamsUseCase getFeaturedExamsUseCase,
    required GetRecentExamsUseCase getRecentExamsUseCase,
    required GetPopularExamsUseCase getPopularExamsUseCase,
    required SearchExamsUseCase searchExamsUseCase,
    required search.SearchExamsUseCase searchWithHistoryUseCase,
  })
      : _getExamsUseCase = getExamsUseCase,
        _getExamDetailUseCase = getExamDetailUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _getFeaturedExamsUseCase = getFeaturedExamsUseCase,
        _getRecentExamsUseCase = getRecentExamsUseCase,
        _getPopularExamsUseCase = getPopularExamsUseCase,
        _searchExamsUseCase = searchExamsUseCase,
        _searchWithHistoryUseCase = searchWithHistoryUseCase,
        super(const ExamInitial()) {
    _paginationController = PaginationController(
      pageSize: 20,
      onLoadMore: () => add(const LoadMoreExamsEvent()),
    );

    // Register event handlers
    on<LoadExamsEvent>(_onLoadExams);
    on<LoadMoreExamsEvent>(_onLoadMoreExams);
    on<RefreshExamsEvent>(_onRefreshExams);
    on<LoadExamDetailEvent>(_onLoadExamDetail);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadFeaturedExamsEvent>(_onLoadFeaturedExams);
    on<LoadRecentExamsEvent>(_onLoadRecentExams);
    on<LoadPopularExamsEvent>(_onLoadPopularExams);
    on<SearchExamsEvent>(_onSearchExams);
    on<ClearSearchEvent>(_onClearSearch);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ClearFiltersEvent>(_onClearFilters);
    on<ChangeSortingEvent>(_onChangeSorting);
    on<ChangeViewModeEvent>(_onChangeViewMode);
    on<RetryLoadingEvent>(_onRetryLoading);
    on<ToggleExamFavoriteEvent>(_onToggleExamFavorite);
    on<StartExamEvent>(_onStartExam);
    on<ResumeExamEvent>(_onResumeExam);
    on<UpdateExamProgressEvent>(_onUpdateExamProgress);
  }

  @override
  Future<void> close() {
    _paginationController.dispose();
    return super.close();
  }

  /// Handle loading exams
  Future<void> _onLoadExams(LoadExamsEvent event, Emitter<ExamState> emit) async {
    try {
      // Update filters if provided
      if (event.categoryId != null ||
          event.difficulty != null ||
          event.examType != null ||
          event.isActive != null) {
        _currentFilters = ExamFilters(
          categoryId: event.categoryId,
          difficulty: event.difficulty,
          examType: event.examType,
          isActive: event.isActive,
        );
      }

      // Update sorting if provided
      if (event.sortBy != null || event.sortOrder != null) {
        _currentSorting = ExamSorting(
          sortBy: event.sortBy ?? _currentSorting.sortBy,
          sortOrder: event.sortOrder ?? _currentSorting.sortOrder,
        );
      }

      // Reset pagination if refresh or new filters
      if (event.refresh || _paginationController.currentPage > 1) {
        _paginationController.reset();
      }

      // Show loading state
      if (state is! ExamLoaded || event.refresh) {
        emit(ExamLoading(isRefresh: event.refresh));
      }

      // Load exams
      final result = await _getExamsUseCase(GetExamsParams(
        categoryId: _currentFilters.categoryId,
        difficulty: _currentFilters.difficulty,
        examType: _currentFilters.examType,
        isActive: _currentFilters.isActive,
        sortBy: _currentSorting.sortBy,
        sortOrder: _currentSorting.sortOrder,
        page: _paginationController.currentPage,
        limit: _paginationController.pageSize,
      ));

      await result.fold(
        (failure) async {
          emit(ExamError(
            message: _getFailureMessage(failure),
            errorCode: failure.runtimeType.toString(),
            previousState: state is ExamLoaded ? state as ExamLoaded : null,
          ));
        },
        (paginatedResponse) async {
          final exams = paginatedResponse.data;
          
          // Update pagination state
          _paginationController.updateFromResponse(paginatedResponse);

          // Get current state or create new one
          final currentState = state is ExamLoaded ? state as ExamLoaded : null;
          
          // Merge or replace exams based on page
          final List<Exam> allExams;
          if (_paginationController.currentPage == 1 || event.refresh) {
            allExams = exams;
          } else {
            allExams = [...(currentState?.exams ?? []), ...exams];
          }

          emit(ExamLoaded(
            exams: allExams,
            categories: currentState?.categories ?? [],
            featuredExams: currentState?.featuredExams ?? [],
            recentExams: currentState?.recentExams ?? [],
            popularExams: currentState?.popularExams ?? [],
            searchResults: currentState?.searchResults ?? [],
            paginationState: _paginationController.state,
            filters: _currentFilters,
            sorting: _currentSorting,
            viewMode: _currentViewMode,
            searchQuery: _currentSearchQuery,
            isSearching: _currentSearchQuery != null,
            hasReachedMax: _paginationController.hasReachedMax,
            lastUpdated: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      emit(ExamError(
        message: 'An unexpected error occurred: ${e.toString()}',
        previousState: state is ExamLoaded ? state as ExamLoaded : null,
      ));
    }
  }

  /// Handle loading more exams (pagination)
  Future<void> _onLoadMoreExams(LoadMoreExamsEvent event, Emitter<ExamState> emit) async {
    if (state is! ExamLoaded) return;
    
    final currentState = state as ExamLoaded;
    
    // Check if we can load more
    if (currentState.hasReachedMax || currentState.isSearching) return;

    try {
      // Show loading more state
      emit(currentState.copyWith());
      emit(const ExamLoading(isLoadingMore: true));

      // Increment page
      _paginationController.nextPage();

      // Load next page
      final result = await _getExamsUseCase(GetExamsParams(
        categoryId: _currentFilters.categoryId,
        difficulty: _currentFilters.difficulty,
        examType: _currentFilters.examType,
        isActive: _currentFilters.isActive,
        sortBy: _currentSorting.sortBy,
        sortOrder: _currentSorting.sortOrder,
        page: _paginationController.currentPage,
        limit: _paginationController.pageSize,
      ));

      await result.fold(
        (failure) async {
          // Revert page increment on error
          _paginationController.previousPage();
          
          emit(ExamError(
            message: _getFailureMessage(failure),
            errorCode: failure.runtimeType.toString(),
            previousState: currentState,
          ));
        },
        (paginatedResponse) async {
          final newExams = paginatedResponse.data;
          
          // Update pagination state
          _paginationController.updateFromResponse(paginatedResponse);

          // Merge with existing exams
          final allExams = [...currentState.exams, ...newExams];

          emit(currentState.copyWith(
            exams: allExams,
            paginationState: _paginationController.state,
            hasReachedMax: _paginationController.hasReachedMax,
            lastUpdated: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      emit(ExamError(
        message: 'Failed to load more exams: ${e.toString()}',
        previousState: currentState,
      ));
    }
  }

  /// Handle refreshing exams
  Future<void> _onRefreshExams(RefreshExamsEvent event, Emitter<ExamState> emit) async {
    add(LoadExamsEvent(
      categoryId: _currentFilters.categoryId,
      difficulty: _currentFilters.difficulty,
      examType: _currentFilters.examType,
      isActive: _currentFilters.isActive,
      sortBy: _currentSorting.sortBy,
      sortOrder: _currentSorting.sortOrder,
      refresh: true,
    ));
  }

  /// Handle loading exam detail
  Future<void> _onLoadExamDetail(LoadExamDetailEvent event, Emitter<ExamState> emit) async {
    try {
      emit(ExamDetailLoading(examId: event.examId));

      final result = await _getExamDetailUseCase(GetExamDetailParams(
        examId: event.examId,
        forceRefresh: event.forceRefresh,
      ));

      result.fold(
        (failure) => emit(ExamDetailError(
          examId: event.examId,
          message: _getFailureMessage(failure),
          errorCode: failure.runtimeType.toString(),
        )),
        (exam) => emit(ExamDetailLoaded(
          exam: exam,
          lastUpdated: DateTime.now(),
        )),
      );
    } catch (e) {
      emit(ExamDetailError(
        examId: event.examId,
        message: 'Failed to load exam details: ${e.toString()}',
      ));
    }
  }

  /// Handle loading categories
  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<ExamState> emit) async {
    try {
      final result = await _getCategoriesUseCase(GetCategoriesParams(
        rootOnly: event.rootOnly,
        forceRefresh: event.refresh,
      ));

      result.fold(
        (failure) {
          // Don't emit error for categories, just log it
          print('Failed to load categories: ${_getFailureMessage(failure)}');
        },
        (categories) {
          if (state is ExamLoaded) {
            final currentState = state as ExamLoaded;
            emit(currentState.copyWith(
              categories: categories,
              lastUpdated: DateTime.now(),
            ));
          }
        },
      );
    } catch (e) {
      print('Failed to load categories: ${e.toString()}');
    }
  }

  /// Handle loading featured exams
  Future<void> _onLoadFeaturedExams(LoadFeaturedExamsEvent event, Emitter<ExamState> emit) async {
    try {
      final result = await _getFeaturedExamsUseCase(GetFeaturedExamsParams(
        limit: event.limit,
        forceRefresh: event.refresh,
      ));

      result.fold(
        (failure) {
          print('Failed to load featured exams: ${_getFailureMessage(failure)}');
        },
        (exams) {
          if (state is ExamLoaded) {
            final currentState = state as ExamLoaded;
            emit(currentState.copyWith(
              featuredExams: exams,
              lastUpdated: DateTime.now(),
            ));
          }
        },
      );
    } catch (e) {
      print('Failed to load featured exams: ${e.toString()}');
    }
  }

  /// Handle loading recent exams
  Future<void> _onLoadRecentExams(LoadRecentExamsEvent event, Emitter<ExamState> emit) async {
    try {
      final result = await _getRecentExamsUseCase(GetRecentExamsParams(
        limit: event.limit,
        forceRefresh: event.refresh,
      ));

      result.fold(
        (failure) {
          print('Failed to load recent exams: ${_getFailureMessage(failure)}');
        },
        (exams) {
          if (state is ExamLoaded) {
            final currentState = state as ExamLoaded;
            emit(currentState.copyWith(
              recentExams: exams,
              lastUpdated: DateTime.now(),
            ));
          }
        },
      );
    } catch (e) {
      print('Failed to load recent exams: ${e.toString()}');
    }
  }

  /// Handle loading popular exams
  Future<void> _onLoadPopularExams(LoadPopularExamsEvent event, Emitter<ExamState> emit) async {
    try {
      final result = await _getPopularExamsUseCase(GetPopularExamsParams(
        limit: event.limit,
        forceRefresh: event.refresh,
      ));

      result.fold(
        (failure) {
          print('Failed to load popular exams: ${_getFailureMessage(failure)}');
        },
        (exams) {
          if (state is ExamLoaded) {
            final currentState = state as ExamLoaded;
            emit(currentState.copyWith(
              popularExams: exams,
              lastUpdated: DateTime.now(),
            ));
          }
        },
      );
    } catch (e) {
      print('Failed to load popular exams: ${e.toString()}');
    }
  }

  /// Handle searching exams
  Future<void> _onSearchExams(SearchExamsEvent event, Emitter<ExamState> emit) async {
    try {
      _currentSearchQuery = event.query;
      
      // Reset pagination for search
      _paginationController.reset();

      // Show loading state
      if (state is ExamLoaded) {
        final currentState = state as ExamLoaded;
        emit(currentState.copyWith(
          isSearching: true,
          searchQuery: event.query,
        ));
      } else {
        emit(const ExamLoading());
      }

      // Perform search with history tracking
      final result = await _searchWithHistoryUseCase(search.SearchExamsParams(
        query: event.query,
        categoryId: event.categoryId,
        difficulty: event.difficulty,
        examType: event.examType,
        minDuration: event.minDuration,
        maxDuration: event.maxDuration,
        isActive: event.isActive,
        page: 1,
        limit: 20,
      ));

      result.fold(
        (failure) => emit(ExamError(
          message: _getFailureMessage(failure),
          errorCode: failure.runtimeType.toString(),
          previousState: state is ExamLoaded ? state as ExamLoaded : null,
        )),
        (searchResults) {
          if (state is ExamLoaded) {
            final currentState = state as ExamLoaded;
            emit(currentState.copyWith(
              searchResults: searchResults,
              searchQuery: event.query,
              isSearching: true,
              lastUpdated: DateTime.now(),
            ));
          } else {
            emit(ExamLoaded(
              searchResults: searchResults,
              searchQuery: event.query,
              isSearching: true,
              filters: _currentFilters,
              sorting: _currentSorting,
              viewMode: _currentViewMode,
              lastUpdated: DateTime.now(),
            ));
          }
        },
      );
    } catch (e) {
      emit(ExamError(
        message: 'Search failed: ${e.toString()}',
        previousState: state is ExamLoaded ? state as ExamLoaded : null,
      ));
    }
  }

  /// Handle clearing search
  Future<void> _onClearSearch(ClearSearchEvent event, Emitter<ExamState> emit) async {
    _currentSearchQuery = null;
    
    if (state is ExamLoaded) {
      final currentState = state as ExamLoaded;
      emit(currentState.clearSearch());
    }
  }

  /// Handle applying filters
  Future<void> _onApplyFilters(ApplyFiltersEvent event, Emitter<ExamState> emit) async {
    _currentFilters = ExamFilters(
      categoryId: event.categoryId,
      difficulty: event.difficulty,
      examType: event.examType,
      isActive: event.isActive,
    );

    if (event.sortBy != null || event.sortOrder != null) {
      _currentSorting = ExamSorting(
        sortBy: event.sortBy ?? _currentSorting.sortBy,
        sortOrder: event.sortOrder ?? _currentSorting.sortOrder,
      );
    }

    // Reload exams with new filters
    add(LoadExamsEvent(
      categoryId: _currentFilters.categoryId,
      difficulty: _currentFilters.difficulty,
      examType: _currentFilters.examType,
      isActive: _currentFilters.isActive,
      sortBy: _currentSorting.sortBy,
      sortOrder: _currentSorting.sortOrder,
      refresh: true,
    ));
  }

  /// Handle clearing filters
  Future<void> _onClearFilters(ClearFiltersEvent event, Emitter<ExamState> emit) async {
    _currentFilters = const ExamFilters();
    
    // Reload exams without filters
    add(LoadExamsEvent(
      sortBy: _currentSorting.sortBy,
      sortOrder: _currentSorting.sortOrder,
      refresh: true,
    ));
  }

  /// Handle changing sorting
  Future<void> _onChangeSorting(ChangeSortingEvent event, Emitter<ExamState> emit) async {
    _currentSorting = ExamSorting(
      sortBy: event.sortBy,
      sortOrder: event.sortOrder,
    );

    // Reload exams with new sorting
    add(LoadExamsEvent(
      categoryId: _currentFilters.categoryId,
      difficulty: _currentFilters.difficulty,
      examType: _currentFilters.examType,
      isActive: _currentFilters.isActive,
      sortBy: _currentSorting.sortBy,
      sortOrder: _currentSorting.sortOrder,
      refresh: true,
    ));
  }

  /// Handle changing view mode
  Future<void> _onChangeViewMode(ChangeViewModeEvent event, Emitter<ExamState> emit) async {
    _currentViewMode = event.viewMode;
    
    if (state is ExamLoaded) {
      final currentState = state as ExamLoaded;
      emit(currentState.copyWith(viewMode: event.viewMode));
    }
  }

  /// Handle retry loading
  Future<void> _onRetryLoading(RetryLoadingEvent event, Emitter<ExamState> emit) async {
    if (state is ExamError) {
      final errorState = state as ExamError;
      if (errorState.previousState != null) {
        emit(errorState.previousState!);
      }
    }
    
    // Retry the last operation
    add(LoadExamsEvent(
      categoryId: _currentFilters.categoryId,
      difficulty: _currentFilters.difficulty,
      examType: _currentFilters.examType,
      isActive: _currentFilters.isActive,
      sortBy: _currentSorting.sortBy,
      sortOrder: _currentSorting.sortOrder,
      refresh: true,
    ));
  }

  /// Handle toggling exam favorite
  Future<void> _onToggleExamFavorite(ToggleExamFavoriteEvent event, Emitter<ExamState> emit) async {
    // This would typically call a use case to update favorite status
    // For now, we'll just update the local state
    if (state is ExamLoaded) {
      final currentState = state as ExamLoaded;
      
      // Update exam in the list
      final updatedExams = currentState.exams.map((exam) {
        if (exam.id == event.examId) {
          // This would need to be implemented in the Exam entity
          // return exam.copyWith(isFavorite: event.isFavorite);
        }
        return exam;
      }).toList();

      emit(currentState.copyWith(
        exams: updatedExams,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Handle starting exam
  Future<void> _onStartExam(StartExamEvent event, Emitter<ExamState> emit) async {
    // This would typically navigate to the exam taking screen
    // Implementation depends on navigation strategy
    print('Starting exam: ${event.examId}');
  }

  /// Handle resuming exam
  Future<void> _onResumeExam(ResumeExamEvent event, Emitter<ExamState> emit) async {
    // This would typically navigate to the exam taking screen with saved progress
    // Implementation depends on navigation strategy
    print('Resuming exam: ${event.examId}');
  }

  /// Handle updating exam progress
  Future<void> _onUpdateExamProgress(UpdateExamProgressEvent event, Emitter<ExamState> emit) async {
    // This would typically call a use case to update exam progress
    // For now, we'll just update the local state
    if (state is ExamLoaded) {
      final currentState = state as ExamLoaded;
      
      // Update exam progress in the list
      final updatedExams = currentState.exams.map((exam) {
        if (exam.id == event.examId) {
          // This would need to be implemented in the Exam entity
          // return exam.copyWith(userProgress: updatedProgress);
        }
        return exam;
      }).toList();

      emit(currentState.copyWith(
        exams: updatedExams,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Get user-friendly error message from failure
  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'No internet connection. Please check your network and try again.';
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case CacheFailure:
        return 'Failed to load cached data. Please refresh.';
      case AuthFailure:
        return 'Authentication failed. Please login again.';
      case ValidationFailure:
        return 'Invalid data provided. Please check your input.';
      default:
        return failure.message ?? 'An unexpected error occurred.';
    }
  }
}