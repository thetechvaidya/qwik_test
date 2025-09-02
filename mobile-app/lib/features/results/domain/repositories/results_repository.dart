import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exam_result.dart';
import '../entities/question_result.dart';

abstract class ResultsRepository {
  /// Get exam results for a specific user
  Future<Either<Failure, List<ExamResult>>> getExamResults(
    String userId, {
    int? limit,
    int? offset,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get a specific exam result by ID
  Future<Either<Failure, ExamResult>> getExamResult(String examResultId);

  /// Get question results for a specific exam result
  Future<Either<Failure, List<QuestionResult>>> getQuestionResults(
    String examResultId,
  );

  /// Submit exam result
  Future<Either<Failure, ExamResult>> submitExamResult(ExamResult examResult);

  /// Update exam result
  Future<Either<Failure, ExamResult>> updateExamResult(ExamResult examResult);

  /// Delete exam result
  Future<Either<Failure, void>> deleteExamResult(String examResultId);

  /// Get performance analytics
  Future<Either<Failure, Map<String, dynamic>>> getPerformanceAnalytics(
    String userId, {
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get detailed analysis for a specific exam
  Future<Either<Failure, Map<String, dynamic>>> getExamAnalysis(
    String examResultId,
  );

  /// Get study recommendations based on performance
  Future<Either<Failure, List<Map<String, dynamic>>>> getStudyRecommendations(
    String userId,
  );

  /// Sync results data
  Future<Either<Failure, Map<String, dynamic>>> syncResultsData(
    String userId,
    DateTime lastSync,
  );

  /// Clear cached results data
  Future<Either<Failure, void>> clearCache();

  /// Refresh exam results (force fetch from remote)
  Future<Either<Failure, List<ExamResult>>> refreshExamResults(String userId);

  /// Get cached exam results
  Future<Either<Failure, List<ExamResult>>> getCachedExamResults(String userId);

  /// Get exam results by category
  Future<Either<Failure, List<ExamResult>>> getExamResultsByCategory(
    String userId,
    String category,
  );

  /// Get recent exam results
  Future<Either<Failure, List<ExamResult>>> getRecentExamResults(
    String userId, {
    int limit = 10,
  });

  /// Get exam results statistics
  Future<Either<Failure, Map<String, dynamic>>> getExamResultsStatistics(
    String userId,
  );

  /// Search exam results
  Future<Either<Failure, List<ExamResult>>> searchExamResults(
    String userId,
    String query,
  );
}