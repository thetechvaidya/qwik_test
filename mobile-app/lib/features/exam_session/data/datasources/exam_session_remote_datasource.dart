import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/exam_session_model.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';

/// Abstract interface for exam session remote data source
abstract class ExamSessionRemoteDataSource {
  /// Start a new exam session
  Future<ExamSessionModel> startExamSession({
    required String examId,
    Map<String, dynamic>? settings,
  });

  /// Get exam session by ID
  Future<ExamSessionModel> getExamSession(String sessionId);

  /// Get questions for exam session
  Future<List<QuestionModel>> getSessionQuestions(String sessionId);

  /// Submit answer for a question
  Future<AnswerModel> submitAnswer({
    required String sessionId,
    required String questionId,
    required List<String> selectedOptionIds,
    required int timeSpent,
  });

  /// Update exam session (pause, resume, etc.)
  Future<ExamSessionModel> updateExamSession({
    required String sessionId,
    Map<String, dynamic>? updates,
  });

  /// Submit exam session
  Future<ExamSessionModel> submitExamSession(String sessionId);

  /// Get user's active exam sessions
  Future<List<ExamSessionModel>> getActiveExamSessions();

  /// Abandon exam session
  Future<void> abandonExamSession(String sessionId, {String? reason});

  /// Sync local answers with server
  Future<List<AnswerModel>> syncAnswers({
    required String sessionId,
    required List<AnswerModel> answers,
  });
}

/// Implementation of exam session remote data source
class ExamSessionRemoteDataSourceImpl implements ExamSessionRemoteDataSource {
  final Dio _dio;

  ExamSessionRemoteDataSourceImpl({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<ExamSessionModel> startExamSession({
    required String examId,
    Map<String, dynamic>? settings,
  }) async {
    try {
      final requestData = {
        'exam_id': examId,
        if (settings != null) 'settings': settings,
      };

      final response = await _dio.post(
        ApiEndpoints.examSessions,
        data: requestData,
      );

      if (response.statusCode == 201) {
        return ExamSessionModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: 'Failed to start exam session',
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
  Future<ExamSessionModel> getExamSession(String sessionId) async {
    try {
      final response = await _dio.get(ApiEndpoints.examSessionDetail(sessionId));

      if (response.statusCode == 200) {
        return ExamSessionModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: 'Failed to fetch exam session',
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
  Future<List<QuestionModel>> getSessionQuestions(String sessionId) async {
    try {
      final response = await _dio.get(ApiEndpoints.examSessionQuestions(sessionId));

      if (response.statusCode == 200) {
        final List<dynamic> questionsJson = response.data['data'];
        return questionsJson
            .map((json) => QuestionModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch session questions',
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
  Future<AnswerModel> submitAnswer({
    required String sessionId,
    required String questionId,
    required List<String> selectedOptionIds,
    required int timeSpent,
  }) async {
    try {
      final requestData = {
        'question_id': questionId,
        'selected_option_ids': selectedOptionIds,
        'time_spent': timeSpent,
        'answered_at': DateTime.now().toIso8601String(),
      };

      final response = await _dio.post(
        ApiEndpoints.examSessionAnswers(sessionId),
        data: requestData,
      );

      if (response.statusCode == 201) {
        return AnswerModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: 'Failed to submit answer',
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
  Future<ExamSessionModel> updateExamSession({
    required String sessionId,
    Map<String, dynamic>? updates,
  }) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.examSessionDetail(sessionId),
        data: updates ?? {},
      );

      if (response.statusCode == 200) {
        return ExamSessionModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: 'Failed to update exam session',
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
  Future<ExamSessionModel> submitExamSession(String sessionId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.examSessionSubmit(sessionId),
      );

      if (response.statusCode == 200) {
        return ExamSessionModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: 'Failed to submit exam session',
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
  Future<List<ExamSessionModel>> getActiveExamSessions() async {
    try {
      final response = await _dio.get(ApiEndpoints.activeExamSessions);

      if (response.statusCode == 200) {
        final List<dynamic> sessionsJson = response.data['data'];
        return sessionsJson
            .map((json) => ExamSessionModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch active exam sessions',
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
  Future<void> abandonExamSession(String sessionId, {String? reason}) async {
    try {
      final requestData = reason != null ? {'reason': reason} : null;
      
      final response = await _dio.post(
        ApiEndpoints.examSessionAbandon(sessionId),
        data: requestData,
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to abandon exam session',
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
  Future<List<AnswerModel>> syncAnswers({
    required String sessionId,
    required List<AnswerModel> answers,
  }) async {
    try {
      final requestData = {
        'answers': answers.map((answer) => answer.toJson()).toList(),
      };

      final response = await _dio.post(
        ApiEndpoints.examSessionSyncAnswers(sessionId),
        data: requestData,
      );

      if (response.statusCode == 200) {
        final List<dynamic> answersJson = response.data['data'];
        return answersJson
            .map((json) => AnswerModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to sync answers',
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
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Server error';
        return ServerException(
          message: message,
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');
      default:
        return ServerException(message: 'Unexpected error occurred');
    }
  }
}