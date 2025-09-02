import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/exam_session.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/answer.dart';
import '../../domain/repositories/exam_session_repository.dart';
import '../datasources/exam_session_remote_datasource.dart';
import '../datasources/exam_session_local_datasource.dart';
import '../models/exam_session_model.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';

/// Implementation of exam session repository
class ExamSessionRepositoryImpl implements ExamSessionRepository {
  final ExamSessionRemoteDataSource _remoteDataSource;
  final ExamSessionLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ExamSessionRepositoryImpl({
    required ExamSessionRemoteDataSource remoteDataSource,
    required ExamSessionLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ExamSession>> startExamSession({
    required String examId,
    Map<String, dynamic>? settings,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final sessionModel = await _remoteDataSource.startExamSession(
          examId: examId,
          settings: settings,
        );
        
        // Cache the session locally
        await _localDataSource.cacheExamSession(sessionModel);
        
        return Right(sessionModel.toEntity());
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, ExamSession>> getExamSession(String sessionId) async {
    try {
      // Try to get from cache first
      final cachedSession = await _localDataSource.getCachedExamSession(sessionId);
      
      if (await _networkInfo.isConnected) {
        try {
          // Get fresh data from server
          final sessionModel = await _remoteDataSource.getExamSession(sessionId);
          
          // Update cache
          await _localDataSource.cacheExamSession(sessionModel);
          
          return Right(sessionModel.toEntity());
        } on ServerException catch (e) {
          // If server fails but we have cached data, return cached data
          if (cachedSession != null) {
            return Right(cachedSession.toEntity());
          }
          return Left(ServerFailure(message: e.message));
        }
      } else {
        // No internet, return cached data if available
        if (cachedSession != null) {
          return Right(cachedSession.toEntity());
        }
        return const Left(NetworkFailure(message: 'No internet connection and no cached data'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getSessionQuestions(String sessionId) async {
    try {
      // Try to get from cache first
      final cachedQuestions = await _localDataSource.getCachedSessionQuestions(sessionId);
      
      if (await _networkInfo.isConnected) {
        try {
          // Get fresh data from server
          final questionModels = await _remoteDataSource.getSessionQuestions(sessionId);
          
          // Update cache
          await _localDataSource.cacheSessionQuestions(sessionId, questionModels);
          
          return Right(questionModels.map((model) => model.toEntity()).toList());
        } on ServerException catch (e) {
          // If server fails but we have cached data, return cached data
          if (cachedQuestions != null) {
            return Right(cachedQuestions.map((model) => model.toEntity()).toList());
          }
          return Left(ServerFailure(message: e.message));
        }
      } else {
        // No internet, return cached data if available
        if (cachedQuestions != null) {
          return Right(cachedQuestions.map((model) => model.toEntity()).toList());
        }
        return const Left(NetworkFailure(message: 'No internet connection and no cached questions'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Answer>> submitAnswer({
    required String sessionId,
    required String questionId,
    required List<String> selectedOptionIds,
    required int timeSpent,
  }) async {
    try {
      final answer = Answer(
        questionId: questionId,
        selectedOptionIds: selectedOptionIds,
        timeSpent: timeSpent,
        answeredAt: DateTime.now(),
      );
      
      // Always save locally first for offline support
      await _localDataSource.cacheAnswer(sessionId, AnswerModel.fromEntity(answer));
      
      if (await _networkInfo.isConnected) {
        try {
          // Submit to server
          final answerModel = await _remoteDataSource.submitAnswer(
            sessionId: sessionId,
            questionId: questionId,
            selectedOptionIds: selectedOptionIds,
            timeSpent: timeSpent,
          );
          
          // Update local cache with server response
          await _localDataSource.updateCachedAnswer(sessionId, answerModel);
          
          return Right(answerModel.toEntity());
        } on ServerException catch (e) {
          // Server failed, but answer is saved locally
          return Right(answer);
        }
      } else {
        // No internet, return locally saved answer
        return Right(answer);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, ExamSession>> updateExamSession({
    required String sessionId,
    Map<String, dynamic>? updates,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final sessionModel = await _remoteDataSource.updateExamSession(
          sessionId: sessionId,
          updates: updates,
        );
        
        // Update cache
        await _localDataSource.cacheExamSession(sessionModel);
        
        return Right(sessionModel.toEntity());
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, ExamSession>> submitExamSession(String sessionId) async {
    try {
      if (await _networkInfo.isConnected) {
        // Sync any unsynced answers first
        final unsyncedAnswers = await _localDataSource.getUnsyncedAnswers(sessionId);
        if (unsyncedAnswers.isNotEmpty) {
          await _remoteDataSource.syncAnswers(
            sessionId: sessionId,
            answers: unsyncedAnswers,
          );
        }
        
        // Submit the exam session
        final sessionModel = await _remoteDataSource.submitExamSession(sessionId);
        
        // Update cache
        await _localDataSource.cacheExamSession(sessionModel);
        
        return Right(sessionModel.toEntity());
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ExamSession>>> getActiveExamSessions() async {
    try {
      // Try to get from cache first
      final cachedSessions = await _localDataSource.getCachedActiveSessions();
      
      if (await _networkInfo.isConnected) {
        try {
          // Get fresh data from server
          final sessionModels = await _remoteDataSource.getActiveExamSessions();
          
          // Update cache
          for (final session in sessionModels) {
            await _localDataSource.cacheExamSession(session);
          }
          
          return Right(sessionModels.map((model) => model.toEntity()).toList());
        } on ServerException catch (e) {
          // If server fails but we have cached data, return cached data
          if (cachedSessions.isNotEmpty) {
            return Right(cachedSessions.map((model) => model.toEntity()).toList());
          }
          return Left(ServerFailure(message: e.message));
        }
      } else {
        // No internet, return cached data
        return Right(cachedSessions.map((model) => model.toEntity()).toList());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> abandonExamSession({
    required String sessionId,
    String? reason,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.abandonExamSession(sessionId, reason: reason);
      }
      
      // Remove from local cache
      await _localDataSource.removeCachedSession(sessionId);
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Answer>>> syncAnswers({
    required String sessionId,
    required List<Answer> answers,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final answerModels = answers.map((answer) => AnswerModel.fromEntity(answer)).toList();
        final syncedAnswerModels = await _remoteDataSource.syncAnswers(
          sessionId: sessionId,
          answers: answerModels,
        );
        
        // Mark answers as synced locally
        final answerIds = syncedAnswerModels.map((answer) => answer.questionId).toList();
        await _localDataSource.markAnswersAsSynced(sessionId, answerIds);
        
        return Right(syncedAnswerModels.map((model) => model.toEntity()).toList());
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveAnswerLocally({
    required String sessionId,
    required Answer answer,
  }) async {
    try {
      await _localDataSource.cacheAnswer(sessionId, AnswerModel.fromEntity(answer));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Answer>>> getLocalAnswers(String sessionId) async {
    try {
      final answerModels = await _localDataSource.getCachedAnswers(sessionId);
      return Right(answerModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSessionProgress({
    required String sessionId,
    required Map<String, dynamic> progress,
  }) async {
    try {
      await _localDataSource.cacheSessionProgress(sessionId, progress);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getSessionProgress(String sessionId) async {
    try {
      final progress = await _localDataSource.getCachedSessionProgress(sessionId);
      return Right(progress);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error occurred: $e'));
    }
  }
}