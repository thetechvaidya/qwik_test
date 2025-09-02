import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/offline_exam.dart';
import '../../domain/entities/offline_session_upload.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/offline_repository.dart';
import '../datasources/offline_local_data_source.dart';
import '../datasources/offline_remote_data_source.dart';
import '../models/offline_exam_model.dart';
import '../models/offline_session_upload_model.dart';
import '../models/sync_status_model.dart';

class OfflineRepositoryImpl implements OfflineRepository {
  final OfflineRemoteDataSource remoteDataSource;
  final OfflineLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  OfflineRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OfflineExam>> downloadExam(String examId) async {
    try {
      // Check network connectivity
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection available'));
      }

      // Download from remote
      final remoteExam = await remoteDataSource.downloadExam(examId);
      
      // Cache locally
      await localDataSource.cacheOfflineExam(remoteExam);
      
      return Right(remoteExam.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OfflineExam>>> getOfflineExams() async {
    try {
      final cachedExams = await localDataSource.getAllCachedOfflineExams();
      final entities = cachedExams.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, OfflineExam?>> getOfflineExam(String examId) async {
    try {
      final cachedExam = await localDataSource.getCachedOfflineExam(examId);
      return Right(cachedExam?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeOfflineExam(String examId) async {
    try {
      await localDataSource.removeCachedOfflineExam(examId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncOfflineSession(OfflineSessionUpload session) async {
    try {
      // Cache session for upload
      final sessionModel = OfflineSessionUploadModel.fromEntity(session);
      await localDataSource.cacheSessionUpload(sessionModel);
      
      // Create initial sync status
      final syncStatus = SyncStatusModel(
        sessionId: session.sessionId,
        examId: session.examId,
        userId: session.userId,
        statusString: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await localDataSource.cacheSyncStatus(syncStatus);
      
      // Try immediate upload if connected
      if (await networkInfo.isConnected) {
        return await _attemptUpload(session.sessionId);
      }
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SyncStatus>>> getSyncStatuses() async {
    try {
      final cachedStatuses = await localDataSource.getAllCachedSyncStatuses();
      final entities = cachedStatuses.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncPendingSessions() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection available'));
      }

      final pendingSessions = await localDataSource.getAllCachedSessionUploads();
      final results = <Either<Failure, void>>[];
      
      for (final session in pendingSessions) {
        if (session.uploadProgress < 1.0) {
          final result = await _attemptUpload(session.sessionId);
          results.add(result);
        }
      }
      
      // Return success if at least one upload succeeded
      final hasSuccess = results.any((result) => result.isRight());
      if (hasSuccess || results.isEmpty) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to sync all pending sessions'));
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> checkExamUpdates(List<String> examIds) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection available'));
      }

      final versions = await remoteDataSource.checkExamVersions(examIds);
      return Right(versions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableOfflineExams(String userId) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection available'));
      }

      final examIds = await remoteDataSource.getAvailableOfflineExams(userId);
      return Right(examIds);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getStorageSize() async {
    try {
      final size = await localDataSource.getTotalStorageSize();
      return Right(size);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearExpiredExams() async {
    try {
      await localDataSource.clearExpiredExams();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllOfflineData() async {
    try {
      await localDataSource.clearAllCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  /// Attempt to upload a session
  Future<Either<Failure, void>> _attemptUpload(String sessionId) async {
    try {
      final session = await localDataSource.getCachedSessionUpload(sessionId);
      if (session == null) {
        return Left(CacheFailure('Session not found in cache'));
      }

      // Update sync status to syncing
      final syncingStatus = SyncStatusModel(
        sessionId: sessionId,
        examId: session.examId,
        userId: session.userId,
        statusString: 'syncing',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastAttemptAt: DateTime.now(),
      );
      await localDataSource.updateSyncStatus(sessionId, syncingStatus);

      // Update upload progress
      await localDataSource.updateSessionUploadProgress(sessionId, 0.1);

      // Attempt upload
      await remoteDataSource.uploadSession(session);

      // Mark as completed
      await localDataSource.updateSessionUploadProgress(sessionId, 1.0);
      
      final completedStatus = syncingStatus.copyWith(
        statusString: 'completed',
        updatedAt: DateTime.now(),
      );
      await localDataSource.updateSyncStatus(sessionId, completedStatus);

      // Remove from upload queue
      await localDataSource.removeCachedSessionUpload(sessionId);

      return const Right(null);
    } on ConflictException catch (e) {
      // Handle conflict - session already exists
      final conflictStatus = SyncStatusModel(
        sessionId: sessionId,
        examId: '',
        userId: '',
        statusString: 'conflict',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastAttemptAt: DateTime.now(),
        errorMessage: e.message,
      );
      await localDataSource.updateSyncStatus(sessionId, conflictStatus);
      return Left(ConflictFailure(e.message));
    } on ServerException catch (e) {
      // Handle server error
      final failedStatus = SyncStatusModel(
        sessionId: sessionId,
        examId: '',
        userId: '',
        statusString: 'failed',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastAttemptAt: DateTime.now(),
        retryCount: 1,
        errorMessage: e.message,
      );
      await localDataSource.updateSyncStatus(sessionId, failedStatus);
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Upload failed: $e'));
    }
  }
}

/// Additional failure types for offline operations
class ConflictFailure extends Failure {
  ConflictFailure(String message) : super(message);
}

class UnknownFailure extends Failure {
  UnknownFailure(String message) : super(message);
}