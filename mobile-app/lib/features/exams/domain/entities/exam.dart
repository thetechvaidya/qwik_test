import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ExamDifficulty { beginner, intermediate, advanced, expert }

enum ExamType { practice, mock, assessment, live }

enum ExamStatus { draft, published, archived, suspended }

extension ExamDifficultyExtension on ExamDifficulty {
  String get displayName {
    switch (this) {
      case ExamDifficulty.beginner:
        return 'Beginner';
      case ExamDifficulty.intermediate:
        return 'Intermediate';
      case ExamDifficulty.advanced:
        return 'Advanced';
      case ExamDifficulty.expert:
        return 'Expert';
    }
  }

  Color get color {
    switch (this) {
      case ExamDifficulty.beginner:
        return Colors.green;
      case ExamDifficulty.intermediate:
        return Colors.blue;
      case ExamDifficulty.advanced:
        return Colors.orange;
      case ExamDifficulty.expert:
        return Colors.red;
    }
  }

  String get description {
    switch (this) {
      case ExamDifficulty.beginner:
        return 'Perfect for beginners starting their journey';
      case ExamDifficulty.intermediate:
        return 'Build upon your foundational knowledge';
      case ExamDifficulty.advanced:
        return 'Challenge yourself with complex topics';
      case ExamDifficulty.expert:
        return 'Master-level content for experts';
    }
  }
}

extension ExamTypeExtension on ExamType {
  String get displayName {
    switch (this) {
      case ExamType.practice:
        return 'Practice';
      case ExamType.mock:
        return 'Mock Exam';
      case ExamType.live:
        return 'Live';
      case ExamType.assessment:
        return 'Assessment';
    }
  }

  IconData get icon {
    switch (this) {
      case ExamType.practice:
        return Icons.school;
      case ExamType.mock:
        return Icons.assessment;
      case ExamType.live:
        return Icons.live_tv;
      case ExamType.assessment:
        return Icons.quiz;
    }
  }
}

extension ExamStatusExtension on ExamStatus {
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

  Color get color {
    switch (this) {
      case ExamStatus.draft:
        return Colors.grey;
      case ExamStatus.published:
        return Colors.green;
      case ExamStatus.archived:
        return Colors.orange;
      case ExamStatus.suspended:
        return Colors.red;
    }
  }
}

class Exam {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final Duration? duration;
  final int totalQuestions;
  final int totalMarks;
  final double passingScore;
  final ExamDifficulty difficulty;
  final ExamType examType;
  final String categoryId;
  final String categoryName;
  final String? subcategory;
  final List<String> tags;
  final List<String> requirements;
  final List<String> topics;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? scheduledAt;
  final DateTime? expiresAt;
  final bool isActive;
  final bool isPaid;
  final double? price;
  final String? currency;
  final ExamStatus status;
  final bool isFavorite;
  final ExamStats stats;
  final ExamUserProgress? userProgress;

  Exam({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.duration,
    required this.totalQuestions,
    required this.totalMarks,
    required this.passingScore,
    required this.difficulty,
    required this.examType,
    required this.categoryId,
    required this.categoryName,
    this.subcategory,
    this.tags = const [],
    this.requirements = const [],
    this.topics = const [],
    required this.createdAt,
    required this.updatedAt,
    this.scheduledAt,
    this.expiresAt,
    this.isActive = true,
    this.isPaid = false,
    this.price,
    this.currency,
    required this.status,
    this.isFavorite = false,
    required this.stats,
    this.userProgress,
  });

  String get formattedDuration {
    if (duration == null) return 'No time limit';
    final hours = duration!.inHours;
    final minutes = duration!.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Color get difficultyColor => difficulty.color;

  Color get statusColor => status.color;

  Exam copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    Duration? duration,
    int? totalQuestions,
    int? totalMarks,
    double? passingScore,
    ExamDifficulty? difficulty,
    ExamType? examType,
    String? categoryId,
    String? categoryName,
    String? subcategory,
    List<String>? tags,
    List<String>? requirements,
    List<String>? topics,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? scheduledAt,
    DateTime? expiresAt,
    bool? isActive,
    bool? isPaid,
    double? price,
    String? currency,
    ExamStatus? status,
    bool? isFavorite,
    ExamStats? stats,
    ExamUserProgress? userProgress,
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
      examType: examType ?? this.examType,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subcategory: subcategory ?? this.subcategory,
      tags: tags ?? this.tags,
      requirements: requirements ?? this.requirements,
      topics: topics ?? this.topics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      isPaid: isPaid ?? this.isPaid,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      stats: stats ?? this.stats,
      userProgress: userProgress ?? this.userProgress,
    );
  }
}

class ExamStats {
  final double averageRating;
  final int completionRate;
  final int enrolledCount;
  final int totalAttempts;
  final double averageScore;
  final double highestScore;
  final double lowestScore;
  final int passCount;
  final int failCount;
  final double passRate;
  final Duration averageCompletionTime;

  ExamStats({
    required this.averageRating,
    required this.completionRate,
    required this.enrolledCount,
    this.totalAttempts = 0,
    this.averageScore = 0.0,
    this.highestScore = 0.0,
    this.lowestScore = 0.0,
    this.passCount = 0,
    this.failCount = 0,
    this.passRate = 0.0,
    this.averageCompletionTime = Duration.zero,
  });
}

class ExamUserProgress {
  final String userId;
  final String examId;
  final double completionPercentage;
  final DateTime? lastAttemptAt;
  final bool isStarted;
  final bool isCompleted;
  final int answeredQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final Duration timeSpent;
  final double? score;

  ExamUserProgress({
    required this.userId,
    required this.examId,
    required this.completionPercentage,
    this.lastAttemptAt,
    this.isStarted = false,
    this.isCompleted = false,
    this.answeredQuestions = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.timeSpent = Duration.zero,
    this.score,
  });

  double get accuracy {
    if (answeredQuestions == 0) return 0.0;
    return (correctAnswers / answeredQuestions) * 100;
  }

  int remainingQuestions(int totalQuestions) {
    return totalQuestions - answeredQuestions;
  }

  String get formattedTimeSpent {
    final hours = timeSpent.inHours;
    final minutes = timeSpent.inMinutes.remainder(60);
    final seconds = timeSpent.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  ExamUserProgress copyWith({
    String? userId,
    String? examId,
    double? completionPercentage,
    DateTime? lastAttemptAt,
    bool? isStarted,
    bool? isCompleted,
    int? answeredQuestions,
    int? correctAnswers,
    int? incorrectAnswers,
    Duration? timeSpent,
    double? score,
  }) {
    return ExamUserProgress(
      userId: userId ?? this.userId,
      examId: examId ?? this.examId,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      isStarted: isStarted ?? this.isStarted,
      isCompleted: isCompleted ?? this.isCompleted,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      timeSpent: timeSpent ?? this.timeSpent,
      score: score ?? this.score,
    );
  }
}