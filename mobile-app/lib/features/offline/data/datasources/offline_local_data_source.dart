import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/offline_exam_model.dart';
import '../models/offline_session_upload_model.dart';
import '../models/sync_status_model.dart';

abstract class OfflineLocalDataSource {
  /// Offline Exam Operations
  Future<void> cacheOfflineExam(OfflineExamModel exam);
  Future<OfflineExamModel?> getCachedOfflineExam(String examId);
  Future<List<OfflineExamModel>> getAllCachedOfflineExams();
  Future<void> removeCachedOfflineExam(String examId);
  Future<void> clearAllCachedOfflineExams();
  
  /// Session Upload Operations
  Future<void> cacheSessionUpload(OfflineSessionUploadModel session);
  Future<OfflineSessionUploadModel?> getCachedSessionUpload(String sessionId);
  Future<List<OfflineSessionUploadModel>> getAllCachedSessionUploads();
  Future<void> removeCachedSessionUpload(String sessionId);
  Future<void> updateSessionUploadProgress(String sessionId, double progress);
  
  /// Sync Status Operations
  Future<void> cacheSyncStatus(SyncStatusModel syncStatus);
  Future<SyncStatusModel?> getCachedSyncStatus(String sessionId);
  Future<List<SyncStatusModel>> getAllCachedSyncStatuses();
  Future<void> removeCachedSyncStatus(String sessionId);
  Future<void> updateSyncStatus(String sessionId, SyncStatusModel updatedStatus);
  
  /// Storage Management
  Future<int> getTotalStorageSize();
  Future<void> clearExpiredExams();
  Future<void> clearAllCache();
}

class OfflineLocalDataSourceImpl implements OfflineLocalDataSource {
  static const String _offlineExamsBoxName = 'offline_exams';
  static const String _sessionUploadsBoxName = 'session_uploads';
  static const String _syncStatusBoxName = 'sync_status';

  Box<OfflineExamModel>? _offlineExamsBox;
  Box<OfflineSessionUploadModel>? _sessionUploadsBox;
  Box<SyncStatusModel>? _syncStatusBox;

  /// Initialize Hive boxes
  Future<void> init() async {
    _offlineExamsBox = await Hive.openBox<OfflineExamModel>(_offlineExamsBoxName);
    _sessionUploadsBox = await Hive.openBox<OfflineSessionUploadModel>(_sessionUploadsBoxName);
    _syncStatusBox = await Hive.openBox<SyncStatusModel>(_syncStatusBoxName);
  }

  /// Ensure boxes are initialized
  void _ensureInitialized() {
    if (_offlineExamsBox == null || _sessionUploadsBox == null || _syncStatusBox == null) {
      throw CacheException('Local data source not initialized. Call init() first.');
    }
  }

  // Offline Exam Operations
  @override
  Future<void> cacheOfflineExam(OfflineExamModel exam) async {
    _ensureInitialized();
    try {
      await _offlineExamsBox!.put(exam.id, exam);
    } catch (e) {
      throw CacheException('Failed to cache offline exam: $e');
    }
  }

  @override
  Future<OfflineExamModel?> getCachedOfflineExam(String examId) async {
    _ensureInitialized();
    try {
      return _offlineExamsBox!.get(examId);
    } catch (e) {
      throw CacheException('Failed to get cached offline exam: $e');
    }
  }

  @override
  Future<List<OfflineExamModel>> getAllCachedOfflineExams() async {
    _ensureInitialized();
    try {
      return _offlineExamsBox!.values.toList();
    } catch (e) {
      throw CacheException('Failed to get all cached offline exams: $e');
    }
  }

  @override
  Future<void> removeCachedOfflineExam(String examId) async {
    _ensureInitialized();
    try {
      await _offlineExamsBox!.delete(examId);
    } catch (e) {
      throw CacheException('Failed to remove cached offline exam: $e');
    }
  }

  @override
  Future<void> clearAllCachedOfflineExams() async {
    _ensureInitialized();
    try {
      await _offlineExamsBox!.clear();
    } catch (e) {
      throw CacheException('Failed to clear all cached offline exams: $e');
    }
  }

  // Session Upload Operations
  @override
  Future<void> cacheSessionUpload(OfflineSessionUploadModel session) async {
    _ensureInitialized();
    try {
      await _sessionUploadsBox!.put(session.sessionId, session);
    } catch (e) {
      throw CacheException('Failed to cache session upload: $e');
    }
  }

  @override
  Future<OfflineSessionUploadModel?> getCachedSessionUpload(String sessionId) async {
    _ensureInitialized();
    try {
      return _sessionUploadsBox!.get(sessionId);
    } catch (e) {
      throw CacheException('Failed to get cached session upload: $e');
    }
  }

  @override
  Future<List<OfflineSessionUploadModel>> getAllCachedSessionUploads() async {
    _ensureInitialized();
    try {
      return _sessionUploadsBox!.values.toList();
    } catch (e) {
      throw CacheException('Failed to get all cached session uploads: $e');
    }
  }

  @override
  Future<void> removeCachedSessionUpload(String sessionId) async {
    _ensureInitialized();
    try {
      await _sessionUploadsBox!.delete(sessionId);
    } catch (e) {
      throw CacheException('Failed to remove cached session upload: $e');
    }
  }

  @override
  Future<void> updateSessionUploadProgress(String sessionId, double progress) async {
    _ensureInitialized();
    try {
      final session = _sessionUploadsBox!.get(sessionId);
      if (session != null) {
        final updatedSession = OfflineSessionUploadModel(
          sessionId: session.sessionId,
          examId: session.examId,
          userId: session.userId,
          answers: session.answers,
          startTime: session.startTime,
          endTime: session.endTime,
          deviceInfo: session.deviceInfo,
          metadata: session.metadata,
          uploadProgress: progress,
          lastUploadAttempt: DateTime.now(),
          uploadError: session.uploadError,
        );
        await _sessionUploadsBox!.put(sessionId, updatedSession);
      }
    } catch (e) {
      throw CacheException('Failed to update session upload progress: $e');
    }
  }

  // Sync Status Operations
  @override
  Future<void> cacheSyncStatus(SyncStatusModel syncStatus) async {
    _ensureInitialized();
    try {
      await _syncStatusBox!.put(syncStatus.sessionId, syncStatus);
    } catch (e) {
      throw CacheException('Failed to cache sync status: $e');
    }
  }

  @override
  Future<SyncStatusModel?> getCachedSyncStatus(String sessionId) async {
    _ensureInitialized();
    try {
      return _syncStatusBox!.get(sessionId);
    } catch (e) {
      throw CacheException('Failed to get cached sync status: $e');
    }
  }

  @override
  Future<List<SyncStatusModel>> getAllCachedSyncStatuses() async {
    _ensureInitialized();
    try {
      return _syncStatusBox!.values.toList();
    } catch (e) {
      throw CacheException('Failed to get all cached sync statuses: $e');
    }
  }

  @override
  Future<void> removeCachedSyncStatus(String sessionId) async {
    _ensureInitialized();
    try {
      await _syncStatusBox!.delete(sessionId);
    } catch (e) {
      throw CacheException('Failed to remove cached sync status: $e');
    }
  }

  @override
  Future<void> updateSyncStatus(String sessionId, SyncStatusModel updatedStatus) async {
    _ensureInitialized();
    try {
      await _syncStatusBox!.put(sessionId, updatedStatus);
    } catch (e) {
      throw CacheException('Failed to update sync status: $e');
    }
  }

  // Storage Management
  @override
  Future<int> getTotalStorageSize() async {
    _ensureInitialized();
    try {
      int totalSize = 0;
      
      // Calculate size from offline exams
      final offlineExams = await getAllCachedOfflineExams();
      for (final exam in offlineExams) {
        totalSize += exam.storageSizeBytes;
      }
      
      // Add estimated size for session uploads and sync statuses
      final sessionUploads = await getAllCachedSessionUploads();
      totalSize += sessionUploads.length * 1024; // Estimate 1KB per session
      
      final syncStatuses = await getAllCachedSyncStatuses();
      totalSize += syncStatuses.length * 512; // Estimate 512B per sync status
      
      return totalSize;
    } catch (e) {
      throw CacheException('Failed to calculate total storage size: $e');
    }
  }

  @override
  Future<void> clearExpiredExams() async {
    _ensureInitialized();
    try {
      final now = DateTime.now();
      final allExams = await getAllCachedOfflineExams();
      
      for (final exam in allExams) {
        if (exam.expiresAt != null && exam.expiresAt!.isBefore(now)) {
          await removeCachedOfflineExam(exam.id);
        }
      }
    } catch (e) {
      throw CacheException('Failed to clear expired exams: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    _ensureInitialized();
    try {
      await _offlineExamsBox!.clear();
      await _sessionUploadsBox!.clear();
      await _syncStatusBox!.clear();
    } catch (e) {
      throw CacheException('Failed to clear all cache: $e');
    }
  }

  /// Close all boxes (call this when disposing)
  Future<void> dispose() async {
    await _offlineExamsBox?.close();
    await _sessionUploadsBox?.close();
    await _syncStatusBox?.close();
  }
}