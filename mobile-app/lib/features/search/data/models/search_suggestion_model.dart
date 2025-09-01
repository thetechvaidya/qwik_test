import 'package:hive/hive.dart';
import '../../domain/entities/search_suggestion.dart';

part 'search_suggestion_model.g.dart';

/// Search suggestion model for Hive and JSON serialization
@HiveType(typeId: 11)
class SearchSuggestionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final SearchSuggestionTypeModel type;

  @HiveField(3)
  final String? categoryId;

  @HiveField(4)
  final String? categoryName;

  @HiveField(5)
  final String? examId;

  @HiveField(6)
  final String? examTitle;

  @HiveField(7)
  final int popularity;

  @HiveField(8)
  final Map<String, dynamic>? metadata;

  SearchSuggestionModel({
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

  /// Create from JSON
  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      type: SearchSuggestionTypeModel.fromString(json['type'] as String),
      popularity: json['popularity'] as int? ?? 0,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      examId: json['exam_id'] as String?,
      examTitle: json['exam_title'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString(),
      'popularity': popularity,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (examId != null) 'exam_id': examId,
      if (examTitle != null) 'exam_title': examTitle,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Create from domain entity
  factory SearchSuggestionModel.fromEntity(SearchSuggestion entity) {
    return SearchSuggestionModel(
      id: entity.id,
      text: entity.text,
      type: SearchSuggestionTypeModel.fromEntity(entity.type),
      popularity: entity.popularity,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      examId: entity.examId,
      examTitle: entity.examTitle,
      metadata: entity.metadata,
    );
  }

  /// Convert to domain entity
  SearchSuggestion toEntity() {
    return SearchSuggestion(
      id: id,
      text: text,
      type: type.toEntity(),
      popularity: popularity,
      categoryId: categoryId,
      categoryName: categoryName,
      examId: examId,
      examTitle: examTitle,
      metadata: metadata,
    );
  }

  /// Create a copy with updated properties
  SearchSuggestionModel copyWith({
    String? id,
    String? text,
    SearchSuggestionTypeModel? type,
    String? categoryId,
    String? categoryName,
    String? examId,
    String? examTitle,
    int? popularity,
    Map<String, dynamic>? metadata,
  }) {
    return SearchSuggestionModel(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchSuggestionModel &&
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
    return 'SearchSuggestionModel(id: $id, text: $text, type: $type, categoryId: $categoryId, categoryName: $categoryName, examId: $examId, examTitle: $examTitle, popularity: $popularity, metadata: $metadata)';
  }
}

/// Search suggestion type model for Hive serialization
@HiveType(typeId: 12)
enum SearchSuggestionTypeModel {
  @HiveField(0)
  exam,
  
  @HiveField(1)
  category,
  
  @HiveField(2)
  query,
  
  @HiveField(3)
  history;

  /// Create from string
  static SearchSuggestionTypeModel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'exam':
        return SearchSuggestionTypeModel.exam;
      case 'category':
        return SearchSuggestionTypeModel.category;
      case 'query':
        return SearchSuggestionTypeModel.query;
      case 'history':
        return SearchSuggestionTypeModel.history;
      default:
        return SearchSuggestionTypeModel.query;
    }
  }

  /// Create from domain entity
  static SearchSuggestionTypeModel fromEntity(SearchSuggestionType entity) {
    switch (entity) {
      case SearchSuggestionType.exam:
        return SearchSuggestionTypeModel.exam;
      case SearchSuggestionType.category:
        return SearchSuggestionTypeModel.category;
      case SearchSuggestionType.query:
        return SearchSuggestionTypeModel.query;
      case SearchSuggestionType.history:
        return SearchSuggestionTypeModel.history;
    }
  }

  /// Convert to domain entity
  SearchSuggestionType toEntity() {
    switch (this) {
      case SearchSuggestionTypeModel.exam:
        return SearchSuggestionType.exam;
      case SearchSuggestionTypeModel.category:
        return SearchSuggestionType.category;
      case SearchSuggestionTypeModel.query:
        return SearchSuggestionType.query;
      case SearchSuggestionTypeModel.history:
        return SearchSuggestionType.history;
    }
  }

  @override
  String toString() {
    switch (this) {
      case SearchSuggestionTypeModel.exam:
        return 'exam';
      case SearchSuggestionTypeModel.category:
        return 'category';
      case SearchSuggestionTypeModel.query:
        return 'query';
      case SearchSuggestionTypeModel.history:
        return 'history';
    }
  }
}