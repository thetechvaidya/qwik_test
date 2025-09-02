import 'package:equatable/equatable.dart';
import '../../../exam_session/domain/entities/answer.dart';

/// Represents an offline exam session ready for upload to the server
class OfflineSessionUpload extends Equatable {
  const OfflineSessionUpload({
    required this.sessionId,
    required this.examId,
    required this.userId,
    required this.answers,
    required this.startTime,
    required this.endTime,
    required this.deviceInfo,
    this.metadata = const {},
    this.uploadProgress = 0.0,
    this.lastUploadAttempt,
    this.uploadError,
  });

  final String sessionId;
  final String examId;
  final String userId;
  final List<Answer> answers;
  final DateTime startTime;
  final DateTime endTime;
  final DeviceInfo deviceInfo;
  final Map<String, dynamic> metadata;
  final double uploadProgress;
  final DateTime? lastUploadAttempt;
  final String? uploadError;

  /// Duration of the exam session
  Duration get duration => endTime.difference(startTime);

  /// Whether the session is ready for upload
  bool get isReadyForUpload {
    return answers.isNotEmpty && 
           startTime.isBefore(endTime) &&
           uploadProgress < 1.0 &&
           _isValidSession();
  }

  /// Whether the upload is in progress
  bool get isUploading => uploadProgress > 0.0 && uploadProgress < 1.0;

  /// Whether the upload is completed
  bool get isUploaded => uploadProgress >= 1.0;

  /// Whether the upload has failed
  bool get hasUploadError => uploadError != null;

  /// Number of answered questions
  int get answeredCount => answers.where((a) => a.isAnswered).length;

  /// Number of skipped questions
  int get skippedCount => answers.where((a) => !a.isAnswered).length;

  /// Number of reviewed questions
  int get reviewedCount => answers.where((a) => a.isReviewed).length;

  /// Formatted duration string
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Formatted upload progress percentage
  String get formattedProgress => '${(uploadProgress * 100).toStringAsFixed(1)}%';

  /// Validates the session data
  bool _isValidSession() {
    return sessionId.isNotEmpty &&
           examId.isNotEmpty &&
           userId.isNotEmpty &&
           startTime.isBefore(DateTime.now()) &&
           endTime.isAfter(startTime);
  }

  /// Creates a copy with updated fields
  OfflineSessionUpload copyWith({
    String? sessionId,
    String? examId,
    String? userId,
    List<Answer>? answers,
    DateTime? startTime,
    DateTime? endTime,
    DeviceInfo? deviceInfo,
    Map<String, dynamic>? metadata,
    double? uploadProgress,
    DateTime? lastUploadAttempt,
    String? uploadError,
  }) {
    return OfflineSessionUpload(
      sessionId: sessionId ?? this.sessionId,
      examId: examId ?? this.examId,
      userId: userId ?? this.userId,
      answers: answers ?? this.answers,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      metadata: metadata ?? this.metadata,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      lastUploadAttempt: lastUploadAttempt ?? this.lastUploadAttempt,
      uploadError: uploadError ?? this.uploadError,
    );
  }

  /// Creates a copy with upload progress updated
  OfflineSessionUpload withProgress(double progress) {
    return copyWith(
      uploadProgress: progress.clamp(0.0, 1.0),
      lastUploadAttempt: DateTime.now(),
    );
  }

  /// Creates a copy with upload error
  OfflineSessionUpload withError(String error) {
    return copyWith(
      uploadError: error,
      lastUploadAttempt: DateTime.now(),
    );
  }

  /// Creates a copy marking upload as completed
  OfflineSessionUpload markAsUploaded() {
    return copyWith(
      uploadProgress: 1.0,
      uploadError: null,
      lastUploadAttempt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        examId,
        userId,
        answers,
        startTime,
        endTime,
        deviceInfo,
        metadata,
        uploadProgress,
        lastUploadAttempt,
        uploadError,
      ];
}

/// Device information for upload context
class DeviceInfo extends Equatable {
  const DeviceInfo({
    required this.platform,
    required this.version,
    required this.model,
    this.appVersion,
    this.networkType,
    this.batteryLevel,
  });

  final String platform; // iOS, Android, etc.
  final String version;  // OS version
  final String model;    // Device model
  final String? appVersion;
  final String? networkType; // WiFi, Mobile, etc.
  final double? batteryLevel;

  @override
  List<Object?> get props => [
        platform,
        version,
        model,
        appVersion,
        networkType,
        batteryLevel,
      ];
}