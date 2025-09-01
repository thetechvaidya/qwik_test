import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Generic paginated response wrapper for API responses
class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  final bool hasMorePages;
  final String? nextPageUrl;
  final String? prevPageUrl;

  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    required this.hasMorePages,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  /// Create from API response JSON
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    return PaginatedResponse<T>(
      data: dataList,
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      total: json['total'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 15,
      hasMorePages: (json['current_page'] as int? ?? 1) < (json['last_page'] as int? ?? 1),
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
    );
  }

  /// Create empty response
  factory PaginatedResponse.empty() {
    return const PaginatedResponse<T>(
      data: [],
      currentPage: 1,
      lastPage: 1,
      total: 0,
      perPage: 15,
      hasMorePages: false,
    );
  }

  /// Merge with another paginated response (for loading more pages)
  PaginatedResponse<T> merge(PaginatedResponse<T> other) {
    return PaginatedResponse<T>(
      data: [...data, ...other.data],
      currentPage: other.currentPage,
      lastPage: other.lastPage,
      total: other.total,
      perPage: other.perPage,
      hasMorePages: other.hasMorePages,
      nextPageUrl: other.nextPageUrl,
      prevPageUrl: other.prevPageUrl,
    );
  }

  /// Create a copy with updated data
  PaginatedResponse<T> copyWith({
    List<T>? data,
    int? currentPage,
    int? lastPage,
    int? total,
    int? perPage,
    bool? hasMorePages,
    String? nextPageUrl,
    String? prevPageUrl,
  }) {
    return PaginatedResponse<T>(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      perPage: perPage ?? this.perPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
    );
  }

  @override
  List<Object?> get props => [
        data,
        currentPage,
        lastPage,
        total,
        perPage,
        hasMorePages,
        nextPageUrl,
        prevPageUrl,
      ];
}

/// State management for pagination UI
class PaginationState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final int currentPage;
  final Failure? error;
  final bool isRefreshing;

  const PaginationState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.error,
    this.isRefreshing = false,
  });

  /// Initial state
  factory PaginationState.initial() {
    return const PaginationState();
  }

  /// Loading first page
  factory PaginationState.loading() {
    return const PaginationState(isLoading: true);
  }

  /// Loading more pages
  factory PaginationState.loadingMore(int currentPage) {
    return PaginationState(
      isLoadingMore: true,
      currentPage: currentPage,
    );
  }

  /// Refreshing data
  factory PaginationState.refreshing() {
    return const PaginationState(isRefreshing: true);
  }

  /// Success state
  factory PaginationState.success({
    required int currentPage,
    required bool hasReachedMax,
  }) {
    return PaginationState(
      currentPage: currentPage,
      hasReachedMax: hasReachedMax,
    );
  }

  /// Error state
  factory PaginationState.error(Failure failure) {
    return PaginationState(error: failure);
  }

  /// Copy with updated values
  PaginationState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    int? currentPage,
    Failure? error,
    bool? isRefreshing,
    bool clearError = false,
  }) {
    return PaginationState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      error: clearError ? null : (error ?? this.error),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingMore,
        hasReachedMax,
        currentPage,
        error,
        isRefreshing,
      ];
}

/// Controller for managing pagination logic
class PaginationController {
  PaginationState _state = PaginationState.initial();
  
  /// Current pagination state
  PaginationState get state => _state;

  /// Update the pagination state
  void updateState(PaginationState newState) {
    _state = newState;
  }

  /// Reset pagination to initial state
  void reset() {
    _state = PaginationState.initial();
  }

  /// Check if can load more pages
  bool canLoadMore() {
    return !_state.isLoading && 
           !_state.isLoadingMore && 
           !_state.hasReachedMax && 
           _state.error == null;
  }

  /// Check if should show loading indicator
  bool shouldShowLoading() {
    return _state.isLoading && _state.currentPage == 1;
  }

  /// Check if should show load more indicator
  bool shouldShowLoadMore() {
    return _state.isLoadingMore;
  }

  /// Check if should show refresh indicator
  bool shouldShowRefresh() {
    return _state.isRefreshing;
  }

  /// Get next page number
  int getNextPage() {
    return _state.currentPage + 1;
  }

  /// Handle successful page load
  void handlePageLoaded(PaginatedResponse response) {
    _state = PaginationState.success(
      currentPage: response.currentPage,
      hasReachedMax: !response.hasMorePages,
    );
  }

  /// Handle load more success
  void handleLoadMoreSuccess(PaginatedResponse response) {
    _state = PaginationState.success(
      currentPage: response.currentPage,
      hasReachedMax: !response.hasMorePages,
    );
  }

  /// Handle error
  void handleError(Failure failure) {
    _state = PaginationState.error(failure);
  }

  /// Start loading first page
  void startLoading() {
    _state = PaginationState.loading();
  }

  /// Start loading more pages
  void startLoadingMore() {
    _state = PaginationState.loadingMore(_state.currentPage);
  }

  /// Start refreshing
  void startRefreshing() {
    _state = PaginationState.refreshing();
  }
}

/// Pagination parameters for API requests
class PaginationParams extends Equatable {
  final int page;
  final int perPage;

  const PaginationParams({
    this.page = 1,
    this.perPage = 15,
  });

  /// Convert to query parameters
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'per_page': perPage,
    };
  }

  /// Create copy with updated values
  PaginationParams copyWith({
    int? page,
    int? perPage,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  @override
  List<Object?> get props => [page, perPage];
}

/// Utility functions for pagination
class PaginationUtils {
  /// Calculate total pages from total items and per page
  static int calculateTotalPages(int total, int perPage) {
    if (total == 0 || perPage == 0) return 1;
    return (total / perPage).ceil();
  }

  /// Check if page number is valid
  static bool isValidPage(int page, int totalPages) {
    return page > 0 && page <= totalPages;
  }

  /// Get page range for pagination UI
  static List<int> getPageRange(int currentPage, int totalPages, {int maxVisible = 5}) {
    if (totalPages <= maxVisible) {
      return List.generate(totalPages, (index) => index + 1);
    }

    final half = maxVisible ~/ 2;
    int start = currentPage - half;
    int end = currentPage + half;

    if (start < 1) {
      start = 1;
      end = maxVisible;
    } else if (end > totalPages) {
      end = totalPages;
      start = totalPages - maxVisible + 1;
    }

    return List.generate(end - start + 1, (index) => start + index);
  }

  /// Create pagination info text
  static String getPaginationInfo(int currentPage, int totalPages, int total) {
    if (total == 0) return 'No items found';
    if (totalPages == 1) return 'Showing all $total items';
    return 'Page $currentPage of $totalPages ($total total items)';
  }
}