import 'dart:async';
import 'dart:developer' as developer;
import '../../../../core/network/network_info.dart';
import '../../domain/entities/offline_exam.dart';
import '../../domain/entities/offline_session_upload.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/offline_repository.dart';
import '../../../connectivity/services/connectivity_service.dart';

class SyncManager {
  final OfflineRepository _offlineRepository;
  final ConnectivityService _connectivityService;
  final NetworkInfo _networkInfo;
  
  Timer? _syncTimer;
  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;
  
  // Sync configuration
  static const Duration _syncInterval = Duration(minutes: 5);
  static const int _maxRetryAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 30);
  
  SyncManager({
    required OfflineRepository offlineRepository,
    required ConnectivityService connectivityService,
    required NetworkInfo networkInfo,
  }) : _offlineRepository = offlineRepository,
       _connectivityService = connectivityService,
       _networkInfo = networkInfo;

  /// Initialize the sync manager
  Future<void> initialize() async {
    developer.log('SyncManager: Initializing', name: 'SyncManager');
    
    // Listen to connectivity changes
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (isConnected) {
        if (isConnected) {
          developer.log('SyncManager: Network connected, starting sync', name: 'SyncManager');
          _startPeriodicSync();
          _syncPendingSessions();
        } else {
          developer.log('SyncManager: Network disconnected, stopping sync', name: 'SyncManager');
          _stopPeriodicSync();
        }
      },
    );
    
    // Start periodic sync if connected
    if (await _networkInfo.isConnected) {
      _startPeriodicSync();
    }
  }

  /// Dispose resources
  void dispose() {
    developer.log('SyncManager: Disposing', name: 'SyncManager');
    _stopPeriodicSync();
    _connectivitySubscription?.cancel();
  }

  /// Start periodic synchronization
  void _startPeriodicSync() {
    if (_syncTimer?.isActive == true) return;
    
    _syncTimer = Timer.periodic(_syncInterval, (_) {
      _syncPendingSessions();
    });
    
    developer.log('SyncManager: Periodic sync started', name: 'SyncManager');
  }

  /// Stop periodic synchronization
  void _stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    developer.log('SyncManager: Periodic sync stopped', name: 'SyncManager');
  }

  /// Sync all pending sessions
  Future<void> _syncPendingSessions() async {
    if (_isSyncing) {
      developer.log('SyncManager: Sync already in progress, skipping', name: 'SyncManager');
      return;
    }
    
    if (!await _networkInfo.isConnected) {
      developer.log('SyncManager: No network connection, skipping sync', name: 'SyncManager');
      return;
    }
    
    _isSyncing = true;
    
    try {
      developer.log('SyncManager: Starting sync of pending sessions', name: 'SyncManager');
      
      final result = await _offlineRepository.syncPendingSessions();
      
      result.fold(
        (failure) {
          developer.log('SyncManager: Sync failed: ${failure.message}', name: 'SyncManager');
        },
        (_) {
          developer.log('SyncManager: Sync completed successfully', name: 'SyncManager');
        },
      );
    } catch (e) {
      developer.log('SyncManager: Sync error: $e', name: 'SyncManager');
    } finally {
      _isSyncing = false;
    }
  }

  /// Force sync all pending sessions immediately
  Future<bool> forceSyncPendingSessions() async {
    if (!await _networkInfo.isConnected) {
      developer.log('SyncManager: Force sync failed - no network', name: 'SyncManager');
      return false;
    }
    
    developer.log('SyncManager: Force sync requested', name: 'SyncManager');
    
    final result = await _offlineRepository.syncPendingSessions();
    
    return result.fold(
      (failure) {
        developer.log('SyncManager: Force sync failed: ${failure.message}', name: 'SyncManager');
        return false;
      },
      (_) {
        developer.log('SyncManager: Force sync completed', name: 'SyncManager');
        return true;
      },
    );
  }

  /// Sync a specific session with retry logic
  Future<bool> syncSession(OfflineSessionUpload session, {int retryCount = 0}) async {
    if (!await _networkInfo.isConnected) {
      developer.log('SyncManager: Session sync failed - no network', name: 'SyncManager');
      return false;
    }
    
    developer.log('SyncManager: Syncing session ${session.sessionId}', name: 'SyncManager');
    
    final result = await _offlineRepository.syncOfflineSession(session);
    
    return result.fold(
      (failure) {
        developer.log('SyncManager: Session sync failed: ${failure.message}', name: 'SyncManager');
        
        // Retry logic
        if (retryCount < _maxRetryAttempts) {
          developer.log('SyncManager: Retrying session sync (${retryCount + 1}/$_maxRetryAttempts)', name: 'SyncManager');
          
          Timer(_retryDelay, () {
            syncSession(session, retryCount: retryCount + 1);
          });
        }
        
        return false;
      },
      (_) {
        developer.log('SyncManager: Session sync completed: ${session.sessionId}', name: 'SyncManager');
        return true;
      },
    );
  }

  /// Get sync statistics
  Future<SyncStatistics> getSyncStatistics() async {
    final statusesResult = await _offlineRepository.getSyncStatuses();
    final storageSizeResult = await _offlineRepository.getStorageSize();
    
    return statusesResult.fold(
      (failure) => SyncStatistics.empty(),
      (statuses) {
        final pending = statuses.where((s) => s.status == SyncStatusType.pending).length;
        final syncing = statuses.where((s) => s.status == SyncStatusType.syncing).length;
        final completed = statuses.where((s) => s.status == SyncStatusType.completed).length;
        final failed = statuses.where((s) => s.status == SyncStatusType.failed).length;
        final conflict = statuses.where((s) => s.status == SyncStatusType.conflict).length;
        
        final storageSize = storageSizeResult.fold((failure) => 0, (size) => size);
        
        return SyncStatistics(
          totalSessions: statuses.length,
          pendingSessions: pending,
          syncingSessions: syncing,
          completedSessions: completed,
          failedSessions: failed,
          conflictSessions: conflict,
          storageSize: storageSize,
          lastSyncTime: _getLastSyncTime(statuses),
        );
      },
    );
  }

  /// Check for exam updates and download if needed
  Future<List<String>> checkAndUpdateExams(List<String> examIds) async {
    if (!await _networkInfo.isConnected) {
      developer.log('SyncManager: Exam update check failed - no network', name: 'SyncManager');
      return [];
    }
    
    developer.log('SyncManager: Checking exam updates for ${examIds.length} exams', name: 'SyncManager');
    
    final result = await _offlineRepository.checkExamUpdates(examIds);
    
    return result.fold(
      (failure) {
        developer.log('SyncManager: Exam update check failed: ${failure.message}', name: 'SyncManager');
        return <String>[];
      },
      (versions) {
        final updatedExams = <String>[];
        
        for (final examId in examIds) {
          final serverVersion = versions[examId];
          if (serverVersion != null) {
            // Check if local version is different
            _checkLocalExamVersion(examId, serverVersion).then((needsUpdate) {
              if (needsUpdate) {
                updatedExams.add(examId);
                _downloadExamUpdate(examId);
              }
            });
          }
        }
        
        return updatedExams;
      },
    );
  }

  /// Check if local exam version needs update
  Future<bool> _checkLocalExamVersion(String examId, String serverVersion) async {
    final result = await _offlineRepository.getOfflineExam(examId);
    
    return result.fold(
      (failure) => true, // If can't get local exam, assume update needed
      (exam) => exam?.version != serverVersion,
    );
  }

  /// Download exam update
  Future<void> _downloadExamUpdate(String examId) async {
    developer.log('SyncManager: Downloading exam update: $examId', name: 'SyncManager');
    
    final result = await _offlineRepository.downloadExam(examId);
    
    result.fold(
      (failure) {
        developer.log('SyncManager: Exam update download failed: ${failure.message}', name: 'SyncManager');
      },
      (exam) {
        developer.log('SyncManager: Exam update downloaded: ${exam.id}', name: 'SyncManager');
      },
    );
  }

  /// Get last sync time from statuses
  DateTime? _getLastSyncTime(List<SyncStatus> statuses) {
    if (statuses.isEmpty) return null;
    
    final sortedStatuses = statuses.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    
    return sortedStatuses.first.updatedAt;
  }

  /// Get current sync status
  bool get isSyncing => _isSyncing;
  
  /// Get network connection status
  Future<bool> get isConnected => _networkInfo.isConnected;
}

/// Sync statistics data class
class SyncStatistics {
  final int totalSessions;
  final int pendingSessions;
  final int syncingSessions;
  final int completedSessions;
  final int failedSessions;
  final int conflictSessions;
  final int storageSize;
  final DateTime? lastSyncTime;

  const SyncStatistics({
    required this.totalSessions,
    required this.pendingSessions,
    required this.syncingSessions,
    required this.completedSessions,
    required this.failedSessions,
    required this.conflictSessions,
    required this.storageSize,
    this.lastSyncTime,
  });

  factory SyncStatistics.empty() {
    return const SyncStatistics(
      totalSessions: 0,
      pendingSessions: 0,
      syncingSessions: 0,
      completedSessions: 0,
      failedSessions: 0,
      conflictSessions: 0,
      storageSize: 0,
    );
  }

  double get completionRate {
    if (totalSessions == 0) return 0.0;
    return completedSessions / totalSessions;
  }

  bool get hasPendingSync => pendingSessions > 0 || syncingSessions > 0;
  
  bool get hasErrors => failedSessions > 0 || conflictSessions > 0;

  String get storageSizeFormatted {
    if (storageSize < 1024) return '${storageSize}B';
    if (storageSize < 1024 * 1024) return '${(storageSize / 1024).toStringAsFixed(1)}KB';
    return '${(storageSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}