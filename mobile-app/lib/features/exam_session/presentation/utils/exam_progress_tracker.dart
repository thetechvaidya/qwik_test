import '../../domain/entities/answer.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/exam_session.dart';

/// Utility class for tracking exam session progress and statistics
class ExamProgressTracker {
  final ExamSession _session;
  final List<Answer> _answers;

  ExamProgressTracker({
    required ExamSession session,
    required List<Answer> answers,
  })
      : _session = session,
        _answers = answers;

  /// Get total number of questions
  int get totalQuestions => _session.questions.length;

  /// Get number of answered questions (excluding skipped)
  int get answeredCount {
    return _answers.where((answer) => !answer.isSkipped).length;
  }

  /// Get number of skipped questions
  int get skippedCount {
    return _answers.where((answer) => answer.isSkipped).length;
  }

  /// Get number of questions marked for review
  int get markedForReviewCount {
    return _answers.where((answer) => answer.isMarkedForReview).length;
  }

  /// Get number of unanswered questions
  int get unansweredCount {
    final answeredQuestionIds = _answers.map((answer) => answer.questionId).toSet();
    return _session.questions
        .where((question) => !answeredQuestionIds.contains(question.id))
        .length;
  }

  /// Get number of correct answers
  int get correctAnswersCount {
    return _answers.where((answer) => answer.isCorrect && !answer.isSkipped).length;
  }

  /// Get number of incorrect answers
  int get incorrectAnswersCount {
    return _answers.where((answer) => !answer.isCorrect && !answer.isSkipped).length;
  }

  /// Get overall progress percentage (0.0 to 100.0)
  double get overallProgress {
    if (totalQuestions == 0) return 0.0;
    return (answeredCount / totalQuestions) * 100;
  }

  /// Get accuracy percentage (0.0 to 100.0)
  double get accuracyPercentage {
    if (answeredCount == 0) return 0.0;
    return (correctAnswersCount / answeredCount) * 100;
  }

  /// Get total score achieved
  int get totalScore {
    return _answers.fold<int>(0, (sum, answer) => sum + answer.score);
  }

  /// Get maximum possible score
  int get maxPossibleScore {
    return _session.questions.fold<int>(0, (sum, question) => sum + question.marks);
  }

  /// Get score percentage (0.0 to 100.0)
  double get scorePercentage {
    if (maxPossibleScore == 0) return 0.0;
    return (totalScore / maxPossibleScore) * 100;
  }

  /// Get total time spent in seconds
  int get totalTimeSpent {
    return _answers.fold<int>(0, (sum, answer) => sum + answer.timeSpent);
  }

  /// Get average time per question in seconds
  double get averageTimePerQuestion {
    if (answeredCount == 0) return 0.0;
    return totalTimeSpent / answeredCount;
  }

  /// Get time spent on current question in seconds
  int get currentQuestionTimeSpent {
    final currentQuestion = _session.questions[_session.currentQuestionIndex];
    final answer = _answers.firstWhere(
      (answer) => answer.questionId == currentQuestion.id,
      orElse: () => Answer(
        questionId: currentQuestion.id,
        selectedOptionIds: [],
        timeSpent: 0,
        answeredAt: DateTime.now(),
        isCorrect: false,
        score: 0,
      ),
    );
    return answer.timeSpent;
  }

  /// Check if exam is ready to submit
  bool get isReadyToSubmit {
    return answeredCount > 0 || _session.isTimeExpired;
  }

  /// Check if all questions are answered
  bool get isAllQuestionsAnswered {
    return answeredCount == totalQuestions;
  }

  /// Check if exam is passing based on passing score
  bool get isPassing {
    if (_session.exam?.passingScore == null) return false;
    return scorePercentage >= _session.exam!.passingScore;
  }

  /// Get questions by status
  List<Question> getQuestionsByStatus(QuestionStatus status) {
    switch (status) {
      case QuestionStatus.answered:
        final answeredIds = _answers
            .where((answer) => !answer.isSkipped)
            .map((answer) => answer.questionId)
            .toSet();
        return _session.questions
            .where((question) => answeredIds.contains(question.id))
            .toList();
      
      case QuestionStatus.skipped:
        final skippedIds = _answers
            .where((answer) => answer.isSkipped)
            .map((answer) => answer.questionId)
            .toSet();
        return _session.questions
            .where((question) => skippedIds.contains(question.id))
            .toList();
      
      case QuestionStatus.markedForReview:
        final markedIds = _answers
            .where((answer) => answer.isMarkedForReview)
            .map((answer) => answer.questionId)
            .toSet();
        return _session.questions
            .where((question) => markedIds.contains(question.id))
            .toList();
      
      case QuestionStatus.unanswered:
        final answeredIds = _answers.map((answer) => answer.questionId).toSet();
        return _session.questions
            .where((question) => !answeredIds.contains(question.id))
            .toList();
      
      case QuestionStatus.correct:
        final correctIds = _answers
            .where((answer) => answer.isCorrect && !answer.isSkipped)
            .map((answer) => answer.questionId)
            .toSet();
        return _session.questions
            .where((question) => correctIds.contains(question.id))
            .toList();
      
      case QuestionStatus.incorrect:
        final incorrectIds = _answers
            .where((answer) => !answer.isCorrect && !answer.isSkipped)
            .map((answer) => answer.questionId)
            .toSet();
        return _session.questions
            .where((question) => incorrectIds.contains(question.id))
            .toList();
    }
  }

  /// Get question status for a specific question
  QuestionStatus getQuestionStatus(String questionId) {
    final answer = _answers.firstWhere(
      (answer) => answer.questionId == questionId,
      orElse: () => Answer(
        questionId: questionId,
        selectedOptionIds: [],
        timeSpent: 0,
        answeredAt: DateTime.now(),
        isCorrect: false,
        score: 0,
      ),
    );

    if (_answers.any((a) => a.questionId == questionId)) {
      if (answer.isSkipped) return QuestionStatus.skipped;
      if (answer.isMarkedForReview) return QuestionStatus.markedForReview;
      if (answer.isCorrect) return QuestionStatus.correct;
      return QuestionStatus.incorrect;
    }
    
    return QuestionStatus.unanswered;
  }

  /// Get progress summary
  ProgressSummary get progressSummary {
    return ProgressSummary(
      totalQuestions: totalQuestions,
      answeredCount: answeredCount,
      skippedCount: skippedCount,
      markedForReviewCount: markedForReviewCount,
      unansweredCount: unansweredCount,
      correctAnswersCount: correctAnswersCount,
      incorrectAnswersCount: incorrectAnswersCount,
      overallProgress: overallProgress,
      accuracyPercentage: accuracyPercentage,
      totalScore: totalScore,
      maxPossibleScore: maxPossibleScore,
      scorePercentage: scorePercentage,
      totalTimeSpent: totalTimeSpent,
      averageTimePerQuestion: averageTimePerQuestion,
      isReadyToSubmit: isReadyToSubmit,
      isAllQuestionsAnswered: isAllQuestionsAnswered,
      isPassing: isPassing,
    );
  }

  /// Get time analysis
  TimeAnalysis get timeAnalysis {
    final questionTimes = _answers.map((answer) => answer.timeSpent).toList();
    questionTimes.sort();
    
    final fastestTime = questionTimes.isNotEmpty ? questionTimes.first : 0;
    final slowestTime = questionTimes.isNotEmpty ? questionTimes.last : 0;
    final medianTime = questionTimes.isNotEmpty 
        ? questionTimes[questionTimes.length ~/ 2] 
        : 0;
    
    return TimeAnalysis(
      totalTimeSpent: totalTimeSpent,
      averageTimePerQuestion: averageTimePerQuestion,
      fastestQuestionTime: fastestTime,
      slowestQuestionTime: slowestTime,
      medianQuestionTime: medianTime,
      currentQuestionTimeSpent: currentQuestionTimeSpent,
    );
  }
}

/// Enum for question status
enum QuestionStatus {
  answered,
  skipped,
  markedForReview,
  unanswered,
  correct,
  incorrect,
}

/// Extension for QuestionStatus
extension QuestionStatusExtension on QuestionStatus {
  String get displayName {
    switch (this) {
      case QuestionStatus.answered:
        return 'Answered';
      case QuestionStatus.skipped:
        return 'Skipped';
      case QuestionStatus.markedForReview:
        return 'Marked for Review';
      case QuestionStatus.unanswered:
        return 'Unanswered';
      case QuestionStatus.correct:
        return 'Correct';
      case QuestionStatus.incorrect:
        return 'Incorrect';
    }
  }

  String get iconName {
    switch (this) {
      case QuestionStatus.answered:
        return 'check_circle';
      case QuestionStatus.skipped:
        return 'skip_next';
      case QuestionStatus.markedForReview:
        return 'flag';
      case QuestionStatus.unanswered:
        return 'radio_button_unchecked';
      case QuestionStatus.correct:
        return 'check_circle';
      case QuestionStatus.incorrect:
        return 'cancel';
    }
  }
}

/// Data class for progress summary
class ProgressSummary {
  final int totalQuestions;
  final int answeredCount;
  final int skippedCount;
  final int markedForReviewCount;
  final int unansweredCount;
  final int correctAnswersCount;
  final int incorrectAnswersCount;
  final double overallProgress;
  final double accuracyPercentage;
  final int totalScore;
  final int maxPossibleScore;
  final double scorePercentage;
  final int totalTimeSpent;
  final double averageTimePerQuestion;
  final bool isReadyToSubmit;
  final bool isAllQuestionsAnswered;
  final bool isPassing;

  const ProgressSummary({
    required this.totalQuestions,
    required this.answeredCount,
    required this.skippedCount,
    required this.markedForReviewCount,
    required this.unansweredCount,
    required this.correctAnswersCount,
    required this.incorrectAnswersCount,
    required this.overallProgress,
    required this.accuracyPercentage,
    required this.totalScore,
    required this.maxPossibleScore,
    required this.scorePercentage,
    required this.totalTimeSpent,
    required this.averageTimePerQuestion,
    required this.isReadyToSubmit,
    required this.isAllQuestionsAnswered,
    required this.isPassing,
  });
}

/// Data class for time analysis
class TimeAnalysis {
  final int totalTimeSpent;
  final double averageTimePerQuestion;
  final int fastestQuestionTime;
  final int slowestQuestionTime;
  final int medianQuestionTime;
  final int currentQuestionTimeSpent;

  const TimeAnalysis({
    required this.totalTimeSpent,
    required this.averageTimePerQuestion,
    required this.fastestQuestionTime,
    required this.slowestQuestionTime,
    required this.medianQuestionTime,
    required this.currentQuestionTimeSpent,
  });

  /// Get formatted total time spent
  String get formattedTotalTime {
    final hours = totalTimeSpent ~/ 3600;
    final minutes = (totalTimeSpent % 3600) ~/ 60;
    final seconds = totalTimeSpent % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Get formatted average time per question
  String get formattedAverageTime {
    final avgSeconds = averageTimePerQuestion.round();
    final minutes = avgSeconds ~/ 60;
    final seconds = avgSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}