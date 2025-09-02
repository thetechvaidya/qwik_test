import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/results_repository.dart';
import '../../domain/entities/exam_result.dart';
import '../../domain/entities/question_result.dart';
import '../datasources/results_remote_datasource.dart';
import '../datasources/results_local_datasource.dart';
import '../models/exam_result_model.dart';
import '../models/question_result_model.dart';

class ResultsRepositoryImpl implements ResultsRepository {
  final ResultsRemoteDataSource remoteDataSource;
  final ResultsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ResultsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ExamResult>>> getExamResults(
    String userId, {
    int? limit,
    int? offset,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        // Check if cache is fresh
        final isCacheFresh = await localDataSource.isExamResultsCacheFresh(userId);
        
        if (isCacheFresh && offset == null) {
          // Return cached data if fresh and not paginating
          final cachedResults = await localDataSource.getCachedExamResults(userId);
          if (cachedResults.isNotEmpty) {
            var results = cachedResults.map((r) => r.toEntity()).toList();
            
            // Apply filters
            if (category != null) {
              results = results.where((r) => r.category == category).toList();
            }
            if (startDate != null) {
              results = results.where((r) => r.completedAt.isAfter(startDate) || r.completedAt.isAtSameMomentAs(startDate)).toList();
            }
            if (endDate != null) {
              results = results.where((r) => r.completedAt.isBefore(endDate) || r.completedAt.isAtSameMomentAs(endDate)).toList();
            }
            if (limit != null) {
              results = results.take(limit).toList();
            }
            
            return Right(results);
          }
        }
        
        // Fetch from remote
        final remoteResults = await remoteDataSource.getExamResults(
          userId,
          limit: limit,
          offset: offset,
          category: category,
          startDate: startDate,
          endDate: endDate,
        );
        
        // Cache the data if it's the first page
        if (offset == null || offset == 0) {
          await localDataSource.cacheExamResults(remoteResults);
          await localDataSource.setExamResultsCacheTimestamp(userId, DateTime.now());
        }
        
        return Right(remoteResults.map((r) => r.toEntity()).toList());
      } else {
        // No internet, try cached data
        final cachedResults = await localDataSource.getCachedExamResults(userId);
        if (cachedResults.isNotEmpty) {
          var results = cachedResults.map((r) => r.toEntity()).toList();
          
          // Apply filters
          if (category != null) {
            results = results.where((r) => r.category == category).toList();
          }
          if (startDate != null) {
            results = results.where((r) => r.completedAt.isAfter(startDate) || r.completedAt.isAtSameMomentAs(startDate)).toList();
          }
          if (endDate != null) {
            results = results.where((r) => r.completedAt.isBefore(endDate) || r.completedAt.isAtSameMomentAs(endDate)).toList();
          }
          if (offset != null) {
            results = results.skip(offset).toList();
          }
          if (limit != null) {
            results = results.take(limit).toList();
          }
          
          return Right(results);
        } else {
          return Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, ExamResult>> getExamResult(String examResultId) async {
    try {
      // Try cache first
      final cachedResult = await localDataSource.getCachedExamResult(examResultId);
      if (cachedResult != null) {
        return Right(cachedResult.toEntity());
      }
      
      if (await networkInfo.isConnected) {
        // Fetch from remote
        final remoteResult = await remoteDataSource.getExamResult(examResultId);
        
        // Cache the result
        await localDataSource.cacheExamResult(remoteResult);
        
        return Right(remoteResult.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection and exam result not cached'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<QuestionResult>>> getQuestionResults(
    String examResultId,
  ) async {
    try {
      // Try cache first
      final cachedQuestions = await localDataSource.getCachedQuestionResults(examResultId);
      if (cachedQuestions.isNotEmpty) {
        return Right(cachedQuestions.map((q) => q.toEntity()).toList());
      }
      
      if (await networkInfo.isConnected) {
        // Fetch from remote
        final remoteQuestions = await remoteDataSource.getQuestionResults(examResultId);
        
        // Cache the questions
        await localDataSource.cacheQuestionResults(examResultId, remoteQuestions);
        
        return Right(remoteQuestions.map((q) => q.toEntity()).toList());
      } else {
        return Left(NetworkFailure('No internet connection and question results not cached'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, ExamResult>> submitExamResult(ExamResult examResult) async {
    try {
      if (await networkInfo.isConnected) {
        final examResultModel = ExamResultModel.fromEntity(examResult);
        final submittedResult = await remoteDataSource.submitExamResult(examResultModel);
        
        // Cache the submitted result
        await localDataSource.cacheExamResult(submittedResult);
        
        return Right(submittedResult.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, ExamResult>> updateExamResult(ExamResult examResult) async {
    try {
      if (await networkInfo.isConnected) {
        final examResultModel = ExamResultModel.fromEntity(examResult);
        final updatedResult = await remoteDataSource.updateExamResult(examResultModel);
        
        // Update cache
        await localDataSource.updateCachedExamResult(updatedResult);
        
        return Right(updatedResult.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExamResult(String examResultId) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteExamResult(examResultId);
        
        // Remove from cache
        await localDataSource.removeCachedExamResult(examResultId);
        
        return const Right(null);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPerformanceAnalytics(
    String userId, {
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        // Try cache first
        final cachedAnalytics = await localDataSource.getCachedPerformanceAnalytics(userId);
        if (cachedAnalytics != null) {
          return Right(cachedAnalytics);
        }
        
        // Fetch from remote
        final analytics = await remoteDataSource.getPerformanceAnalytics(
          userId,
          category: category,
          startDate: startDate,
          endDate: endDate,
        );
        
        // Cache the analytics
        await localDataSource.cachePerformanceAnalytics(userId, analytics);
        
        return Right(analytics);
      } else {
        // Try cached data
        final cachedAnalytics = await localDataSource.getCachedPerformanceAnalytics(userId);
        if (cachedAnalytics != null) {
          return Right(cachedAnalytics);
        } else {
          return Left(NetworkFailure('No internet connection and no cached analytics available'));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getExamAnalysis(
    String examResultId,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final analysis = await remoteDataSource.getExamAnalysis(examResultId);
        return Right(analysis);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getStudyRecommendations(
    String userId,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        // Try cache first
        final cachedRecommendations = await localDataSource.getCachedStudyRecommendations(userId);
        if (cachedRecommendations != null) {
          return Right(cachedRecommendations);
        }
        
        // Fetch from remote
        final recommendations = await remoteDataSource.getStudyRecommendations(userId);
        
        // Cache the recommendations
        await localDataSource.cacheStudyRecommendations(userId, recommendations);
        
        return Right(recommendations);
      } else {
        // Try cached data
        final cachedRecommendations = await localDataSource.getCachedStudyRecommendations(userId);
        if (cachedRecommendations != null) {
          return Right(cachedRecommendations);
        } else {
          return Left(NetworkFailure('No internet connection and no cached recommendations available'));
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> syncResultsData(
    String userId,
    DateTime lastSync,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final syncData = await remoteDataSource.syncResultsData(userId, lastSync);
        return Right(syncData);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ExamResult>>> refreshExamResults(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        // Force fetch from remote
        final remoteResults = await remoteDataSource.getExamResults(userId);
        
        // Update cache
        await localDataSource.cacheExamResults(remoteResults);
        await localDataSource.setExamResultsCacheTimestamp(userId, DateTime.now());
        
        return Right(remoteResults.map((r) => r.toEntity()).toList());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ExamResult>>> getCachedExamResults(String userId) async {
    try {
      final cachedResults = await localDataSource.getCachedExamResults(userId);
      return Right(cachedResults.map((r) => r.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ExamResult>>> getExamResultsByCategory(
    String userId,
    String category,
  ) async {
    return getExamResults(userId, category: category);
  }

  @override
  Future<Either<Failure, List<ExamResult>>> getRecentExamResults(
    String userId, {
    int limit = 10,
  }) async {
    return getExamResults(userId, limit: limit);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getExamResultsStatistics(
    String userId,
  ) async {
    try {
      final examResultsEither = await getExamResults(userId);
      
      return examResultsEither.fold(
        (failure) => Left(failure),
        (examResults) {
          // Calculate statistics from exam results
          final stats = <String, dynamic>{
            'totalExams': examResults.length,
            'averageScore': examResults.isEmpty ? 0.0 : examResults.map((e) => e.percentageScore).reduce((a, b) => a + b) / examResults.length,
            'highestScore': examResults.isEmpty ? 0.0 : examResults.map((e) => e.percentageScore).reduce((a, b) => a > b ? a : b),
            'lowestScore': examResults.isEmpty ? 0.0 : examResults.map((e) => e.percentageScore).reduce((a, b) => a < b ? a : b),
            'totalTimeSpent': examResults.fold<int>(0, (sum, e) => sum + e.timeSpent),
            'categoriesCount': examResults.map((e) => e.category).toSet().length,
            'passedExams': examResults.where((e) => e.percentageScore >= 70).length,
            'failedExams': examResults.where((e) => e.percentageScore < 70).length,
          };
          
          return Right(stats);
        },
      );
    } catch (e) {
      return Left(UnknownFailure('Failed to calculate statistics: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ExamResult>>> searchExamResults(
    String userId,
    String query,
  ) async {
    try {
      final examResultsEither = await getExamResults(userId);
      
      return examResultsEither.fold(
        (failure) => Left(failure),
        (examResults) {
          final filteredResults = examResults.where((result) {
            return result.examTitle.toLowerCase().contains(query.toLowerCase()) ||
                   result.category.toLowerCase().contains(query.toLowerCase());
          }).toList();
          
          return Right(filteredResults);
        },
      );
    } catch (e) {
      return Left(UnknownFailure('Failed to search exam results: $e'));
    }
  }
}