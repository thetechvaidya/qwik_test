import 'package:hive/hive.dart';
import '../../domain/entities/search_history.dart';

part 'search_history_model.g.dart';

/// Search history model for Hive and JSON serialization
@HiveType(typeId: 10)
class SearchHistoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String query;

  @HiveField(2)
  final DateTime searchedAt;

  @HiveField(3)
  final int frequency;

  @HiveField(4)
  final String? categoryId;

  @HiveField(5)
  final String? categoryName;

  @HiveField(6)
  final Map<String, dynamic>? filters;

  SearchHistoryModel({
    required this.id,
    required this.query,
    required this.searchedAt,
    required this.frequency,
    this.categoryId,
    this.categoryName,
    this.filters,
  });

  /// Create from JSON
  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      id: json['id'] as String,
      query: json['query'] as String,
      searchedAt: DateTime.parse(json['searched_at'] as String),
      frequency: json['frequency'] as int? ?? 1,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      filters: json['filters'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'searched_at': searchedAt.toIso8601String(),
      'frequency': frequency,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (filters != null) 'filters': filters,
    };
  }

  /// Create from domain entity
  factory SearchHistoryModel.fromEntity(SearchHistory entity) {
    return SearchHistoryModel(
      id: entity.id,
      query: entity.query,
      searchedAt: entity.searchedAt,
      frequency: entity.frequency,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      filters: entity.filters,
    );
  }

  /// Convert to domain entity
  SearchHistory toEntity() {
    return SearchHistory(
      id: id,
      query: query,
      searchedAt: searchedAt,
      frequency: frequency,
      categoryId: categoryId,
      categoryName: categoryName,
      filters: filters,
    );
  }

  /// Create a copy with updated properties
  SearchHistoryModel copyWith({
    String? id,
    String? query,
    DateTime? searchedAt,
    int? frequency,
    String? categoryId,
    String? categoryName,
    Map<String, dynamic>? filters,
  }) {
    return SearchHistoryModel(
      id: id ?? this.id,
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
      frequency: frequency ?? this.frequency,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      filters: filters ?? this.filters,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchHistoryModel &&
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
    return 'SearchHistoryModel(id: $id, query: $query, searchedAt: $searchedAt, frequency: $frequency, categoryId: $categoryId, categoryName: $categoryName, filters: $filters)';
  }
}