import 'package:equatable/equatable.dart';

/// Core exam entity for the domain layer
class Exam extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final int duration; // in minutes
  final int totalQuestions;
  final int totalMarks;
  final double passingScore;
  final String difficulty; // 'easy', 'medium', 'hard'
  final String category;
  final String? subcategory;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? scheduledAt;
  final DateTime? expiresAt;
  final bool isActive;
  final bool isPaid;
  final double? price;
  final String? currency;
  final ExamStatus status;
  final ExamType type;
  final ExamSettings settings;
  final ExamStats? stats;
  final UserExamProgress? userProgress;

  const Exam({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.duration,
    required this.totalQuestions,
    required this.totalMarks,
    required this.passingScore,
    required this.difficulty,
    required this.category,
    this.subcategory,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.scheduledAt,
    this.expiresAt,
    this.isActive = true,
    this.isPaid = false,
    this.price,
    this.currency,
    this.status = ExamStatus.draft,
    this.type = ExamType.practice,
    required this.settings,
    this.stats,
    this.userProgress,
  });

  /// Check if exam is available for taking
  bool get isAvailable {
    if (!isActive) return false;
    if (status != ExamStatus.published) return false;
    
    final now = DateTime.now();
    if (scheduledAt != null && now.isBefore(scheduledAt!)) return false;
    if (expiresAt != null && now.isAfter(expiresAt!)) return false;
    
    return true;
  }

  /// Check if exam is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if exam is scheduled for future
  bool get isScheduled {
    if (scheduledAt == null) return false;
    return DateTime.now().isBefore(scheduledAt!);
  }

  /// Check if user has completed this exam
  bool get isCompleted {
    return userProgress?.isCompleted ?? false;
  }

  /// Check if user has started this exam
  bool get isStarted {
    return userProgress?.isStarted ?? false;
  }

  /// Get user's best score percentage
  double? get bestScorePercentage {
    return userProgress?.bestScorePercentage;
  }

  /// Get formatted duration string
  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    
    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    return '${minutes}m';
  }

  /// Get difficulty color
  String get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return '#4CAF50'; // Green
      case 'medium':
        return '#FF9800'; // Orange
      case 'hard':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  /// Create copy with updated values
  Exam copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? duration,
    int? totalQuestions,
    int? totalMarks,
    double? passingScore,
    String? difficulty,
    String? category,
    String? subcategory,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? scheduledAt,
    DateTime? expiresAt,
    bool? isActive,
    bool? isPaid,
    double? price,
    String? currency,
    ExamStatus? status,
    ExamType? type,
    ExamSettings? settings,
    ExamStats? stats,
    UserExamProgress? userProgress,
  }) {
    return Exam(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      totalMarks: totalMarks ?? this.totalMarks,
      passingScore: passingScore ?? this.passingScore,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      isPaid: isPaid ?? this.isPaid,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      type: type ?? this.type,
      settings: settings ?? this.settings,
      stats: stats ?? this.stats,
      userProgress: userProgress ?? this.userProgress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        duration,
        totalQuestions,
        totalMarks,
        passingScore,
        difficulty,
        category,
        subcategory,
        tags,
        createdAt,
        updatedAt,
        scheduledAt,
        expiresAt,
        isActive,
        isPaid,
        price,
        currency,
        status,
        type,
        settings,
        stats,
        userProgress,
      ];
}

/// Exam status enumeration
enum ExamStatus {
  draft,
  published,
  archived,
  suspended;

  String get displayName {
    switch (this) {
      case ExamStatus.draft:
        return 'Draft';
      case ExamStatus.published:
        return 'Published';
      case ExamStatus.archived:
        return 'Archived';
      case ExamStatus.suspended:
        return 'Suspended';
    }
  }
}

/// Exam type enumeration
enum ExamType {
  practice,
  mock,
  live,
  assessment;

  String get displayName {
    switch (this) {
      case ExamType.practice:
        return 'Practice';
      case ExamType.mock:
        return 'Mock Test';
      case ExamType.live:
        return 'Live Exam';
      case ExamType.assessment:
        return 'Assessment';
    }
  }
}

/// Exam settings configuration
class ExamSettings extends Equatable {
  final bool allowReview;
  final bool showResults;
  final bool shuffleQuestions;
  final bool shuffleOptions;
  final bool allowBackNavigation;
  final bool showTimer;
  final bool autoSubmit;
  final int? maxAttempts;
  final bool requireCamera;
  final bool requireMicrophone;
  final bool preventCopyPaste;
  final bool fullScreenMode;
  final List<String> allowedDevices;

  const ExamSettings({
    this.allowReview = true,
    this.showResults = true,
    this.shuffleQuestions = false,
    this.shuffleOptions = false,
    this.allowBackNavigation = true,
    this.showTimer = true,
    this.autoSubmit = true,
    this.maxAttempts,
    this.requireCamera = false,
    this.requireMicrophone = false,
    this.preventCopyPaste = false,
    this.fullScreenMode = false,
    this.allowedDevices = const [],
  });

  ExamSettings copyWith({
    bool? allowReview,
    bool? showResults,
    bool? shuffleQuestions,
    bool? shuffleOptions,
    bool? allowBackNavigation,
    bool? showTimer,
    bool? autoSubmit,
    int? maxAttempts,
    bool? requireCamera,
    bool? requireMicrophone,
    bool? preventCopyPaste,
    bool? fullScreenMode,
    List<String>? allowedDevices,
  }) {
    return ExamSettings(
      allowReview: allowReview ?? this.allowReview,
      showResults: showResults ?? this.showResults,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      shuffleOptions: shuffleOptions ?? this.shuffleOptions,
      allowBackNavigation: allowBackNavigation ?? this.allowBackNavigation,
      showTimer: showTimer ?? this.showTimer,
      autoSubmit: autoSubmit ?? this.autoSubmit,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      requireCamera: requireCamera ?? this.requireCamera,
      requireMicrophone: requireMicrophone ?? this.requireMicrophone,
      preventCopyPaste: preventCopyPaste ?? this.preventCopyPaste,
      fullScreenMode: fullScreenMode ?? this.fullScreenMode,
      allowedDevices: allowedDevices ?? this.allowedDevices,
    );
  }

  @override
  List<Object?> get props => [
        allowReview,
        showResults,
        shuffleQuestions,
        shuffleOptions,
        allowBackNavigation,
        showTimer,
        autoSubmit,
        maxAttempts,
        requireCamera,
        requireMicrophone,
        preventCopyPaste,
        fullScreenMode,
        allowedDevices,
      ];
}

/// Exam statistics
class ExamStats extends Equatable {
  final int totalAttempts;
  final double averageScore;
  final double highestScore;
  final double lowestScore;
  final int passCount;
  final int failCount;
  final double passRate;
  final Duration averageCompletionTime;

  const ExamStats({
    required this.totalAttempts,
    required this.averageScore,
    required this.highestScore,
    required this.lowestScore,
    required this.passCount,
    required this.failCount,
    required this.passRate,
    required this.averageCompletionTime,
  });

  @override
  List<Object?> get props => [
        totalAttempts,
        averageScore,
        highestScore,
        lowestScore,
        passCount,
        failCount,
        passRate,
        averageCompletionTime,
      ];
}

/// User's progress on an exam
class UserExamProgress extends Equatable {
  final String examId;
  final String userId;
  final int attemptCount;
  final double? bestScore;
  final double? bestScorePercentage;
  final double? lastScore;
  final double? lastScorePercentage;
  final DateTime? lastAttemptAt;
  final DateTime? firstAttemptAt;
  final bool isStarted;
  final bool isCompleted;
  final bool isPassed;
  final Duration? bestCompletionTime;
  final Duration? lastCompletionTime;

  const UserExamProgress({
    required this.examId,
    required this.userId,
    this.attemptCount = 0,
    this.bestScore,
    this.bestScorePercentage,
    this.lastScore,
    this.lastScorePercentage,
    this.lastAttemptAt,
    this.firstAttemptAt,
    this.isStarted = false,
    this.isCompleted = false,
    this.isPassed = false,
    this.bestCompletionTime,
    this.lastCompletionTime,
  });

  UserExamProgress copyWith({
    String? examId,
    String? userId,
    int? attemptCount,
    double? bestScore,
    double? bestScorePercentage,
    double? lastScore,
    double? lastScorePercentage,
    DateTime? lastAttemptAt,
    DateTime? firstAttemptAt,
    bool? isStarted,
    bool? isCompleted,
    bool? isPassed,
    Duration? bestCompletionTime,
    Duration? lastCompletionTime,
  }) {
    return UserExamProgress(
      examId: examId ?? this.examId,
      userId: userId ?? this.userId,
      attemptCount: attemptCount ?? this.attemptCount,
      bestScore: bestScore ?? this.bestScore,
      bestScorePercentage: bestScorePercentage ?? this.bestScorePercentage,
      lastScore: lastScore ?? this.lastScore,
      lastScorePercentage: lastScorePercentage ?? this.lastScorePercentage,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      firstAttemptAt: firstAttemptAt ?? this.firstAttemptAt,
      isStarted: isStarted ?? this.isStarted,
      isCompleted: isCompleted ?? this.isCompleted,
      isPassed: isPassed ?? this.isPassed,
      bestCompletionTime: bestCompletionTime ?? this.bestCompletionTime,
      lastCompletionTime: lastCompletionTime ?? this.lastCompletionTime,
    );
  }

  @override
  List<Object?> get props => [
        examId,
        userId,
        attemptCount,
        bestScore,
        bestScorePercentage,
        lastScore,
        lastScorePercentage,
        lastAttemptAt,
        firstAttemptAt,
        isStarted,
        isCompleted,
        isPassed,
        bestCompletionTime,
        lastCompletionTime,
      ];
}