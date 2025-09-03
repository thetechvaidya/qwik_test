import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ExamDifficulty { beginner, intermediate, advanced, expert }

enum ExamType { practice, mock, certification, assessment, live }

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
      case ExamType.certification:
        return 'Certification';
      case ExamType.assessment:
        return 'Assessment';
      case ExamType.live:
        return 'Live Exam';
    }
  }

  IconData get icon {
    switch (this) {
      case ExamType.practice:
        return Icons.school;
      case ExamType.mock:
        return Icons.assessment;
      case ExamType.certification:
        return Icons.workspace_premium;
      case ExamType.assessment:
        return Icons.quiz;
      case ExamType.live:
        return Icons.live_tv;
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