import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../../domain/entities/exam.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/exam_repository.dart';
import '../datasources/exam_remote_datasource.dart';
import '../datasources/exam_local_datasource.dart';
import '../models/exam_model.dart';
import '../models/category_model.dart';

/// Implementation of exam repository
class ExamRepositoryImpl implements ExamRepository {
  final ExamRemoteDataSource _remoteDataSource;
  final ExamLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ExamRepositoryImpl({
    required ExamRemoteDataSource remoteDataSource,
    required ExamLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
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
  }) async {
    try {
      final cacheKey = _generateCacheKey({
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'difficulty': difficulty,
        'type': type,
        'search': search,
        'isActive': isActive,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      });

      if (await _networkInfo.isConnected) {
        try {
          // Fetch from remote
          final remoteResponse = await _remoteDataSource.getExams(
            pagination: pagination,
            categoryId: categoryId,
            subcategoryId: subcategoryId,
            difficulty: difficulty,
            type: type,
            search: search,
            isActive: isActive,
            sortBy: sortBy,
            sortOrder: sortOrder,
          );

          // Cache the results
          if (remoteResponse.data.isNotEmpty) {
            await _localDataSource.cacheExams(
              remoteResponse.data,
              cacheKey: cacheKey,
            );
          }

          // Convert to domain entities
          final domainExams = remoteResponse.data
              .map((model) => model.toEntity())
              .toList();

          final domainResponse = PaginatedResponse<Exam>(
            data: domainExams,
            currentPage: remoteResponse.currentPage,
            lastPage: remoteResponse.lastPage,
            total: remoteResponse.total,
            perPage: remoteResponse.perPage,
            hasMorePages: remoteResponse.hasMorePages,
            nextPageUrl: remoteResponse.nextPageUrl,
            prevPageUrl: remoteResponse.prevPageUrl,
          );

          return Right(domainResponse);
        } catch (e) {
          // If remote fails, try to get from cache
          return await _getExamsFromCache(cacheKey, pagination);
        }
      } else {
        // No internet, get from cache
        return await _getExamsFromCache(cacheKey, pagination);
      }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Exam>> getExamById(String examId) async {
    try {
      if (await _networkInfo.isConnected) {
        try {
          // Fetch from remote
          final remoteExam = await _remoteDataSource.getExamById(examId);
          
          // Cache the result
          await _localDataSource.cacheExam(remoteExam);
          
          return Right(remoteExam.toEntity());
        } catch (e) {
          // If remote fails, try to get from cache
          final cachedExam = await _localDataSource.getCachedExam(examId);
          if (cachedExam != null) {
            return Right(cachedExam.toEntity());
          }
          rethrow;
        }
      } else {
        // No internet, get from cache
        final cachedExam = await _localDataSource.getCachedExam(examId);
        if (cachedExam != null) {
          return Right(cachedExam.toEntity());
        } else {
          return const Left(NetworkFailure(message: 'No internet connection and exam not cached'));
        }
      }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories({
    String? parentId,
    bool? activeOnly,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        try {
          // Fetch from remote
          final remoteCategories = await _remoteDataSource.getCategories(
            parentId: parentId,
            activeOnly: activeOnly,
          );
          
          // Cache the results
          await _localDataSource.cacheCategories(remoteCategories);
          
          // Convert to domain entities
          final domainCategories = remoteCategories
              .map((model) => model.toEntity())
              .toList();
          
          return Right(domainCategories);
        } catch (e) {
          // If remote fails, try to get from cache
          final cachedCategories = await _localDataSource.getCachedCategories(
            parentId: parentId,
          );
          
          final domainCategories = cachedCategories
              .map((model) => model.toEntity())
              .toList();
          
          return Right(domainCategories);
        }
      } else {
        // No internet, get from cache
        final cachedCategories = await _localDataSource.getCachedCategories(
          parentId: parentId,
        );
        
        final domainCategories = cachedCategories
            .map((model) => model.toEntity())
            .toList();
        
        return Right(domainCategories);
      }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String categoryId) async {
    try {
      if (await _networkInfo.isConnected) {
        try {
          // Fetch from remote
          final remoteCategory = await _remoteDataSource.getCategoryById(categoryId);
          
          // Cache the result
          await _localDataSource.cacheCategory(remoteCategory);
          
          return Right(remoteCategory.toEntity());
        } catch (e) {
          // If remote fails, try to get from cache
          final cachedCategory = await _localDataSource.getCachedCategory(categoryId);
          if (cachedCategory != null) {
            return Right(cachedCategory.toEntity());
          }
          rethrow;
        }
      } else {
        // No internet, get from cache
        final cachedCategory = await _localDataSource.getCachedCategory(categoryId);
        if (cachedCategory != null) {
          return Right(cachedCategory.toEntity());
        } else {
          return const Left(NetworkFailure(message: 'No internet connection and category not cached'));
        }
      }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<Exam>>> searchExams({
    required String query,
    required PaginationParams pagination,
    String? categoryId,
    String? difficulty,
    String? type,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        try {
          // Search from remote
          final remoteResponse = await _remoteDataSource.searchExams(
            query: query,
            pagination: pagination,
            categoryId: categoryId,
            difficulty: difficulty,
            type: type,
          );

          // Cache the search results
          if (remoteResponse.data.isNotEmpty) {
            await _localDataSource.cacheSearchResults(
              query,
              remoteResponse.data,
            );
          }

          // Convert to domain entities
          final domainExams = remoteResponse.data
              .map((model) => model.toEntity())
              .toList();

          final domainResponse = PaginatedResponse<Exam>(
            data: domainExams,
            currentPage: remoteResponse.currentPage,
            lastPage: remoteResponse.lastPage,
            total: remoteResponse.total,
            perPage: remoteResponse.perPage,
            hasMorePages: remoteResponse.hasMorePages,
            nextPageUrl: remoteResponse.nextPageUrl,
            prevPageUrl: remoteResponse.prevPageUrl,
          );

          return Right(domainResponse);
        } catch (e) {
          // If remote fails, try to get from cache
          return await _getSearchResultsFromCache(query);
        }
      } else {
        // No internet, get from cache
        return await _getSearchResultsFromCache(query);
      }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }



  /// Helper method to get exams from cache
  Future<Either<Failure, PaginatedResponse<Exam>>> _getExamsFromCache(
    String cacheKey,
    PaginationParams pagination,
  ) async {
    try {
      final cachedExams = await _localDataSource.getCachedExams(
        cacheKey: cacheKey,
        limit: pagination.perPage,
        offset: (pagination.page - 1) * pagination.perPage,
      );

      final domainExams = cachedExams.map((model) => model.toEntity()).toList();

      // Create a simple paginated response from cached data
      final response = PaginatedResponse<Exam>(
        data: domainExams,
        currentPage: pagination.page,
        lastPage: 1, // We don't know the actual last page from cache
        total: domainExams.length,
        perPage: pagination.perPage,
        hasMorePages: false, // Conservative approach
      );

      return Right(response);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Helper method to get search results from cache
  Future<Either<Failure, PaginatedResponse<Exam>>> _getSearchResultsFromCache(
    String query,
  ) async {
    try {
      final cachedResults = await _localDataSource.getCachedSearchResults(query);
      
      if (cachedResults == null) {
        return const Left(CacheFailure(message: 'No cached search results found'));
      }

      final domainExams = cachedResults.map((model) => model.toEntity()).toList();

      final response = PaginatedResponse<Exam>(
        data: domainExams,
        currentPage: 1,
        lastPage: 1,
        total: domainExams.length,
        perPage: domainExams.length,
        hasMorePages: false,
      );

      return Right(response);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Generate cache key from parameters
  String _generateCacheKey(Map<String, dynamic> params) {
    final filteredParams = params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}:${entry.value}')
        .join('_');
    return filteredParams.isEmpty ? 'default' : filteredParams;
  }

  /// Map exceptions to failures
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else if (exception is UnauthorizedException) {
      return AuthFailure(message: exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        errors: exception.errors,
      );
    } else {
      return ServerFailure(message: 'An unexpected error occurred');
    }
  }
}