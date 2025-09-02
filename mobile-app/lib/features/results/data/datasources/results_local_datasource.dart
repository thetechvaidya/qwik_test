import 'package:hive/hive.dart';
import '../models/exam_result_model.dart';
import '../models/question_result_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class ResultsLocalDataSource {
  /// Cache exam results
  Future<void> cacheExamResults(List<ExamResultModel> examResults);

  /// Get cached exam results
  Future<List<ExamResultModel>> getCachedExamResults(String userId);

  /// Cache a single exam result
  Future<void> cacheExamResult(ExamResultModel examResult);

  /// Get a cached exam result by ID
  Future<ExamResultModel?> getCachedExamResult(String examResultId);

  /// Cache question results for an exam
  Future<void> cacheQuestionResults(String examResultId, List<QuestionResultModel> questionResults);

  /// Get cached question results for an exam
  Future<List<QuestionResultModel>> getCachedQuestionResults(String examResultId);

  /// Update exam result in cache
  Future<void> updateCachedExamResult(ExamResultModel examResult);

  /// Remove exam result from cache
  Future<void> removeCachedExamResult(String examResultId);

  /// Clear all cached results
  Future<void> clearCache();

  /// Get cache timestamp for exam results
  Future<DateTime?> getExamResultsCacheTimestamp(String userId);

  /// Set cache timestamp for exam results
  Future<void> setExamResultsCacheTimestamp(String userId, DateTime timestamp);

  /// Check if exam results cache is fresh
  Future<bool> isExamResultsCacheFresh(String userId, {Duration maxAge = const Duration(minutes: 30)});

  /// Get cached performance analytics
  Future<Map<String, dynamic>?> getCachedPerformanceAnalytics(String userId);

  /// Cache performance analytics
  Future<void> cachePerformanceAnalytics(String userId, Map<String, dynamic> analytics);

  /// Get cached study recommendations
  Future<List<Map<String, dynamic>>?> getCachedStudyRecommendations(String userId);

  /// Cache study recommendations
  Future<void> cacheStudyRecommendations(String userId, List<Map<String, dynamic>> recommendations);
}

class ResultsLocalDataSourceImpl implements ResultsLocalDataSource {
  static const String _examResultsBoxName = 'exam_results';
  static const String _questionResultsBoxName = 'question_results';
  static const String _cacheTimestampsBoxName = 'results_cache_timestamps';
  static const String _analyticsBoxName = 'performance_analytics';
  static const String _recommendationsBoxName = 'study_recommendations';

  Box<ExamResultModel>? _examResultsBox;
  Box<List<QuestionResultModel>>? _questionResultsBox;
  Box<DateTime>? _cacheTimestampsBox;
  Box<Map<String, dynamic>>? _analyticsBox;
  Box<List<Map<String, dynamic>>>? _recommendationsBox;

  Future<Box<ExamResultModel>> get _examResults async {
    _examResultsBox ??= await Hive.openBox<ExamResultModel>(_examResultsBoxName);
    return _examResultsBox!;
  }

  Future<Box<List<QuestionResultModel>>> get _questionResults async {
    _questionResultsBox ??= await Hive.openBox<List<QuestionResultModel>>(_questionResultsBoxName);
    return _questionResultsBox!;
  }

  Future<Box<DateTime>> get _cacheTimestamps async {
    _cacheTimestampsBox ??= await Hive.openBox<DateTime>(_cacheTimestampsBoxName);
    return _cacheTimestampsBox!;
  }

  Future<Box<Map<String, dynamic>>> get _analytics async {
    _analyticsBox ??= await Hive.openBox<Map<String, dynamic>>(_analyticsBoxName);
    return _analyticsBox!;
  }

  Future<Box<List<Map<String, dynamic>>>> get _recommendations async {
    _recommendationsBox ??= await Hive.openBox<List<Map<String, dynamic>>>(_recommendationsBoxName);
    return _recommendationsBox!;
  }

  @override
  Future<void> cacheExamResults(List<ExamResultModel> examResults) async {
    try {
      final box = await _examResults;
      
      // Clear existing results for the user
      if (examResults.isNotEmpty) {
        final userId = examResults.first.userId;
        final existingKeys = box.keys.where((key) {
          final result = box.get(key);
          return result?.userId == userId;
        }).toList();
        
        for (final key in existingKeys) {
          await box.delete(key);
        }
      }
      
      // Cache new results
      for (final result in examResults) {
        await box.put(result.id, result);
      }
    } catch (e) {
      throw CacheException('Failed to cache exam results: $e');
    }
  }

  @override
  Future<List<ExamResultModel>> getCachedExamResults(String userId) async {
    try {
      final box = await _examResults;
      final results = <ExamResultModel>[];
      
      for (final result in box.values) {
        if (result.userId == userId) {
          results.add(result);
        }
      }
      
      // Sort by completion date (most recent first)
      results.sort((a, b) => b.completedAt.compareTo(a.completedAt));
      
      return results;
    } catch (e) {
      throw CacheException('Failed to get cached exam results: $e');
    }
  }

  @override
  Future<void> cacheExamResult(ExamResultModel examResult) async {
    try {
      final box = await _examResults;
      await box.put(examResult.id, examResult);
    } catch (e) {
      throw CacheException('Failed to cache exam result: $e');
    }
  }

  @override
  Future<ExamResultModel?> getCachedExamResult(String examResultId) async {
    try {
      final box = await _examResults;
      return box.get(examResultId);
    } catch (e) {
      throw CacheException('Failed to get cached exam result: $e');
    }
  }

  @override
  Future<void> cacheQuestionResults(String examResultId, List<QuestionResultModel> questionResults) async {
    try {
      final box = await _questionResults;
      await box.put(examResultId, questionResults);
    } catch (e) {
      throw CacheException('Failed to cache question results: $e');
    }
  }

  @override
  Future<List<QuestionResultModel>> getCachedQuestionResults(String examResultId) async {
    try {
      final box = await _questionResults;
      return box.get(examResultId) ?? [];
    } catch (e) {
      throw CacheException('Failed to get cached question results: $e');
    }
  }

  @override
  Future<void> updateCachedExamResult(ExamResultModel examResult) async {
    try {
      final box = await _examResults;
      await box.put(examResult.id, examResult);
    } catch (e) {
      throw CacheException('Failed to update cached exam result: $e');
    }
  }

  @override
  Future<void> removeCachedExamResult(String examResultId) async {
    try {
      final examBox = await _examResults;
      final questionBox = await _questionResults;
      
      await examBox.delete(examResultId);
      await questionBox.delete(examResultId);
    } catch (e) {
      throw CacheException('Failed to remove cached exam result: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final examBox = await _examResults;
      final questionBox = await _questionResults;
      final timestampBox = await _cacheTimestamps;
      final analyticsBox = await _analytics;
      final recommendationsBox = await _recommendations;
      
      await examBox.clear();
      await questionBox.clear();
      await timestampBox.clear();
      await analyticsBox.clear();
      await recommendationsBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<DateTime?> getExamResultsCacheTimestamp(String userId) async {
    try {
      final box = await _cacheTimestamps;
      return box.get('exam_results_$userId');
    } catch (e) {
      throw CacheException('Failed to get cache timestamp: $e');
    }
  }

  @override
  Future<void> setExamResultsCacheTimestamp(String userId, DateTime timestamp) async {
    try {
      final box = await _cacheTimestamps;
      await box.put('exam_results_$userId', timestamp);
    } catch (e) {
      throw CacheException('Failed to set cache timestamp: $e');
    }
  }

  @override
  Future<bool> isExamResultsCacheFresh(String userId, {Duration maxAge = const Duration(minutes: 30)}) async {
    try {
      final timestamp = await getExamResultsCacheTimestamp(userId);
      if (timestamp == null) return false;
      
      final now = DateTime.now();
      final age = now.difference(timestamp);
      
      return age <= maxAge;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedPerformanceAnalytics(String userId) async {
    try {
      final box = await _analytics;
      return box.get('analytics_$userId');
    } catch (e) {
      throw CacheException('Failed to get cached performance analytics: $e');
    }
  }

  @override
  Future<void> cachePerformanceAnalytics(String userId, Map<String, dynamic> analytics) async {
    try {
      final box = await _analytics;
      await box.put('analytics_$userId', analytics);
      
      // Also update timestamp
      await setExamResultsCacheTimestamp('analytics_$userId', DateTime.now());
    } catch (e) {
      throw CacheException('Failed to cache performance analytics: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>?> getCachedStudyRecommendations(String userId) async {
    try {
      final box = await _recommendations;
      return box.get('recommendations_$userId');
    } catch (e) {
      throw CacheException('Failed to get cached study recommendations: $e');
    }
  }

  @override
  Future<void> cacheStudyRecommendations(String userId, List<Map<String, dynamic>> recommendations) async {
    try {
      final box = await _recommendations;
      await box.put('recommendations_$userId', recommendations);
      
      // Also update timestamp
      await setExamResultsCacheTimestamp('recommendations_$userId', DateTime.now());
    } catch (e) {
      throw CacheException('Failed to cache study recommendations: $e');
    }
  }
}