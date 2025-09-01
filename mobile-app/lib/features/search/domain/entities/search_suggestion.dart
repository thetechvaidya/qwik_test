/// Search suggestion entity for providing intelligent search suggestions
class SearchSuggestion {
  final String id;
  final String text;
  final SearchSuggestionType type;
  final String? categoryId;
  final String? categoryName;
  final String? examId;
  final String? examTitle;
  final int popularity; // How popular this suggestion is
  final Map<String, dynamic>? metadata; // Additional data for the suggestion

  const SearchSuggestion({
    required this.id,
    required this.text,
    required this.type,
    required this.popularity,
    this.categoryId,
    this.categoryName,
    this.examId,
    this.examTitle,
    this.metadata,
  });

  /// Create a copy with updated properties
  SearchSuggestion copyWith({
    String? id,
    String? text,
    SearchSuggestionType? type,
    String? categoryId,
    String? categoryName,
    String? examId,
    String? examTitle,
    int? popularity,
    Map<String, dynamic>? metadata,
  }) {
    return SearchSuggestion(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      examId: examId ?? this.examId,
      examTitle: examTitle ?? this.examTitle,
      popularity: popularity ?? this.popularity,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if suggestion is for a specific exam
  bool get isExamSuggestion => type == SearchSuggestionType.exam && examId != null;

  /// Check if suggestion is for a category
  bool get isCategorySuggestion => type == SearchSuggestionType.category && categoryId != null;

  /// Check if suggestion is a general query
  bool get isQuerySuggestion => type == SearchSuggestionType.query;

  /// Check if suggestion is from history
  bool get isHistorySuggestion => type == SearchSuggestionType.history;

  /// Get display text with context
  String get displayText {
    switch (type) {
      case SearchSuggestionType.exam:
        return examTitle ?? text;
      case SearchSuggestionType.category:
        return 'in ${categoryName ?? text}';
      case SearchSuggestionType.query:
      case SearchSuggestionType.history:
        return text;
    }
  }

  /// Get subtitle text for additional context
  String? get subtitle {
    switch (type) {
      case SearchSuggestionType.exam:
        return categoryName != null ? 'in $categoryName' : null;
      case SearchSuggestionType.category:
        return 'Category';
      case SearchSuggestionType.query:
        return 'Search for "$text"';
      case SearchSuggestionType.history:
        return 'Recent search';
    }
  }

  /// Get icon name for the suggestion type
  String get iconName {
    switch (type) {
      case SearchSuggestionType.exam:
        return 'quiz';
      case SearchSuggestionType.category:
        return 'category';
      case SearchSuggestionType.query:
        return 'search';
      case SearchSuggestionType.history:
        return 'history';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchSuggestion &&
        other.id == id &&
        other.text == text &&
        other.type == type &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.examId == examId &&
        other.examTitle == examTitle &&
        other.popularity == popularity;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      text,
      type,
      categoryId,
      categoryName,
      examId,
      examTitle,
      popularity,
    );
  }

  @override
  String toString() {
    return 'SearchSuggestion(id: $id, text: $text, type: $type, categoryId: $categoryId, categoryName: $categoryName, examId: $examId, examTitle: $examTitle, popularity: $popularity, metadata: $metadata)';
  }
}

/// Types of search suggestions
enum SearchSuggestionType {
  /// Direct exam suggestion
  exam,
  
  /// Category suggestion
  category,
  
  /// General query suggestion
  query,
  
  /// From search history
  history,
}

/// Extension for SearchSuggestionType
extension SearchSuggestionTypeExtension on SearchSuggestionType {
  /// Get display name for the suggestion type
  String get displayName {
    switch (this) {
      case SearchSuggestionType.exam:
        return 'Exam';
      case SearchSuggestionType.category:
        return 'Category';
      case SearchSuggestionType.query:
        return 'Search';
      case SearchSuggestionType.history:
        return 'Recent';
    }
  }

  /// Get priority for sorting suggestions
  int get priority {
    switch (this) {
      case SearchSuggestionType.exam:
        return 4; // Highest priority
      case SearchSuggestionType.category:
        return 3;
      case SearchSuggestionType.history:
        return 2;
      case SearchSuggestionType.query:
        return 1; // Lowest priority
    }
  }
}