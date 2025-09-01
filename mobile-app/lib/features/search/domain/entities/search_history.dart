/// Search history entity for tracking user search queries
class SearchHistory {
  final String id;
  final String query;
  final DateTime searchedAt;
  final int frequency; // How many times this query was searched
  final String? categoryId;
  final String? categoryName;
  final Map<String, dynamic>? filters; // Additional filters used with this search

  const SearchHistory({
    required this.id,
    required this.query,
    required this.searchedAt,
    required this.frequency,
    this.categoryId,
    this.categoryName,
    this.filters,
  });

  /// Create a copy with updated properties
  SearchHistory copyWith({
    String? id,
    String? query,
    DateTime? searchedAt,
    int? frequency,
    String? categoryId,
    String? categoryName,
    Map<String, dynamic>? filters,
  }) {
    return SearchHistory(
      id: id ?? this.id,
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
      frequency: frequency ?? this.frequency,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      filters: filters ?? this.filters,
    );
  }

  /// Increment the frequency count
  SearchHistory incrementFrequency() {
    return copyWith(
      frequency: frequency + 1,
      searchedAt: DateTime.now(),
    );
  }

  /// Check if search has category filter
  bool get hasCategory => categoryId != null && categoryId!.isNotEmpty;

  /// Check if search has additional filters
  bool get hasFilters => filters != null && filters!.isNotEmpty;

  /// Get formatted search date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(searchedAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${searchedAt.day}/${searchedAt.month}/${searchedAt.year}';
    }
  }

  /// Get display text for the search item
  String get displayText {
    if (hasCategory) {
      return '$query in $categoryName';
    }
    return query;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchHistory &&
        other.id == id &&
        other.query == query &&
        other.searchedAt == searchedAt &&
        other.frequency == frequency &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      query,
      searchedAt,
      frequency,
      categoryId,
      categoryName,
    );
  }

  @override
  String toString() {
    return 'SearchHistory(id: $id, query: $query, searchedAt: $searchedAt, frequency: $frequency, categoryId: $categoryId, categoryName: $categoryName, filters: $filters)';
  }
}