import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'connectivity_service.dart';

/// Service for managing background synchronization tasks
class BackgroundSyncService {
  static const String _syncTaskName = 'offline_data_sync';
  static const String _periodicSyncTaskName = 'periodic_offline_sync';
  
  final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isInitialized = false;

  BackgroundSyncService(this._connectivityService);

  /// Initialize the background sync service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize WorkManager
      await Workmanager().initialize(
        _callbackDispatcher,
        isInDebugMode: kDebugMode,
      );
      
      // Listen to connectivity changes
      _connectivitySubscription = _connectivityService.connectionStream.listen(
        _onConnectivityChanged,
      );
      
      // Schedule periodic sync
      await _schedulePeriodicSync();
      
      _isInitialized = true;
      debugPrint('BackgroundSyncService initialized');
    } catch (e) {
      debugPrint('Failed to initialize BackgroundSyncService: $e');
      rethrow;
    }
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(bool isConnected) {
    if (isConnected) {
      debugPrint('Connection restored, scheduling immediate sync');
      scheduleImmediateSync();
    }
  }

  /// Schedule immediate sync when connection is available
  Future<void> scheduleImmediateSync() async {
    if (!_isInitialized) {
      debugPrint('BackgroundSyncService not initialized');
      return;
    }
    
    try {
      await Workmanager().registerOneOffTask(
        'immediate_sync_${DateTime.now().millisecondsSinceEpoch}',
        _syncTaskName,
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        initialDelay: const Duration(seconds: 5), // Small delay to ensure connection is stable
      );
      
      debugPrint('Immediate sync task scheduled');
    } catch (e) {
      debugPrint('Failed to schedule immediate sync: $e');
    }
  }

  /// Schedule periodic background sync
  Future<void> _schedulePeriodicSync() async {
    try {
      await Workmanager().registerPeriodicTask(
        'periodic_sync',
        _periodicSyncTaskName,
        frequency: const Duration(hours: 6), // Sync every 6 hours
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: true,
        ),
        backoffPolicy: BackoffPolicy.exponential,
        backoffPolicyDelay: const Duration(minutes: 15),
      );
      
      debugPrint('Periodic sync task scheduled');
    } catch (e) {
      debugPrint('Failed to schedule periodic sync: $e');
    }
  }

  /// Cancel all sync tasks
  Future<void> cancelAllSyncTasks() async {
    try {
      await Workmanager().cancelAll();
      debugPrint('All sync tasks cancelled');
    } catch (e) {
      debugPrint('Failed to cancel sync tasks: $e');
    }
  }

  /// Cancel specific sync task
  Future<void> cancelSyncTask(String taskId) async {
    try {
      await Workmanager().cancelByUniqueName(taskId);
      debugPrint('Sync task $taskId cancelled');
    } catch (e) {
      debugPrint('Failed to cancel sync task $taskId: $e');
    }
  }

  /// Get platform-specific sync constraints
  Constraints _getPlatformConstraints() {
    if (Platform.isIOS) {
      return Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: true,
      );
    } else {
      // Android constraints
      return Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      );
    }
  }

  /// Schedule sync with custom delay
  Future<void> scheduleSyncWithDelay(Duration delay) async {
    if (!_isInitialized) return;
    
    try {
      await Workmanager().registerOneOffTask(
        'delayed_sync_${DateTime.now().millisecondsSinceEpoch}',
        _syncTaskName,
        constraints: _getPlatformConstraints(),
        initialDelay: delay,
      );
      
      debugPrint('Delayed sync task scheduled for ${delay.inMinutes} minutes');
    } catch (e) {
      debugPrint('Failed to schedule delayed sync: $e');
    }
  }

  /// Check if background tasks are supported
  bool get isBackgroundTaskSupported {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _isInitialized = false;
    debugPrint('BackgroundSyncService disposed');
  }
}

/// Callback dispatcher for WorkManager background tasks
@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Background task started: $task');
    
    try {
      switch (task) {
        case BackgroundSyncService._syncTaskName:
        case BackgroundSyncService._periodicSyncTaskName:
          await _performBackgroundSync(inputData);
          break;
        default:
          debugPrint('Unknown background task: $task');
          return false;
      }
      
      debugPrint('Background task completed successfully: $task');
      return true;
    } catch (e) {
      debugPrint('Background task failed: $task, error: $e');
      return false;
    }
  });
}

/// Perform the actual background sync operation
Future<void> _performBackgroundSync(Map<String, dynamic>? inputData) async {
  try {
    debugPrint('Performing background sync...');
    
    // Note: In a real implementation, you would:
    // 1. Initialize necessary services (DI container)
    // 2. Get the SyncManager instance
    // 3. Call syncPendingData()
    // 4. Handle any errors appropriately
    
    // For now, we'll just log that the sync would happen
    debugPrint('Background sync would be performed here');
    
    // Simulate sync operation
    await Future.delayed(const Duration(seconds: 2));
    
    debugPrint('Background sync completed');
  } catch (e) {
    debugPrint('Background sync error: $e');
    rethrow;
  }
}