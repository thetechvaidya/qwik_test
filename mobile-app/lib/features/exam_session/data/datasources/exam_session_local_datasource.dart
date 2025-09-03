import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/exam_session_model.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';

/// Abstract interface for exam session local data source
abstract class ExamSessionLocalDataSource {
  /// Cache exam session
  Future<void> cacheExamSession(ExamSessionModel session);

  /// Get cached exam session by ID
  Future<ExamSessionModel?> getCachedExamSession(String sessionId);

  /// Cache session questions
  Future<void> cacheSessionQuestions(
    String sessionId,
    List<QuestionModel> questions,
  );

  /// Get cached session questions
  Future<List<QuestionModel>?> getCachedSessionQuestions(String sessionId);

  /// Cache answer
  Future<void> cacheAnswer(String sessionId, AnswerModel answer);

  /// Get cached answers for session
  Future<List<AnswerModel>> getCachedAnswers(String sessionId);

  /// Update cached answer
  Future<void> updateCachedAnswer(String sessionId, AnswerModel answer);

  /// Get all active cached sessions
  Future<List<ExamSessionModel>> getCachedActiveSessions();

  /// Remove cached session
  Future<void> removeCachedSession(String sessionId);

  /// Clear all cached exam sessions
  Future<void> clearAllCachedSessions();

  /// Get unsync answers (answers not yet synced with server)
  Future<List<AnswerModel>> getUnsyncedAnswers(String sessionId);

  /// Mark answers as synced
  Future<void> markAnswersAsSynced(
    String sessionId,
    List<String> answerIds,
  );

  /// Cache session progress
  Future<void> cacheSessionProgress(
    String sessionId,
    Map<String, dynamic> progress,
  );

  /// Get cached session progress
  Future<Map<String, dynamic>?> getCachedSessionProgress(String sessionId);
}

/// Implementation of exam session local data source
class ExamSessionLocalDataSourceImpl implements ExamSessionLocalDataSource {
  static const String _examSessionsBoxName = 'exam_sessions';
  static const String _sessionQuestionsBoxName = 'session_questions';
  static const String _sessionAnswersBoxName = 'session_answers';
  static const String _sessionProgressBoxName = 'session_progress';

  late Box<ExamSessionModel> _examSessionsBox;
  late Box<List<QuestionModel>> _sessionQuestionsBox;
  late Box<List<AnswerModel>> _sessionAnswersBox;
  late Box<Map<String, dynamic>> _sessionProgressBox;

  ExamSessionLocalDataSourceImpl() {
    _initializeBoxes();
  }

  void _initializeBoxes() {
    _examSessionsBox = Hive.box<ExamSessionModel>(_examSessionsBoxName);
    _sessionQuestionsBox = Hive.box<List<QuestionModel>>(_sessionQuestionsBoxName);
    _sessionAnswersBox = Hive.box<List<AnswerModel>>(_sessionAnswersBoxName);
    _sessionProgressBox = Hive.box<Map<String, dynamic>>(_sessionProgressBoxName);
  }

  @override
  Future<void> cacheExamSession(ExamSessionModel session) async {
    try {
      await _examSessionsBox.put(session.sessionId, session);
    } catch (e) {
      throw CacheException('Failed to cache exam session: $e');
    }
  }

  @override
  Future<ExamSessionModel?> getCachedExamSession(String sessionId) async {
    try {
      return _examSessionsBox.get(sessionId);
    } catch (e) {
      throw CacheException('Failed to get cached exam session: $e');
    }
  }

  @override
  Future<void> cacheSessionQuestions(
    String sessionId,
    List<QuestionModel> questions,
  ) async {
    try {
      await _sessionQuestionsBox.put(sessionId, questions);
    } catch (e) {
      throw CacheException('Failed to cache session questions: $e');
    }
  }

  @override
  Future<List<QuestionModel>?> getCachedSessionQuestions(String sessionId) async {
    try {
      return _sessionQuestionsBox.get(sessionId);
    } catch (e) {
      throw CacheException('Failed to get cached session questions: $e');
    }
  }

  @override
  Future<void> cacheAnswer(String sessionId, AnswerModel answer) async {
    try {
      final existingAnswers = _sessionAnswersBox.get(sessionId) ?? <AnswerModel>[];
      
      // Remove existing answer for the same question if it exists
      existingAnswers.removeWhere((a) => a.questionId == answer.questionId);
      
      // Add the new answer
      existingAnswers.add(answer);
      
      await _sessionAnswersBox.put(sessionId, existingAnswers);
    } catch (e) {
      throw CacheException('Failed to cache answer: $e');
    }
  }

  @override
  Future<List<AnswerModel>> getCachedAnswers(String sessionId) async {
    try {
      return _sessionAnswersBox.get(sessionId) ?? <AnswerModel>[];
    } catch (e) {
      throw CacheException('Failed to get cached answers: $e');
    }
  }

  @override
  Future<void> updateCachedAnswer(String sessionId, AnswerModel answer) async {
    try {
      final existingAnswers = _sessionAnswersBox.get(sessionId) ?? <AnswerModel>[];
      
      final index = existingAnswers.indexWhere((a) => a.questionId == answer.questionId);
      if (index != -1) {
        existingAnswers[index] = answer;
      } else {
        existingAnswers.add(answer);
      }
      
      await _sessionAnswersBox.put(sessionId, existingAnswers);
    } catch (e) {
      throw CacheException('Failed to update cached answer: $e');
    }
  }

  @override
  Future<List<ExamSessionModel>> getCachedActiveSessions() async {
    try {
      final allSessions = _examSessionsBox.values.toList();
      return allSessions.where((session) => 
        session.status == 'active' || session.status == 'paused'
      ).toList();
    } catch (e) {
      throw CacheException('Failed to get cached active sessions: $e');
    }
  }

  @override
  Future<void> removeCachedSession(String sessionId) async {
    try {
      await _examSessionsBox.delete(sessionId);
      await _sessionQuestionsBox.delete(sessionId);
      await _sessionAnswersBox.delete(sessionId);
      await _sessionProgressBox.delete(sessionId);
    } catch (e) {
      throw CacheException('Failed to remove cached session: $e');
    }
  }

  @override
  Future<void> clearAllCachedSessions() async {
    try {
      await _examSessionsBox.clear();
      await _sessionQuestionsBox.clear();
      await _sessionAnswersBox.clear();
      await _sessionProgressBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear all cached sessions: $e');
    }
  }

  @override
  Future<List<AnswerModel>> getUnsyncedAnswers(String sessionId) async {
    try {
      final answers = await getCachedAnswers(sessionId);
      // In a real implementation, you might have a 'synced' flag in the answer metadata
      // For now, we'll assume all cached answers are unsynced
      return answers.where((answer) => 
        answer.metadata?['synced'] != true
      ).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get unsynced answers: $e');
    }
  }

  @override
  Future<void> markAnswersAsSynced(
    String sessionId,
    List<String> answerIds,
  ) async {
    try {
      final answers = await getCachedAnswers(sessionId);
      
      for (final answer in answers) {
        if (answerIds.contains(answer.questionId)) {
          final updatedMetadata = Map<String, dynamic>.from(answer.metadata ?? {});
          updatedMetadata['synced'] = true;
          
          final updatedAnswer = AnswerModel(
            questionId: answer.questionId,
            selectedOptionIds: answer.selectedOptionIds,
            timeSpent: answer.timeSpent,
            answeredAt: answer.answeredAt,
            isCorrect: answer.isCorrect,
            score: answer.score,
            isSkipped: answer.isSkipped,
            isMarkedForReview: answer.isMarkedForReview,
            metadata: updatedMetadata,
          );
          
          await updateCachedAnswer(sessionId, updatedAnswer);
        }
      }
    } catch (e) {
      throw CacheException(message: 'Failed to mark answers as synced: $e');
    }
  }

  @override
  Future<void> cacheSessionProgress(
    String sessionId,
    Map<String, dynamic> progress,
  ) async {
    try {
      await _sessionProgressBox.put(sessionId, progress);
    } catch (e) {
      throw CacheException(message: 'Failed to cache session progress: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedSessionProgress(String sessionId) async {
    try {
      return _sessionProgressBox.get(sessionId);
    } catch (e) {
      throw CacheException(message: 'Failed to get cached session progress: $e');
    }
  }
}