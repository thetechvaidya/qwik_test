import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

/// Use case for searching exams
class SearchExamsUseCase implements UseCase<PaginatedResponse<Exam>, SearchExamsParams> {
  final ExamRepository _repository;

  SearchExamsUseCase(this._repository);

  @override
  Future<Either<Failure, PaginatedResponse<Exam>>> call(SearchExamsParams params) async {
    return await _repository.searchExams(
      query: params.query,
      pagination: params.pagination,
      categoryId: params.categoryId,
      difficulty: params.difficulty,
      type: params.type,
    );
  }
}

/// Parameters for SearchExamsUseCase
class SearchExamsParams {
  final String query;
  final PaginationParams pagination;
  final String? categoryId;
  final String? difficulty;
  final String? type;

  const SearchExamsParams({
    required this.query,
    required this.pagination,
    this.categoryId,
    this.difficulty,
    this.type,
  });

  /// Create a copy with updated parameters
  SearchExamsParams copyWith({
    String? query,
    PaginationParams? pagination,
    String? categoryId,
    String? difficulty,
    String? type,
  }) {
    return SearchExamsParams(
      query: query ?? this.query,
      pagination: pagination ?? this.pagination,
      categoryId: categoryId ?? this.categoryId,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
    );
  }

  /// Clear all filters except query and pagination
  SearchExamsParams clearFilters() {
    return SearchExamsParams(
      query: query,
      pagination: pagination,
      categoryId: null,
      difficulty: null,
      type: null,
    );
  }

  /// Check if any filters are applied
  bool get hasFilters {
    return categoryId != null || difficulty != null || type != null;
  }

  /// Check if query is valid (not empty after trimming)
  bool get hasValidQuery {
    return query.trim().isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchExamsParams &&
        other.query == query &&
        other.pagination == pagination &&
        other.categoryId == categoryId &&
        other.difficulty == difficulty &&
        other.type == type;
  }

  @override
  int get hashCode {
    return Object.hash(
      query,
      pagination,
      categoryId,
      difficulty,
      type,
    );
  }

  @override
  String toString() {
    return 'SearchExamsParams(query: $query, pagination: $pagination, categoryId: $categoryId, difficulty: $difficulty, type: $type)';
  }
}