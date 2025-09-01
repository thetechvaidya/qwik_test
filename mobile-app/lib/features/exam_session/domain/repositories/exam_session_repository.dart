import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exam_session.dart';
import '../entities/question.dart';
import '../entities/answer.dart';

/// Abstract repository interface for exam session operations
abstract class ExamSessionRepository {
  /// Start a new exam session
  Future<Either<Failure, ExamSession>> startExamSession({
    required String examId,
    Map<String, dynamic>? settings,
  });

  /// Get exam session by ID
  Future<Either<Failure, ExamSession>> getExamSession(String sessionId);

  /// Get questions for exam session
  Future<Either<Failure, List<Question>>> getSessionQuestions(String sessionId);

  /// Submit answer for a question
  Future<Either<Failure, Answer>> submitAnswer({
    required String sessionId,
    required String questionId,
    required List<String> selectedOptionIds,
    required int timeSpent,
  });

  /// Update exam session (pause, resume, etc.)
  Future<Either<Failure, ExamSession>> updateExamSession({
    required String sessionId,
    Map<String, dynamic>? updates,
  });

  /// Submit exam session
  Future<Either<Failure, ExamSession>> submitExamSession(String sessionId);

  /// Get user's active exam sessions
  Future<Either<Failure, List<ExamSession>>> getActiveExamSessions();

  /// Abandon exam session
  Future<Either<Failure, void>> abandonExamSession(String sessionId);

  /// Sync local answers with server
  Future<Either<Failure, List<Answer>>> syncAnswers({
    required String sessionId,
    required List<Answer> answers,
  });

  /// Save answer locally (for offline support)
  Future<Either<Failure, void>> saveAnswerLocally({
    required String sessionId,
    required Answer answer,
  });

  /// Get locally saved answers
  Future<Either<Failure, List<Answer>>> getLocalAnswers(String sessionId);

  /// Save session progress locally
  Future<Either<Failure, void>> saveSessionProgress({
    required String sessionId,
    required Map<String, dynamic> progress,
  });

  /// Get locally saved session progress
  Future<Either<Failure, Map<String, dynamic>?>> getSessionProgress(String sessionId);
}