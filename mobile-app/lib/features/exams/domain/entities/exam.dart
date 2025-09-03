import 'package:flutter/foundation.dart';

enum ExamDifficulty { beginner, intermediate, advanced, expert }

enum ExamType { practice, mock, certification, assessment }

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
}

class Exam {
  final String id;
  final String title;
  final String? description;
  final ExamDifficulty difficulty;
  final Duration? duration;
  final int questionCount;
  final String? categoryName;
  final bool isFavorite;
  final bool isActive;
  final ExamStats stats;
  final ExamType examType;
  final ExamUserProgress? userProgress;
  final double? passingScore;

  Exam({
    required this.id,
    required this.title,
    this.description,
    required this.difficulty,
    this.duration,
    required this.questionCount,
    this.categoryName,
    this.isFavorite = false,
    this.isActive = true,
    required this.stats,
    required this.examType,
    this.userProgress,
    this.passingScore,
  });
}

class ExamStats {
  final double averageRating;
  final int completionRate;
  final int enrolledCount;

  ExamStats({
    required this.averageRating,
    required this.completionRate,
    required this.enrolledCount,
  });
}

class ExamUserProgress {
  final String userId;
  final String examId;
  final double completionPercentage;
  final DateTime? lastAttemptAt;
  final bool isStarted;
  final bool isCompleted;

  ExamUserProgress({
    required this.userId,
    required this.examId,
    required this.completionPercentage,
    this.lastAttemptAt,
    required this.isStarted,
    required this.isCompleted,
  });
}