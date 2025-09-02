import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offline_exam.dart';
import '../entities/offline_session_upload.dart';
import '../entities/sync_status.dart';

abstract class OfflineRepository {
  /// Download an exam for offline use
  Future<Either<Failure, OfflineExam>> downloadExam(String examId);
  
  /// Get all offline exams stored locally
  Future<Either<Failure, List<OfflineExam>>> getOfflineExams();
  
  /// Get a specific offline exam by ID
  Future<Either<Failure, OfflineExam?>> getOfflineExam(String examId);
  
  /// Remove an offline exam from local storage
  Future<Either<Failure, void>> removeOfflineExam(String examId);
  
  /// Sync an offline exam session to the server
  Future<Either<Failure, void>> syncOfflineSession(OfflineSessionUpload session);
  
  /// Get all sync statuses
  Future<Either<Failure, List<SyncStatus>>> getSyncStatuses();
  
  /// Sync all pending sessions to the server
  Future<Either<Failure, void>> syncPendingSessions();
  
  /// Check for exam updates on the server
  Future<Either<Failure, Map<String, String>>> checkExamUpdates(List<String> examIds);
  
  /// Get available offline exams for a user from the server
  Future<Either<Failure, List<String>>> getAvailableOfflineExams(String userId);
  
  /// Get total storage size used by offline data
  Future<Either<Failure, int>> getStorageSize();
  
  /// Clear expired offline exams
  Future<Either<Failure, void>> clearExpiredExams();
  
  /// Clear all offline data
  Future<Either<Failure, void>> clearAllOfflineData();
}