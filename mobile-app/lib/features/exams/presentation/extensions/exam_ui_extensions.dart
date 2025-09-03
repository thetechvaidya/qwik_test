import 'package:flutter/material.dart';
import '../../domain/entities/exam.dart';

extension ExamDifficultyUIExtension on ExamDifficulty {
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
}

extension ExamTypeUIExtension on ExamType {
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

extension ExamStatusUIExtension on ExamStatus {
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

extension ExamUIExtension on Exam {
  Color get difficultyColor => difficulty.color;
  
  Color get statusColor => status.color;
}