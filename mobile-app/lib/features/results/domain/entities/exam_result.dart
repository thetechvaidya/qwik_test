import 'package:equatable/equatable.dart';
import 'question_result.dart';

/// Entity representing the result of a completed exam
class ExamResult extends Equatable {
  final String id;
  final String examId;
  final String examTitle;
  final String userId;
  final List<QuestionResult> questionResults;
  final double totalScore;
  final double maxScore;
  final Duration timeSpent;
  final Duration? timeLimit;
  final DateTime startedAt;
  final DateTime completedAt;
  final ExamStatus status;
  final String category;
  final String? subcategory;
  final Map<String, dynamic> metadata;
  final List<String> tags;
  final String? feedback;
  final ExamDifficulty difficulty;
  final bool isTimedOut;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int skippedQuestions;

  const ExamResult({
    required this.id,
    required this.examId,
    required this.examTitle,
    required this.userId,
    required this.questionResults,
    required this.totalScore,
    required this.maxScore,
    required this.timeSpent,
    this.timeLimit,
    required this.startedAt,
    required this.completedAt,
    required this.status,
    required this.category,
    this.subcategory,
    required this.metadata,
    required this.tags,
    this.feedback,
    required this.difficulty,
    required this.isTimedOut,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.skippedQuestions,
  });

  /// Calculate percentage score
  double getPercentageScore() {
    if (maxScore == 0) return 0.0;
    return (totalScore / maxScore * 100).clamp(0.0, 100.0);
  }

  /// Calculate accuracy percentage
  double getAccuracyPercentage() {
    if (totalQuestions == 0) return 0.0;
    return (correctAnswers / totalQuestions * 100).clamp(0.0, 100.0);
  }

  /// Get performance grade
  ExamGrade getGrade() {
    final percentage = getPercentageScore();
    if (percentage >= 90) return ExamGrade.aPlus;
    if (percentage >= 85) return ExamGrade.a;
    if (percentage >= 80) return ExamGrade.aMinus;
    if (percentage >= 75) return ExamGrade.bPlus;
    if (percentage >= 70) return ExamGrade.b;
    if (percentage >= 65) return ExamGrade.bMinus;
    if (percentage >= 60) return ExamGrade.cPlus;
    if (percentage >= 55) return ExamGrade.c;
    if (percentage >= 50) return ExamGrade.cMinus;
    return ExamGrade.f;
  }

  /// Get performance rating
  PerformanceRating getPerformanceRating() {
    final percentage = getPercentageScore();
    if (percentage >= 90) return PerformanceRating.excellent;
    if (percentage >= 80) return PerformanceRating.good;
    if (percentage >= 70) return PerformanceRating.average;
    if (percentage >= 60) return PerformanceRating.belowAverage;
    return PerformanceRating.poor;
  }

  /// Calculate average time per question
  Duration getAverageTimePerQuestion() {
    if (totalQuestions == 0) return Duration.zero;
    return Duration(milliseconds: timeSpent.inMilliseconds ~/ totalQuestions);
  }

  /// Get formatted time spent
  String getFormattedTimeSpent() {
    final hours = timeSpent.inHours;
    final minutes = timeSpent.inMinutes % 60;
    final seconds = timeSpent.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Get formatted average time per question
  String getFormattedAverageTimePerQuestion() {
    final avgTime = getAverageTimePerQuestion();
    final minutes = avgTime.inMinutes;
    final seconds = avgTime.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Check if exam was completed within time limit
  bool isCompletedOnTime() {
    return timeLimit == null || timeSpent <= timeLimit!;
  }

  /// Get time efficiency percentage
  double getTimeEfficiency() {
    if (timeLimit == null) return 100.0;
    if (timeLimit!.inMilliseconds == 0) return 100.0;
    
    final efficiency = (timeLimit!.inMilliseconds - timeSpent.inMilliseconds) / 
                      timeLimit!.inMilliseconds * 100;
    return efficiency.clamp(0.0, 100.0);
  }

  /// Get questions by result type
  List<QuestionResult> getQuestionsByType(QuestionResultType type) {
    return questionResults.where((q) => q.resultType == type).toList();
  }

  /// Get incorrect questions for review
  List<QuestionResult> getIncorrectQuestions() {
    return getQuestionsByType(QuestionResultType.incorrect);
  }

  /// Get skipped questions for review
  List<QuestionResult> getSkippedQuestions() {
    return getQuestionsByType(QuestionResultType.skipped);
  }

  /// Get questions that need review
  List<QuestionResult> getQuestionsForReview() {
    return questionResults.where((q) => 
      q.resultType == QuestionResultType.incorrect || 
      q.resultType == QuestionResultType.skipped ||
      (q.resultType == QuestionResultType.correct && q.timeSpent > Duration(seconds: 120))
    ).toList();
  }

  /// Get performance insights
  List<String> getPerformanceInsights() {
    final insights = <String>[];
    
    // Score insights
    final percentage = getPercentageScore();
    if (percentage >= 95) {
      insights.add('Outstanding performance! You\'ve mastered this topic.');
    } else if (percentage >= 85) {
      insights.add('Excellent work! You have a strong understanding.');
    } else if (percentage < 70) {
      insights.add('Consider reviewing the topics you missed.');
    }
    
    // Time insights
    if (isTimedOut) {
      insights.add('Time management could be improved. Practice with time limits.');
    } else if (getTimeEfficiency() > 50) {
      insights.add('Great time management! You completed the exam efficiently.');
    }
    
    // Accuracy insights
    final accuracy = getAccuracyPercentage();
    if (accuracy >= 95) {
      insights.add('Exceptional accuracy! Your preparation paid off.');
    } else if (accuracy < 75) {
      insights.add('Focus on accuracy. Review concepts before attempting questions.');
    }
    
    // Question-specific insights
    if (skippedQuestions > totalQuestions * 0.2) {
      insights.add('You skipped many questions. Consider reviewing unfamiliar topics.');
    }
    
    final reviewQuestions = getQuestionsForReview();
    if (reviewQuestions.isNotEmpty) {
      insights.add('${reviewQuestions.length} questions need review for better understanding.');
    }
    
    return insights;
  }

  /// Get study recommendations
  List<String> getStudyRecommendations() {
    final recommendations = <String>[];
    
    // Based on incorrect answers
    final incorrectQuestions = getIncorrectQuestions();
    if (incorrectQuestions.isNotEmpty) {
      final topics = incorrectQuestions
          .map((q) => q.topic)
          .where((topic) => topic != null)
          .toSet()
          .toList();
      
      if (topics.isNotEmpty) {
        recommendations.add('Review these topics: ${topics.join(", ")}');
      }
    }
    
    // Based on time spent
    final slowQuestions = questionResults
        .where((q) => q.timeSpent > Duration(seconds: 120))
        .toList();
    
    if (slowQuestions.isNotEmpty) {
      recommendations.add('Practice speed on similar question types.');
    }
    
    // Based on difficulty
    if (difficulty == ExamDifficulty.hard && getPercentageScore() < 70) {
      recommendations.add('Start with easier exams to build confidence.');
    }
    
    // Based on category performance
    if (getPercentageScore() < 80) {
      recommendations.add('Take more practice exams in $category.');
    }
    
    return recommendations;
  }

  /// Check if this is a perfect score
  bool isPerfectScore() {
    return getPercentageScore() >= 100.0;
  }

  /// Check if this is a passing score (assuming 60% is passing)
  bool isPassingScore({double passingPercentage = 60.0}) {
    return getPercentageScore() >= passingPercentage;
  }

  /// Get completion status message
  String getCompletionStatusMessage() {
    switch (status) {
      case ExamStatus.completed:
        if (isPerfectScore()) {
          return 'Perfect Score! Outstanding performance!';
        } else if (isPassingScore()) {
          return 'Exam completed successfully!';
        } else {
          return 'Exam completed. Keep practicing to improve!';
        }
      case ExamStatus.abandoned:
        return 'Exam was not completed. Try again when ready.';
      case ExamStatus.timedOut:
        return 'Time limit exceeded. Practice time management.';
      case ExamStatus.inProgress:
        return 'Exam is still in progress.';
    }
  }

  /// Calculate points earned (for gamification)
  int calculatePointsEarned() {
    int basePoints = (getPercentageScore() * 10).round();
    
    // Bonus for perfect score
    if (isPerfectScore()) {
      basePoints += 200;
    }
    
    // Bonus for time efficiency
    if (getTimeEfficiency() > 75) {
      basePoints += 100;
    }
    
    // Bonus for difficulty
    switch (difficulty) {
      case ExamDifficulty.easy:
        basePoints = (basePoints * 1.0).round();
        break;
      case ExamDifficulty.medium:
        basePoints = (basePoints * 1.2).round();
        break;
      case ExamDifficulty.hard:
        basePoints = (basePoints * 1.5).round();
        break;
    }
    
    return basePoints.clamp(0, 2000);
  }

  @override
  List<Object?> get props => [
        id,
        examId,
        examTitle,
        userId,
        questionResults,
        totalScore,
        maxScore,
        timeSpent,
        timeLimit,
        startedAt,
        completedAt,
        status,
        category,
        subcategory,
        metadata,
        tags,
        feedback,
        difficulty,
        isTimedOut,
        totalQuestions,
        correctAnswers,
        incorrectAnswers,
        skippedQuestions,
      ];

  @override
  String toString() {
    return 'ExamResult(id: $id, examTitle: $examTitle, score: ${getPercentageScore().toStringAsFixed(1)}%)';
  }
}

/// Enum for exam status
enum ExamStatus {
  inProgress,
  completed,
  abandoned,
  timedOut,
}

/// Enum for exam difficulty
enum ExamDifficulty {
  easy,
  medium,
  hard,
}

/// Enum for exam grades
enum ExamGrade {
  aPlus,
  a,
  aMinus,
  bPlus,
  b,
  bMinus,
  cPlus,
  c,
  cMinus,
  f,
}

/// Enum for performance rating (reused from dashboard)
enum PerformanceRating {
  excellent,
  good,
  average,
  belowAverage,
  poor,
}

/// Extensions for enums
extension ExamStatusExtension on ExamStatus {
  String get displayName {
    switch (this) {
      case ExamStatus.inProgress:
        return 'In Progress';
      case ExamStatus.completed:
        return 'Completed';
      case ExamStatus.abandoned:
        return 'Abandoned';
      case ExamStatus.timedOut:
        return 'Timed Out';
    }
  }

  String get icon {
    switch (this) {
      case ExamStatus.inProgress:
        return '⏳';
      case ExamStatus.completed:
        return '✅';
      case ExamStatus.abandoned:
        return '❌';
      case ExamStatus.timedOut:
        return '⏰';
    }
  }
}

extension ExamDifficultyExtension on ExamDifficulty {
  String get displayName {
    switch (this) {
      case ExamDifficulty.easy:
        return 'Easy';
      case ExamDifficulty.medium:
        return 'Medium';
      case ExamDifficulty.hard:
        return 'Hard';
    }
  }

  String get color {
    switch (this) {
      case ExamDifficulty.easy:
        return '#4CAF50'; // Green
      case ExamDifficulty.medium:
        return '#FF9800'; // Orange
      case ExamDifficulty.hard:
        return '#F44336'; // Red
    }
  }
}

extension ExamGradeExtension on ExamGrade {
  String get displayName {
    switch (this) {
      case ExamGrade.aPlus:
        return 'A+';
      case ExamGrade.a:
        return 'A';
      case ExamGrade.aMinus:
        return 'A-';
      case ExamGrade.bPlus:
        return 'B+';
      case ExamGrade.b:
        return 'B';
      case ExamGrade.bMinus:
        return 'B-';
      case ExamGrade.cPlus:
        return 'C+';
      case ExamGrade.c:
        return 'C';
      case ExamGrade.cMinus:
        return 'C-';
      case ExamGrade.f:
        return 'F';
    }
  }

  String get color {
    switch (this) {
      case ExamGrade.aPlus:
      case ExamGrade.a:
        return '#4CAF50'; // Green
      case ExamGrade.aMinus:
      case ExamGrade.bPlus:
        return '#8BC34A'; // Light Green
      case ExamGrade.b:
      case ExamGrade.bMinus:
        return '#FF9800'; // Orange
      case ExamGrade.cPlus:
      case ExamGrade.c:
        return '#FF5722'; // Deep Orange
      case ExamGrade.cMinus:
      case ExamGrade.f:
        return '#F44336'; // Red
    }
  }
}