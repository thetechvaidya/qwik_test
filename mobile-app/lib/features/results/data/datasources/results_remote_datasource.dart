import 'package:dio/dio.dart';
import '../models/exam_result_model.dart';
import '../models/question_result_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class ResultsRemoteDataSource {
  /// Get exam results for a specific user
  Future<List<ExamResultModel>> getExamResults(String userId, {
    int? limit,
    int? offset,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get a specific exam result by ID
  Future<ExamResultModel> getExamResult(String examResultId);

  /// Get question results for a specific exam result
  Future<List<QuestionResultModel>> getQuestionResults(String examResultId);

  /// Submit exam result
  Future<ExamResultModel> submitExamResult(ExamResultModel examResult);

  /// Update exam result
  Future<ExamResultModel> updateExamResult(ExamResultModel examResult);

  /// Delete exam result
  Future<void> deleteExamResult(String examResultId);

  /// Get performance analytics
  Future<Map<String, dynamic>> getPerformanceAnalytics(String userId, {
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get detailed analysis for a specific exam
  Future<Map<String, dynamic>> getExamAnalysis(String examResultId);

  /// Get study recommendations based on performance
  Future<List<Map<String, dynamic>>> getStudyRecommendations(String userId);

  /// Sync results data
  Future<Map<String, dynamic>> syncResultsData(String userId, DateTime lastSync);
}

class ResultsRemoteDataSourceImpl implements ResultsRemoteDataSource {
  final Dio dio;
  static const String _baseUrl = '/api/v1/results';

  ResultsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ExamResultModel>> getExamResults(
    String userId, {
    int? limit,
    int? offset,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'userId': userId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (category != null) 'category': category,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      };

      final response = await dio.get(
        '$_baseUrl/exams',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ExamResultModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch exam results');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else if (e.response?.statusCode == 403) {
        throw AuthException('Access denied');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Exam results not found');
      } else {
        throw ServerException('Failed to fetch exam results: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<ExamResultModel> getExamResult(String examResultId) async {
    try {
      final response = await dio.get('$_baseUrl/exams/$examResultId');

      if (response.statusCode == 200) {
        return ExamResultModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to fetch exam result');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Exam result not found');
      } else {
        throw ServerException('Failed to fetch exam result: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<QuestionResultModel>> getQuestionResults(String examResultId) async {
    try {
      final response = await dio.get('$_baseUrl/exams/$examResultId/questions');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => QuestionResultModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch question results');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Question results not found');
      } else {
        throw ServerException('Failed to fetch question results: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<ExamResultModel> submitExamResult(ExamResultModel examResult) async {
    try {
      final response = await dio.post(
        '$_baseUrl/exams',
        data: examResult.toJson(),
      );

      if (response.statusCode == 201) {
        return ExamResultModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to submit exam result');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else if (e.response?.statusCode == 400) {
        throw ValidationException('Invalid exam result data');
      } else {
        throw ServerException('Failed to submit exam result: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<ExamResultModel> updateExamResult(ExamResultModel examResult) async {
    try {
      final response = await dio.put(
        '$_baseUrl/exams/${examResult.id}',
        data: examResult.toJson(),
      );

      if (response.statusCode == 200) {
        return ExamResultModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to update exam result');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Exam result not found');
      } else if (e.response?.statusCode == 400) {
        throw ValidationException('Invalid exam result data');
      } else {
        throw ServerException('Failed to update exam result: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteExamResult(String examResultId) async {
    try {
      final response = await dio.delete('$_baseUrl/exams/$examResultId');

      if (response.statusCode != 204) {
        throw ServerException('Failed to delete exam result');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Exam result not found');
      } else {
        throw ServerException('Failed to delete exam result: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getPerformanceAnalytics(
    String userId, {
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'userId': userId,
        if (category != null) 'category': category,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      };

      final response = await dio.get(
        '$_baseUrl/analytics/performance',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data['data'] ?? {};
      } else {
        throw ServerException('Failed to fetch performance analytics');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else {
        throw ServerException('Failed to fetch performance analytics: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getExamAnalysis(String examResultId) async {
    try {
      final response = await dio.get('$_baseUrl/exams/$examResultId/analysis');

      if (response.statusCode == 200) {
        return response.data['data'] ?? {};
      } else {
        throw ServerException('Failed to fetch exam analysis');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Exam analysis not found');
      } else {
        throw ServerException('Failed to fetch exam analysis: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getStudyRecommendations(String userId) async {
    try {
      final response = await dio.get(
        '$_baseUrl/recommendations',
        queryParameters: {'userId': userId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw ServerException('Failed to fetch study recommendations');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else {
        throw ServerException('Failed to fetch study recommendations: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> syncResultsData(String userId, DateTime lastSync) async {
    try {
      final response = await dio.post(
        '$_baseUrl/sync',
        data: {
          'userId': userId,
          'lastSync': lastSync.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        return response.data['data'] ?? {};
      } else {
        throw ServerException('Failed to sync results data');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('Authentication failed');
      } else {
        throw ServerException('Failed to sync results data: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}