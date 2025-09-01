import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

/// Use case for getting paginated exams with filters
class GetExamsUseCase implements UseCase<PaginatedResponse<Exam>, GetExamsParams> {
  final ExamRepository _repository;

  GetExamsUseCase(this._repository);

  @override
  Future<Either<Failure, PaginatedResponse<Exam>>> call(GetExamsParams params) async {
    return await _repository.getExams(
      pagination: params.pagination,
      categoryId: params.categoryId,
      subcategoryId: params.subcategoryId,
      difficulty: params.difficulty,
      type: params.type,
      search: params.search,
      isActive: params.isActive,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}

/// Parameters for GetExamsUseCase
class GetExamsParams {
  final PaginationParams pagination;
  final String? categoryId;
  final String? subcategoryId;
  final String? difficulty;
  final String? type;
  final String? search;
  final bool? isActive;
  final String? sortBy;
  final String? sortOrder;

  const GetExamsParams({
    required this.pagination,
    this.categoryId,
    this.subcategoryId,
    this.difficulty,
    this.type,
    this.search,
    this.isActive,
    this.sortBy,
    this.sortOrder,
  });

  /// Create a copy with updated parameters
  GetExamsParams copyWith({
    PaginationParams? pagination,
    String? categoryId,
    String? subcategoryId,
    String? difficulty,
    String? type,
    String? search,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) {
    return GetExamsParams(
      pagination: pagination ?? this.pagination,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      search: search ?? this.search,
      isActive: isActive ?? this.isActive,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Clear all filters except pagination
  GetExamsParams clearFilters() {
    return GetExamsParams(
      pagination: pagination,
      categoryId: null,
      subcategoryId: null,
      difficulty: null,
      type: null,
      search: null,
      isActive: null,
      sortBy: null,
      sortOrder: null,
    );
  }

  /// Check if any filters are applied
  bool get hasFilters {
    return categoryId != null ||
        subcategoryId != null ||
        difficulty != null ||
        type != null ||
        search != null ||
        isActive != null ||
        sortBy != null ||
        sortOrder != null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetExamsParams &&
        other.pagination == pagination &&
        other.categoryId == categoryId &&
        other.subcategoryId == subcategoryId &&
        other.difficulty == difficulty &&
        other.type == type &&
        other.search == search &&
        other.isActive == isActive &&
        other.sortBy == sortBy &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    return Object.hash(
      pagination,
      categoryId,
      subcategoryId,
      difficulty,
      type,
      search,
      isActive,
      sortBy,
      sortOrder,
    );
  }

  @override
  String toString() {
    return 'GetExamsParams(pagination: $pagination, categoryId: $categoryId, subcategoryId: $subcategoryId, difficulty: $difficulty, type: $type, search: $search, isActive: $isActive, sortBy: $sortBy, sortOrder: $sortOrder)';
  }
}