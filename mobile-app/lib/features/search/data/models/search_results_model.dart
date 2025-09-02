import '../../domain/entities/search_result.dart';
import '../../../core/data/models/paginated_response_model.dart';

/// Model for search results response
class SearchResultsModel {
  final String query;
  final int totalResults;
  final List<SearchResultModel> results;
  final int? currentPage;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  const SearchResultsModel({
    required this.query,
    required this.totalResults,
    required this.results,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  /// Create from JSON
  factory SearchResultsModel.fromJson(Map<String, dynamic> json) {
    return SearchResultsModel(
      query: json['query'] as String,
      totalResults: json['total_results'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => SearchResultModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int?,
      totalPages: json['total_pages'] as int?,
      hasNextPage: json['has_next_page'] as bool?,
      hasPreviousPage: json['has_previous_page'] as bool?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'total_results': totalResults,
      'results': results.map((result) => result.toJson()).toList(),
      if (currentPage != null) 'current_page': currentPage,
      if (totalPages != null) 'total_pages': totalPages,
      if (hasNextPage != null) 'has_next_page': hasNextPage,
      if (hasPreviousPage != null) 'has_previous_page': hasPreviousPage,
    };
  }

  /// Convert to paginated response
  PaginatedResponseModel<SearchResult> toPaginatedResponse() {
    return PaginatedResponseModel<SearchResult>(
      data: results.map((model) => model.toEntity()).toList(),
      currentPage: currentPage ?? 1,
      totalPages: totalPages ?? 1,
      totalItems: totalResults,
      hasNextPage: hasNextPage ?? false,
      hasPreviousPage: hasPreviousPage ?? false,
    );
  }

  /// Create copy with updated properties
  SearchResultsModel copyWith({
    String? query,
    int? totalResults,
    List<SearchResultModel>? results,
    int? currentPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return SearchResultsModel(
      query: query ?? this.query,
      totalResults: totalResults ?? this.totalResults,
      results: results ?? this.results,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }
}

/// Model for individual search result
class SearchResultModel {
  final String id;
  final String title;
  final String type;
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

  const SearchResultModel({
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

  /// Create from JSON
  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      type: json['type'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      totalQuestions: json['total_questions'] as int?,
      isFree: json['is_free'] as bool?,
      categoryId: json['category_id']?.toString(),
      categoryName: json['category_name'] as String?,
      difficulty: json['difficulty'] as String?,
      duration: json['duration'] as int?,
      rating: (json['rating'] as num?)?.toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (isFree != null) 'is_free': isFree,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (difficulty != null) 'difficulty': difficulty,
      if (duration != null) 'duration': duration,
      if (rating != null) 'rating': rating,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Convert to entity
  SearchResult toEntity() {
    return SearchResult(
      id: id,
      title: title,
      type: type,
      slug: slug,
      description: description,
      totalQuestions: totalQuestions,
      isFree: isFree,
      categoryId: categoryId,
      categoryName: categoryName,
      difficulty: difficulty,
      duration: duration,
      rating: rating,
      metadata: metadata,
    );
  }

  /// Create from entity
  factory SearchResultModel.fromEntity(SearchResult entity) {
    return SearchResultModel(
      id: entity.id,
      title: entity.title,
      type: entity.type,
      slug: entity.slug,
      description: entity.description,
      totalQuestions: entity.totalQuestions,
      isFree: entity.isFree,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      difficulty: entity.difficulty,
      duration: entity.duration,
      rating: entity.rating,
      metadata: entity.metadata,
    );
  }

  /// Create copy with updated properties
  SearchResultModel copyWith({
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
    return SearchResultModel(
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
}