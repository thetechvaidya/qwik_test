import 'package:equatable/equatable.dart';

/// Entity representing the result of a single question within an exam
class QuestionResult extends Equatable {
  final String id;
  final String questionId;
  final String examResultId;
  final String questionText;
  final QuestionType questionType;
  final List<String> options;
  final List<String> correctAnswers;
  final List<String> userAnswers;
  final QuestionResultType resultType;
  final double pointsEarned;
  final double maxPoints;
  final Duration timeSpent;
  final DateTime answeredAt;
  final String? explanation;
  final String? topic;
  final String? subtopic;
  final QuestionDifficulty difficulty;
  final Map<String, dynamic> metadata;
  final bool isMarkedForReview;
  final String? userNote;
  final List<String> tags;

  const QuestionResult({
    required this.id,
    required this.questionId,
    required this.examResultId,
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.correctAnswers,
    required this.userAnswers,
    required this.resultType,
    required this.pointsEarned,
    required this.maxPoints,
    required this.timeSpent,
    required this.answeredAt,
    this.explanation,
    this.topic,
    this.subtopic,
    required this.difficulty,
    required this.metadata,
    required this.isMarkedForReview,
    this.userNote,
    required this.tags,
  });

  /// Check if the question was answered correctly
  bool isCorrect() {
    return resultType == QuestionResultType.correct;
  }

  /// Check if the question was skipped
  bool isSkipped() {
    return resultType == QuestionResultType.skipped;
  }

  /// Check if the question was answered incorrectly
  bool isIncorrect() {
    return resultType == QuestionResultType.incorrect;
  }

  /// Calculate percentage score for this question
  double getPercentageScore() {
    if (maxPoints == 0) return 0.0;
    return (pointsEarned / maxPoints * 100).clamp(0.0, 100.0);
  }

  /// Get formatted time spent on this question
  String getFormattedTimeSpent() {
    final minutes = timeSpent.inMinutes;
    final seconds = timeSpent.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Check if question took too long (over 2 minutes)
  bool isTooSlow() {
    return timeSpent > const Duration(minutes: 2);
  }

  /// Check if question was answered quickly (under 30 seconds)
  bool isQuickAnswer() {
    return timeSpent < const Duration(seconds: 30);
  }

  /// Get difficulty-based time expectation
  Duration getExpectedTime() {
    switch (difficulty) {
      case QuestionDifficulty.easy:
        return const Duration(seconds: 45);
      case QuestionDifficulty.medium:
        return const Duration(seconds: 90);
      case QuestionDifficulty.hard:
        return const Duration(seconds: 150);
    }
  }

  /// Check if answered within expected time
  bool isAnsweredWithinExpectedTime() {
    return timeSpent <= getExpectedTime();
  }

  /// Get time efficiency percentage
  double getTimeEfficiency() {
    final expectedTime = getExpectedTime();
    if (expectedTime.inMilliseconds == 0) return 100.0;
    
    final efficiency = (expectedTime.inMilliseconds - timeSpent.inMilliseconds) / 
                      expectedTime.inMilliseconds * 100;
    return efficiency.clamp(0.0, 100.0);
  }

  /// Get user answer as formatted string
  String getFormattedUserAnswer() {
    if (userAnswers.isEmpty) {
      return 'No answer provided';
    }
    
    switch (questionType) {
      case QuestionType.multipleChoice:
      case QuestionType.trueFalse:
        return userAnswers.first;
      case QuestionType.multipleSelect:
        return userAnswers.join(', ');
      case QuestionType.fillInTheBlank:
      case QuestionType.shortAnswer:
        return userAnswers.join(' ');
      case QuestionType.essay:
        return userAnswers.first;
    }
  }

  /// Get correct answer as formatted string
  String getFormattedCorrectAnswer() {
    if (correctAnswers.isEmpty) {
      return 'No correct answer available';
    }
    
    switch (questionType) {
      case QuestionType.multipleChoice:
      case QuestionType.trueFalse:
        return correctAnswers.first;
      case QuestionType.multipleSelect:
        return correctAnswers.join(', ');
      case QuestionType.fillInTheBlank:
      case QuestionType.shortAnswer:
        return correctAnswers.join(' or ');
      case QuestionType.essay:
        return 'See explanation for sample answer';
    }
  }

  /// Get question analysis
  QuestionAnalysis getAnalysis() {
    return QuestionAnalysis(
      isCorrect: isCorrect(),
      timeEfficiency: getTimeEfficiency(),
      difficultyMatch: _assessDifficultyMatch(),
      needsReview: _needsReview(),
      strengths: _getStrengths(),
      improvements: _getImprovements(),
    );
  }

  /// Assess if difficulty matches performance
  bool _assessDifficultyMatch() {
    if (difficulty == QuestionDifficulty.easy && isCorrect() && isQuickAnswer()) {
      return true;
    }
    if (difficulty == QuestionDifficulty.hard && isCorrect()) {
      return true;
    }
    if (difficulty == QuestionDifficulty.medium && isCorrect() && isAnsweredWithinExpectedTime()) {
      return true;
    }
    return false;
  }

  /// Check if question needs review
  bool _needsReview() {
    return isIncorrect() || 
           isSkipped() || 
           isMarkedForReview ||
           (isCorrect() && isTooSlow()) ||
           (difficulty == QuestionDifficulty.easy && !isCorrect());
  }

  /// Get strengths for this question
  List<String> _getStrengths() {
    final strengths = <String>[];
    
    if (isCorrect()) {
      strengths.add('Correct answer');
    }
    
    if (isQuickAnswer() && isCorrect()) {
      strengths.add('Quick and accurate');
    }
    
    if (difficulty == QuestionDifficulty.hard && isCorrect()) {
      strengths.add('Handled difficult question well');
    }
    
    if (getTimeEfficiency() > 75) {
      strengths.add('Efficient time management');
    }
    
    return strengths;
  }

  /// Get areas for improvement
  List<String> _getImprovements() {
    final improvements = <String>[];
    
    if (isIncorrect()) {
      improvements.add('Review concept: ${topic ?? "this topic"}');
    }
    
    if (isSkipped()) {
      improvements.add('Study ${topic ?? "this topic"} to build confidence');
    }
    
    if (isTooSlow()) {
      improvements.add('Practice for faster completion');
    }
    
    if (difficulty == QuestionDifficulty.easy && !isCorrect()) {
      improvements.add('Focus on fundamental concepts');
    }
    
    return improvements;
  }

  /// Get performance insights for this question
  List<String> getPerformanceInsights() {
    final insights = <String>[];
    
    if (isCorrect() && isQuickAnswer()) {
      insights.add('Excellent! Quick and accurate response.');
    } else if (isCorrect() && isTooSlow()) {
      insights.add('Correct but slow. Practice similar questions for speed.');
    } else if (isIncorrect() && isQuickAnswer()) {
      insights.add('Too hasty. Take time to read questions carefully.');
    } else if (isIncorrect() && isTooSlow()) {
      insights.add('Struggled with this concept. Review and practice more.');
    }
    
    if (difficulty == QuestionDifficulty.hard && isCorrect()) {
      insights.add('Great job tackling a challenging question!');
    }
    
    return insights;
  }

  /// Check if this question contributed to learning
  bool isLearningOpportunity() {
    return isIncorrect() || isSkipped() || (isCorrect() && isTooSlow());
  }

  /// Get study recommendation for this question
  String? getStudyRecommendation() {
    if (isCorrect() && !isTooSlow()) {
      return null; // No recommendation needed
    }
    
    if (isSkipped()) {
      return 'Study ${topic ?? "this topic"} basics and attempt similar questions';
    }
    
    if (isIncorrect()) {
      return 'Review ${topic ?? "this concept"} and understand why the correct answer is ${getFormattedCorrectAnswer()}';
    }
    
    if (isTooSlow()) {
      return 'Practice ${topic ?? "similar questions"} to improve speed and confidence';
    }
    
    return 'Continue practicing to maintain proficiency';
  }

  @override
  List<Object?> get props => [
        id,
        questionId,
        examResultId,
        questionText,
        questionType,
        options,
        correctAnswers,
        userAnswers,
        resultType,
        pointsEarned,
        maxPoints,
        timeSpent,
        answeredAt,
        explanation,
        topic,
        subtopic,
        difficulty,
        metadata,
        isMarkedForReview,
        userNote,
        tags,
      ];

  @override
  String toString() {
    return 'QuestionResult(id: $id, type: $resultType, score: ${getPercentageScore().toStringAsFixed(1)}%)';
  }
}

/// Analysis data for a question result
class QuestionAnalysis extends Equatable {
  final bool isCorrect;
  final double timeEfficiency;
  final bool difficultyMatch;
  final bool needsReview;
  final List<String> strengths;
  final List<String> improvements;

  const QuestionAnalysis({
    required this.isCorrect,
    required this.timeEfficiency,
    required this.difficultyMatch,
    required this.needsReview,
    required this.strengths,
    required this.improvements,
  });

  @override
  List<Object?> get props => [
        isCorrect,
        timeEfficiency,
        difficultyMatch,
        needsReview,
        strengths,
        improvements,
      ];
}

/// Enum for question types
enum QuestionType {
  multipleChoice,
  multipleSelect,
  trueFalse,
  fillInTheBlank,
  shortAnswer,
  essay,
}

/// Enum for question result types
enum QuestionResultType {
  correct,
  incorrect,
  skipped,
  partiallyCorrect,
}

/// Enum for question difficulty
enum QuestionDifficulty {
  easy,
  medium,
  hard,
}

/// Extensions for enums
extension QuestionTypeExtension on QuestionType {
  String get displayName {
    switch (this) {
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.multipleSelect:
        return 'Multiple Select';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.fillInTheBlank:
        return 'Fill in the Blank';
      case QuestionType.shortAnswer:
        return 'Short Answer';
      case QuestionType.essay:
        return 'Essay';
    }
  }

  String get icon {
    switch (this) {
      case QuestionType.multipleChoice:
        return '🔘';
      case QuestionType.multipleSelect:
        return '☑️';
      case QuestionType.trueFalse:
        return '✅';
      case QuestionType.fillInTheBlank:
        return '📝';
      case QuestionType.shortAnswer:
        return '✏️';
      case QuestionType.essay:
        return '📄';
    }
  }
}

extension QuestionResultTypeExtension on QuestionResultType {
  String get displayName {
    switch (this) {
      case QuestionResultType.correct:
        return 'Correct';
      case QuestionResultType.incorrect:
        return 'Incorrect';
      case QuestionResultType.skipped:
        return 'Skipped';
      case QuestionResultType.partiallyCorrect:
        return 'Partially Correct';
    }
  }

  String get icon {
    switch (this) {
      case QuestionResultType.correct:
        return '✅';
      case QuestionResultType.incorrect:
        return '❌';
      case QuestionResultType.skipped:
        return '⏭️';
      case QuestionResultType.partiallyCorrect:
        return '🟡';
    }
  }

  String get color {
    switch (this) {
      case QuestionResultType.correct:
        return '#4CAF50'; // Green
      case QuestionResultType.incorrect:
        return '#F44336'; // Red
      case QuestionResultType.skipped:
        return '#9E9E9E'; // Grey
      case QuestionResultType.partiallyCorrect:
        return '#FF9800'; // Orange
    }
  }
}

extension QuestionDifficultyExtension on QuestionDifficulty {
  String get displayName {
    switch (this) {
      case QuestionDifficulty.easy:
        return 'Easy';
      case QuestionDifficulty.medium:
        return 'Medium';
      case QuestionDifficulty.hard:
        return 'Hard';
    }
  }

  String get color {
    switch (this) {
      case QuestionDifficulty.easy:
        return '#4CAF50'; // Green
      case QuestionDifficulty.medium:
        return '#FF9800'; // Orange
      case QuestionDifficulty.hard:
        return '#F44336'; // Red
    }
  }

  int get expectedTimeSeconds {
    switch (this) {
      case QuestionDifficulty.easy:
        return 45;
      case QuestionDifficulty.medium:
        return 90;
      case QuestionDifficulty.hard:
        return 150;
    }
  }
}