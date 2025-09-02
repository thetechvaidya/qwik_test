import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../models/exam_model.dart';
import '../models/category_model.dart';

// UserExamProgressModel is defined in exam_model.dart, so it's already imported

/// Abstract interface for exam remote data source
abstract class ExamRemoteDataSource {
  /// Get paginated list of exams
  Future<PaginatedResponse<ExamModel>> getExams({
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

  /// Get exam by ID
  Future<ExamModel> getExamById(String examId);

  /// Get exam categories
  Future<List<CategoryModel>> getCategories({
    String? parentId,
    bool? activeOnly,
  });

  /// Get category by ID
  Future<CategoryModel> getCategoryById(String categoryId);

  /// Search exams
  Future<PaginatedResponse<ExamModel>> searchExams({
    required String query,
    required PaginationParams pagination,
    String? categoryId,
    String? difficulty,
    String? type,
  });

  /// Get featured exams
  Future<List<ExamModel>> getFeaturedExams({int limit = 10});

  /// Get recent exams
  Future<List<ExamModel>> getRecentExams({int limit = 10});

  /// Get popular exams
  Future<List<ExamModel>> getPopularExams({int limit = 10});

  /// Get user's exam progress
  Future<UserExamProgressModel?> getUserExamProgress(String examId);

  /// Update user's exam progress
  Future<UserExamProgressModel> updateUserExamProgress(
    String examId,
    Map<String, dynamic> progressData,
  );
}

/// Implementation of exam remote data source
class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  final Dio _dio;

  ExamRemoteDataSourceImpl({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<PaginatedResponse<ExamModel>> getExams({
    required PaginationParams pagination,
    String? categoryId,
    String? subcategoryId,
    String? difficulty,
    String? type,
    String? search,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = {
        ...pagination.toJson(),
        if (categoryId != null) 'category_id': categoryId,
        if (subcategoryId != null) 'subcategory_id': subcategoryId,
        if (difficulty != null) 'difficulty': difficulty,
        if (type != null) 'type': type,
        if (search != null) 'search': search,
        if (isActive != null) 'is_active': isActive,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
      };

      final response = await _dio.get(
        ApiEndpoints.exams,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedResponse.fromJson(
          response.data,
          (json) => ExamModel.fromJson(json),
        );
      } else {
        throw ServerException(
          message: 'Failed to fetch exams',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<ExamModel> getExamById(String examId) async {
    try {
      final response = await _dio.get(ApiEndpoints.examDetail(examId));

      if (response.statusCode == 200) {
        return ExamModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: 'Failed to fetch exam details',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories({
    String? parentId,
    bool? activeOnly,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (parentId != null) queryParams['parent_id'] = parentId;
      if (activeOnly != null) queryParams['active_only'] = activeOnly;

      final response = await _dio.get(
        ApiEndpoints.categories,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = response.data['data'];
        return categoriesJson
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch categories',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    try {
      final response = await _dio.get(ApiEndpoints.categoryDetail(categoryId));

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: 'Failed to fetch category details',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<PaginatedResponse<ExamModel>> searchExams({
    required String query,
    required PaginationParams pagination,
    String? categoryId,
    String? difficulty,
    String? type,
  }) async {
    try {
      final queryParams = {
        'q': query,
        ...pagination.toJson(),
        if (categoryId != null) 'category_id': categoryId,
        if (difficulty != null) 'difficulty': difficulty,
        if (type != null) 'type': type,
      };

      final response = await _dio.get(
        ApiEndpoints.search,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedResponse.fromJson(
          response.data,
          (json) => ExamModel.fromJson(json),
        );
      } else {
        throw ServerException(
          message: 'Failed to search exams',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ExamModel>> getFeaturedExams({int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.featuredExams,
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> examsJson = response.data['data'];
        return examsJson.map((json) => ExamModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch featured exams',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ExamModel>> getRecentExams({int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.recentExams,
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> examsJson = response.data['data'];
        return examsJson.map((json) => ExamModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch recent exams',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ExamModel>> getPopularExams({int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.popularExams,
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> examsJson = response.data['data'];
        return examsJson.map((json) => ExamModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch popular exams',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<UserExamProgressModel?> getUserExamProgress(String examId) async {
    try {
      final response = await _dio.get(ApiEndpoints.userExamAttempts(examId));

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return data != null ? UserExamProgressModel.fromJson(data) : null;
      } else if (response.statusCode == 404) {
        return null; // No progress found
      } else {
        throw ServerException(
          message: 'Failed to fetch exam progress',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // No progress found
      }
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<UserExamProgressModel> updateUserExamProgress(
    String examId,
    Map<String, dynamic> progressData,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.userExamAttempts(examId),
        data: progressData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserExamProgressModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: 'Failed to update exam progress',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  /// Handle Dio exceptions and convert to appropriate exceptions
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Server error occurred';
        
        if (statusCode == 401) {
          return UnauthorizedException(message: message);
        } else if (statusCode == 403) {
          return ForbiddenException(message: message);
        } else if (statusCode == 404) {
          return NotFoundException(message: message);
        } else if (statusCode == 422) {
          return ValidationException(
            message: message,
            errors: e.response?.data?['errors'],
          );
        } else {
          return ServerException(
            message: message,
            statusCode: statusCode,
          );
        }
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request was cancelled');
      case DioExceptionType.unknown:
      default:
        return NetworkException(message: 'Network error occurred');
    }
  }
}