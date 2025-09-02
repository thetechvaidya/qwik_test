import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../models/exam_model.dart';
import '../models/category_model.dart';

/// Abstract interface for exam local data source
abstract class ExamLocalDataSource {
  /// Initialize the data source
  Future<void> init();

  /// Cache paginated exams
  Future<void> cacheExams(
    List<ExamModel> exams, {
    String? cacheKey,
  });

  /// Get cached exams
  Future<List<ExamModel>> getCachedExams({
    String? cacheKey,
    int? limit,
    int? offset,
  });

  /// Cache single exam
  Future<void> cacheExam(ExamModel exam);

  /// Get cached exam by ID
  Future<ExamModel?> getCachedExam(String examId);

  /// Cache categories
  Future<void> cacheCategories(List<CategoryModel> categories);

  /// Get cached categories
  Future<List<CategoryModel>> getCachedCategories({
    String? parentId,
  });

  /// Cache single category
  Future<void> cacheCategory(CategoryModel category);

  /// Get cached category by ID
  Future<CategoryModel?> getCachedCategory(String categoryId);

  /// Cache search results
  Future<void> cacheSearchResults(
    String query,
    List<ExamModel> results,
  );

  /// Get cached search results
  Future<List<ExamModel>?> getCachedSearchResults(String query);

  /// Cache user exam progress
  Future<void> cacheUserExamProgress(UserExamProgressModel progress);

  /// Get cached user exam progress
  Future<UserExamProgressModel?> getCachedUserExamProgress(String examId);

  /// Clear all cached data
  Future<void> clearCache();

  /// Clear cached exams
  Future<void> clearCachedExams();

  /// Clear cached categories
  Future<void> clearCachedCategories();

  /// Clear cached search results
  Future<void> clearCachedSearchResults();

  /// Clear cached user progress
  Future<void> clearCachedUserProgress();

  /// Check if cache is expired
  bool isCacheExpired(String cacheKey, {Duration? maxAge});

  /// Update cache timestamp
  Future<void> updateCacheTimestamp(String cacheKey);
}

/// Implementation of exam local data source using Hive
class ExamLocalDataSourceImpl implements ExamLocalDataSource {
  static const String _examsBoxName = 'exams';
  static const String _categoriesBoxName = 'categories';
  static const String _searchBoxName = 'exam_search';
  static const String _progressBoxName = 'exam_progress';
  static const String _metadataBoxName = 'exam_metadata';

  late Box<ExamModel> _examsBox;
  late Box<CategoryModel> _categoriesBox;
  late Box<List<dynamic>> _searchBox;
  late Box<UserExamProgressModel> _progressBox;
  late Box<Map<dynamic, dynamic>> _metadataBox;

  bool _isInitialized = false;

  /// Initialize Hive boxes
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _examsBox = await Hive.openBox<ExamModel>(_examsBoxName);
      _categoriesBox = await Hive.openBox<CategoryModel>(_categoriesBoxName);
      _searchBox = await Hive.openBox<List<dynamic>>(_searchBoxName);
      _progressBox = await Hive.openBox<UserExamProgressModel>(_progressBoxName);
      _metadataBox = await Hive.openBox<Map<dynamic, dynamic>>(_metadataBoxName);
      
      _isInitialized = true;
    } catch (e) {
      throw CacheException(message: 'Failed to initialize local storage: $e');
    }
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw CacheException(message: 'Local data source not initialized');
    }
  }

  @override
  Future<void> cacheExams(
    List<ExamModel> exams, {
    String? cacheKey,
  }) async {
    try {
      _ensureInitialized();
      
      // Cache individual exams
      for (final exam in exams) {
        await _examsBox.put(exam.id, exam);
      }

      // Cache exam list with key
      if (cacheKey != null) {
        final examIds = exams.map((e) => e.id).toList();
        await _metadataBox.put('exam_list_$cacheKey', {
          'exam_ids': examIds,
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        });
      }

      await updateCacheTimestamp('exams');
    } catch (e) {
      throw CacheException(message: 'Failed to cache exams: $e');
    }
  }

  @override
  Future<List<ExamModel>> getCachedExams({
    String? cacheKey,
    int? limit,
    int? offset,
  }) async {
    try {
      _ensureInitialized();

      List<ExamModel> exams = [];

      if (cacheKey != null) {
        // Get exams by cache key
        final metadata = _metadataBox.get('exam_list_$cacheKey');
        if (metadata != null) {
          final examIds = List<String>.from(metadata['exam_ids'] ?? []);
          for (final examId in examIds) {
            final exam = _examsBox.get(examId);
            if (exam != null) {
              exams.add(exam);
            }
          }
        }
      } else {
        // Get all cached exams
        exams = _examsBox.values.toList();
      }

      // Apply pagination
      if (offset != null) {
        exams = exams.skip(offset).toList();
      }
      if (limit != null) {
        exams = exams.take(limit).toList();
      }

      return exams;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached exams: $e');
    }
  }

  @override
  Future<void> cacheExam(ExamModel exam) async {
    try {
      _ensureInitialized();
      await _examsBox.put(exam.id, exam);
      await updateCacheTimestamp('exam_${exam.id}');
    } catch (e) {
      throw CacheException(message: 'Failed to cache exam: $e');
    }
  }

  @override
  Future<ExamModel?> getCachedExam(String examId) async {
    try {
      _ensureInitialized();
      return _examsBox.get(examId);
    } catch (e) {
      throw CacheException(message: 'Failed to get cached exam: $e');
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      _ensureInitialized();
      
      for (final category in categories) {
        await _categoriesBox.put(category.id, category);
      }

      await updateCacheTimestamp('categories');
    } catch (e) {
      throw CacheException(message: 'Failed to cache categories: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCachedCategories({
    String? parentId,
  }) async {
    try {
      _ensureInitialized();
      
      final allCategories = _categoriesBox.values.toList();
      
      if (parentId != null) {
        return allCategories.where((cat) => cat.parentId == parentId).toList();
      }
      
      return allCategories;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached categories: $e');
    }
  }

  @override
  Future<void> cacheCategory(CategoryModel category) async {
    try {
      _ensureInitialized();
      await _categoriesBox.put(category.id, category);
      await updateCacheTimestamp('category_${category.id}');
    } catch (e) {
      throw CacheException(message: 'Failed to cache category: $e');
    }
  }

  @override
  Future<CategoryModel?> getCachedCategory(String categoryId) async {
    try {
      _ensureInitialized();
      return _categoriesBox.get(categoryId);
    } catch (e) {
      throw CacheException(message: 'Failed to get cached category: $e');
    }
  }

  @override
  Future<void> cacheSearchResults(
    String query,
    List<ExamModel> results,
  ) async {
    try {
      _ensureInitialized();
      
      final examIds = results.map((e) => e.id).toList();
      await _searchBox.put(query.toLowerCase(), examIds);
      
      // Also cache individual exams
      for (final exam in results) {
        await _examsBox.put(exam.id, exam);
      }

      await updateCacheTimestamp('search_$query');
    } catch (e) {
      throw CacheException(message: 'Failed to cache search results: $e');
    }
  }

  @override
  Future<List<ExamModel>?> getCachedSearchResults(String query) async {
    try {
      _ensureInitialized();
      
      final examIds = _searchBox.get(query.toLowerCase());
      if (examIds == null) return null;

      final results = <ExamModel>[];
      for (final examId in examIds) {
        final exam = _examsBox.get(examId);
        if (exam != null) {
          results.add(exam);
        }
      }

      return results.isNotEmpty ? results : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached search results: $e');
    }
  }

  @override
  Future<void> cacheUserExamProgress(UserExamProgressModel progress) async {
    try {
      _ensureInitialized();
      await _progressBox.put(progress.examId, progress);
      await updateCacheTimestamp('progress_${progress.examId}');
    } catch (e) {
      throw CacheException(message: 'Failed to cache user exam progress: $e');
    }
  }

  @override
  Future<UserExamProgressModel?> getCachedUserExamProgress(String examId) async {
    try {
      _ensureInitialized();
      return _progressBox.get(examId);
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user exam progress: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _ensureInitialized();
      await Future.wait([
        _examsBox.clear(),
        _categoriesBox.clear(),
        _searchBox.clear(),
        _progressBox.clear(),
        _metadataBox.clear(),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }

  @override
  Future<void> clearCachedExams() async {
    try {
      _ensureInitialized();
      await _examsBox.clear();
      
      // Clear exam list metadata
      final keysToRemove = _metadataBox.keys
          .where((key) => key.toString().startsWith('exam_list_'))
          .toList();
      for (final key in keysToRemove) {
        await _metadataBox.delete(key);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached exams: $e');
    }
  }

  @override
  Future<void> clearCachedCategories() async {
    try {
      _ensureInitialized();
      await _categoriesBox.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached categories: $e');
    }
  }

  @override
  Future<void> clearCachedSearchResults() async {
    try {
      _ensureInitialized();
      await _searchBox.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached search results: $e');
    }
  }

  @override
  Future<void> clearCachedUserProgress() async {
    try {
      _ensureInitialized();
      await _progressBox.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached user progress: $e');
    }
  }

  @override
  bool isCacheExpired(String cacheKey, {Duration? maxAge}) {
    try {
      _ensureInitialized();
      
      final metadata = _metadataBox.get('timestamp_$cacheKey');
      if (metadata == null) return true;

      final cachedAt = DateTime.fromMillisecondsSinceEpoch(
        metadata['timestamp'] as int,
      );
      
      final age = maxAge ?? const Duration(hours: 1);
      return DateTime.now().difference(cachedAt) > age;
    } catch (e) {
      return true; // Consider expired if error occurs
    }
  }

  @override
  Future<void> updateCacheTimestamp(String cacheKey) async {
    try {
      _ensureInitialized();
      await _metadataBox.put('timestamp_$cacheKey', {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw CacheException(message: 'Failed to update cache timestamp: $e');
    }
  }

  /// Close all boxes
  Future<void> close() async {
    if (!_isInitialized) return;
    
    await Future.wait([
      _examsBox.close(),
      _categoriesBox.close(),
      _searchBox.close(),
      _progressBox.close(),
      _metadataBox.close(),
    ]);
    
    _isInitialized = false;
  }
}