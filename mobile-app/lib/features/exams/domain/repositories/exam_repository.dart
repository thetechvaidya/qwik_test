import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../entities/exam.dart';
import '../entities/category.dart';

/// Abstract repository interface for exam operations
abstract class ExamRepository {
  /// Get paginated list of exams with optional filters
  Future<Either<Failure, PaginatedResponse<Exam>>> getExams({
    required PaginationParams pagination,
    String? categoryId,
    String? subcategoryId,
    String? difficulty,
    String? type,
    String? search,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  });

  /// Get a specific exam by ID
  Future<Either<Failure, Exam>> getExamById(String examId);

  /// Get list of categories with optional filters
  Future<Either<Failure, List<Category>>> getCategories({
    String? parentId,
    bool? activeOnly,
  });

  /// Get a specific category by ID
  Future<Either<Failure, Category>> getCategoryById(String categoryId);

  /// Search exams with query and filters
  Future<Either<Failure, PaginatedResponse<Exam>>> searchExams({
    required String query,
    required PaginationParams pagination,
    String? categoryId,
    String? difficulty,
    String? type,
  });
}