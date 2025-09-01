import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/exam_repository.dart';

/// Use case for getting exam categories
class GetCategoriesUseCase implements UseCase<List<Category>, GetCategoriesParams> {
  final ExamRepository _repository;

  GetCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, List<Category>>> call(GetCategoriesParams params) async {
    return await _repository.getCategories(
      parentId: params.parentId,
      activeOnly: params.activeOnly,
    );
  }
}

/// Parameters for GetCategoriesUseCase
class GetCategoriesParams {
  final String? parentId;
  final bool? activeOnly;

  const GetCategoriesParams({
    this.parentId,
    this.activeOnly,
  });

  /// Create params for root categories only
  const GetCategoriesParams.rootOnly() : this(parentId: null, activeOnly: true);

  /// Create params for subcategories of a parent
  const GetCategoriesParams.subcategories(String parentId) : this(parentId: parentId, activeOnly: true);

  /// Create params for all categories (including inactive)
  const GetCategoriesParams.all() : this(parentId: null, activeOnly: null);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetCategoriesParams &&
        other.parentId == parentId &&
        other.activeOnly == activeOnly;
  }

  @override
  int get hashCode => Object.hash(parentId, activeOnly);

  @override
  String toString() => 'GetCategoriesParams(parentId: $parentId, activeOnly: $activeOnly)';
}