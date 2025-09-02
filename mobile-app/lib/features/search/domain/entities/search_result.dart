/// Search result entity representing a unified search result
class SearchResult {
  final String id;
  final String title;
  final String type; // 'exam', 'quiz', 'category'
  final String? slug;
  final String? description;
  final int? totalQuestions;
  final bool? isFree;
  final String? categoryId;
  final String? categoryName;
  final String? difficulty;
  final int? duration;
  final double? rating;
  final Map<String, dynamic>? metadata;

  const SearchResult({
    required this.id,
    required this.title,
    required this.type,
    this.slug,
    this.description,
    this.totalQuestions,
    this.isFree,
    this.categoryId,
    this.categoryName,
    this.difficulty,
    this.duration,
    this.rating,
    this.metadata,
  });

  /// Create a copy with updated properties
  SearchResult copyWith({
    String? id,
    String? title,
    String? type,
    String? slug,
    String? description,
    int? totalQuestions,
    bool? isFree,
    String? categoryId,
    String? categoryName,
    String? difficulty,
    int? duration,
    double? rating,
    Map<String, dynamic>? metadata,
  }) {
    return SearchResult(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isFree: isFree ?? this.isFree,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if this is an exam result
  bool get isExam => type == 'exam';

  /// Check if this is a quiz result
  bool get isQuiz => type == 'quiz';

  /// Check if this is a category result
  bool get isCategory => type == 'category';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchResult &&
        other.id == id &&
        other.title == title &&
        other.type == type &&
        other.slug == slug &&
        other.description == description &&
        other.totalQuestions == totalQuestions &&
        other.isFree == isFree &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.difficulty == difficulty &&
        other.duration == duration &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      type,
      slug,
      description,
      totalQuestions,
      isFree,
      categoryId,
      categoryName,
      difficulty,
      duration,
      rating,
    );
  }

  @override
  String toString() {
    return 'SearchResult(id: $id, title: $title, type: $type, slug: $slug, description: $description, totalQuestions: $totalQuestions, isFree: $isFree, categoryId: $categoryId, categoryName: $categoryName, difficulty: $difficulty, duration: $duration, rating: $rating, metadata: $metadata)';
  }
}

/// Types of search results
enum SearchResultType {
  exam,
  quiz,
  category,
}

/// Extension for SearchResultType
extension SearchResultTypeExtension on SearchResultType {
  /// Get string representation
  String get value {
    switch (this) {
      case SearchResultType.exam:
        return 'exam';
      case SearchResultType.quiz:
        return 'quiz';
      case SearchResultType.category:
        return 'category';
    }
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case SearchResultType.exam:
        return 'Exam';
      case SearchResultType.quiz:
        return 'Quiz';
      case SearchResultType.category:
        return 'Category';
    }
  }

  /// Create from string
  static SearchResultType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'exam':
        return SearchResultType.exam;
      case 'quiz':
        return SearchResultType.quiz;
      case 'category':
        return SearchResultType.category;
      default:
        throw ArgumentError('Invalid SearchResultType: $value');
    }
  }
}