import 'package:equatable/equatable.dart';
import '../../../exams/domain/entities/exam.dart';
import '../../../exam_session/domain/entities/question.dart';

/// Entity representing an exam downloaded for offline use
class OfflineExam extends Equatable {
  final String examId;
  final Exam exam;
  final List<Question> questions;
  final DateTime downloadedAt;
  final DateTime? expiresAt;
  final int fileSize; // in bytes
  final String version; // for tracking updates
  final Map<String, dynamic>? metadata;

  const OfflineExam({
    required this.examId,
    required this.exam,
    required this.questions,
    required this.downloadedAt,
    this.expiresAt,
    required this.fileSize,
    required this.version,
    this.metadata,
  });

  /// Check if the offline exam is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Get days until expiry
  int? get daysUntilExpiry {
    if (expiresAt == null) return null;
    final now = DateTime.now();
    if (now.isAfter(expiresAt!)) return 0;
    return expiresAt!.difference(now).inDays;
  }

  /// Get storage size in MB
  double get storageSizeMB {
    return fileSize / (1024 * 1024);
  }

  /// Get formatted storage size
  String get formattedStorageSize {
    final sizeMB = storageSizeMB;
    if (sizeMB < 1) {
      final sizeKB = fileSize / 1024;
      return '${sizeKB.toStringAsFixed(1)} KB';
    } else if (sizeMB < 1024) {
      return '${sizeMB.toStringAsFixed(1)} MB';
    } else {
      final sizeGB = sizeMB / 1024;
      return '${sizeGB.toStringAsFixed(1)} GB';
    }
  }

  /// Get formatted download date
  String get formattedDownloadDate {
    final now = DateTime.now();
    final difference = now.difference(downloadedAt);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${downloadedAt.day}/${downloadedAt.month}/${downloadedAt.year}';
    }
  }

  /// Check if exam needs update (based on version)
  bool needsUpdate(String latestVersion) {
    return version != latestVersion;
  }

  /// Get expiry status
  OfflineExamExpiryStatus get expiryStatus {
    if (expiresAt == null) return OfflineExamExpiryStatus.noExpiry;
    
    final now = DateTime.now();
    if (now.isAfter(expiresAt!)) return OfflineExamExpiryStatus.expired;
    
    final daysLeft = expiresAt!.difference(now).inDays;
    if (daysLeft <= 1) return OfflineExamExpiryStatus.expiringSoon;
    if (daysLeft <= 7) return OfflineExamExpiryStatus.expiringThisWeek;
    
    return OfflineExamExpiryStatus.valid;
  }

  /// Create a copy with updated properties
  OfflineExam copyWith({
    String? examId,
    Exam? exam,
    List<Question>? questions,
    DateTime? downloadedAt,
    DateTime? expiresAt,
    int? fileSize,
    String? version,
    Map<String, dynamic>? metadata,
  }) {
    return OfflineExam(
      examId: examId ?? this.examId,
      exam: exam ?? this.exam,
      questions: questions ?? this.questions,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      fileSize: fileSize ?? this.fileSize,
      version: version ?? this.version,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        examId,
        exam,
        questions,
        downloadedAt,
        expiresAt,
        fileSize,
        version,
        metadata,
      ];
}

/// Enumeration for offline exam expiry status
enum OfflineExamExpiryStatus {
  noExpiry,
  valid,
  expiringThisWeek,
  expiringSoon,
  expired;

  String get displayName {
    switch (this) {
      case OfflineExamExpiryStatus.noExpiry:
        return 'No Expiry';
      case OfflineExamExpiryStatus.valid:
        return 'Valid';
      case OfflineExamExpiryStatus.expiringThisWeek:
        return 'Expiring This Week';
      case OfflineExamExpiryStatus.expiringSoon:
        return 'Expiring Soon';
      case OfflineExamExpiryStatus.expired:
        return 'Expired';
    }
  }

  String get color {
    switch (this) {
      case OfflineExamExpiryStatus.noExpiry:
      case OfflineExamExpiryStatus.valid:
        return '#4CAF50'; // Green
      case OfflineExamExpiryStatus.expiringThisWeek:
        return '#FF9800'; // Orange
      case OfflineExamExpiryStatus.expiringSoon:
      case OfflineExamExpiryStatus.expired:
        return '#F44336'; // Red
    }
  }
}