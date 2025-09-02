import 'package:equatable/equatable.dart';

/// Entity for tracking synchronization status of offline data
class SyncStatus extends Equatable {
  final String sessionId;
  final SyncStatusType status;
  final DateTime? lastSyncAttempt;
  final int retryCount;
  final String? errorMessage;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? serverSessionId; // ID assigned by server after successful sync
  final Map<String, dynamic>? metadata;

  const SyncStatus({
    required this.sessionId,
    required this.status,
    this.lastSyncAttempt,
    this.retryCount = 0,
    this.errorMessage,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
    this.serverSessionId,
    this.metadata,
  });

  /// Check if sync can be retried
  bool canRetry() {
    if (status == SyncStatusType.completed) return false;
    if (status == SyncStatusType.conflict) return false;
    
    // Allow retry up to 5 times with exponential backoff
    if (retryCount >= 5) return false;
    
    // Check if enough time has passed since last attempt
    if (lastSyncAttempt != null) {
      final timeSinceLastAttempt = DateTime.now().difference(lastSyncAttempt!);
      final minWaitTime = Duration(minutes: _getRetryDelayMinutes());
      return timeSinceLastAttempt.compareTo(minWaitTime) >= 0;
    }
    
    return true;
  }

  /// Check if sync is in conflict state
  bool get isConflicted => status == SyncStatusType.conflict;

  /// Check if sync needs resolution
  bool get needsResolution => status == SyncStatusType.conflict;

  /// Check if sync is completed
  bool get isCompleted => status == SyncStatusType.completed;

  /// Check if sync is pending
  bool get isPending => status == SyncStatusType.pending;

  /// Check if sync is in progress
  bool get isSyncing => status == SyncStatusType.syncing;

  /// Check if sync has failed
  bool get hasFailed => status == SyncStatusType.failed;

  /// Get next retry time
  DateTime? getNextRetryTime() {
    if (!canRetry() || lastSyncAttempt == null) return null;
    
    final delayMinutes = _getRetryDelayMinutes();
    return lastSyncAttempt!.add(Duration(minutes: delayMinutes));
  }

  /// Get retry delay in minutes using exponential backoff
  int _getRetryDelayMinutes() {
    // Exponential backoff: 1, 2, 4, 8, 16 minutes
    return (1 << retryCount).clamp(1, 16);
  }

  /// Get formatted retry delay
  String? getFormattedRetryDelay() {
    final nextRetry = getNextRetryTime();
    if (nextRetry == null) return null;
    
    final now = DateTime.now();
    if (now.isAfter(nextRetry)) return 'Ready to retry';
    
    final difference = nextRetry.difference(now);
    if (difference.inHours > 0) {
      return 'Retry in ${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return 'Retry in ${difference.inMinutes}m';
    }
  }

  /// Get status display name
  String get statusDisplayName => status.displayName;

  /// Get status color
  String get statusColor => status.color;

  /// Create a copy with updated properties
  SyncStatus copyWith({
    String? sessionId,
    SyncStatusType? status,
    DateTime? lastSyncAttempt,
    int? retryCount,
    String? errorMessage,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? serverSessionId,
    Map<String, dynamic>? metadata,
  }) {
    return SyncStatus(
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      conflictData: conflictData ?? this.conflictData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSessionId: serverSessionId ?? this.serverSessionId,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create a new sync status with incremented retry count
  SyncStatus withRetry({
    String? errorMessage,
    SyncStatusType? newStatus,
  }) {
    return copyWith(
      status: newStatus ?? SyncStatusType.pending,
      retryCount: retryCount + 1,
      lastSyncAttempt: DateTime.now(),
      errorMessage: errorMessage,
      updatedAt: DateTime.now(),
    );
  }

  /// Create a completed sync status
  SyncStatus asCompleted(String serverSessionId) {
    return copyWith(
      status: SyncStatusType.completed,
      serverSessionId: serverSessionId,
      errorMessage: null,
      conflictData: null,
      updatedAt: DateTime.now(),
    );
  }

  /// Create a conflicted sync status
  SyncStatus asConflicted(Map<String, dynamic> conflictData) {
    return copyWith(
      status: SyncStatusType.conflict,
      conflictData: conflictData,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        status,
        lastSyncAttempt,
        retryCount,
        errorMessage,
        conflictData,
        createdAt,
        updatedAt,
        serverSessionId,
        metadata,
      ];
}

/// Enumeration for sync status types
enum SyncStatusType {
  pending,
  syncing,
  completed,
  failed,
  conflict;

  String get displayName {
    switch (this) {
      case SyncStatusType.pending:
        return 'Pending';
      case SyncStatusType.syncing:
        return 'Syncing';
      case SyncStatusType.completed:
        return 'Completed';
      case SyncStatusType.failed:
        return 'Failed';
      case SyncStatusType.conflict:
        return 'Conflict';
    }
  }

  String get color {
    switch (this) {
      case SyncStatusType.pending:
        return '#FF9800'; // Orange
      case SyncStatusType.syncing:
        return '#2196F3'; // Blue
      case SyncStatusType.completed:
        return '#4CAF50'; // Green
      case SyncStatusType.failed:
        return '#F44336'; // Red
      case SyncStatusType.conflict:
        return '#9C27B0'; // Purple
    }
  }

  String get icon {
    switch (this) {
      case SyncStatusType.pending:
        return '⏳';
      case SyncStatusType.syncing:
        return '🔄';
      case SyncStatusType.completed:
        return '✅';
      case SyncStatusType.failed:
        return '❌';
      case SyncStatusType.conflict:
        return '⚠️';
    }
  }
}