import 'package:equatable/equatable.dart';

/// Answer entity for user responses to questions
class Answer extends Equatable {
  final String questionId;
  final List<String> selectedOptionIds;
  final int timeSpent; // in seconds
  final DateTime answeredAt;
  final bool? isCorrect; // for local validation
  final double? score; // actual score received
  final bool isSkipped;
  final bool isMarkedForReview;
  final Map<String, dynamic>? metadata;

  const Answer({
    required this.questionId,
    required this.selectedOptionIds,
    this.timeSpent = 0,
    required this.answeredAt,
    this.isCorrect,
    this.score,
    this.isSkipped = false,
    this.isMarkedForReview = false,
    this.metadata,
  });

  /// Check if answer is provided (not empty or skipped)
  bool get isAnswered => selectedOptionIds.isNotEmpty && !isSkipped;

  /// Check if multiple options are selected
  bool get isMultipleSelection => selectedOptionIds.length > 1;

  /// Get first selected option ID (for single selection questions)
  String? get firstSelectedOptionId {
    return selectedOptionIds.isNotEmpty ? selectedOptionIds.first : null;
  }

  /// Get formatted time spent
  String get formattedTimeSpent {
    final minutes = timeSpent ~/ 60;
    final seconds = timeSpent % 60;
    
    if (minutes > 0) {
      return seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes}m';
    }
    return '${seconds}s';
  }

  /// Check if answer contains specific option
  bool containsOption(String optionId) {
    return selectedOptionIds.contains(optionId);
  }

  /// Create answer for skipped question
  factory Answer.skipped({
    required String questionId,
    int timeSpent = 0,
    DateTime? answeredAt,
  }) {
    return Answer(
      questionId: questionId,
      selectedOptionIds: const [],
      timeSpent: timeSpent,
      answeredAt: answeredAt ?? DateTime.now(),
      isSkipped: true,
    );
  }

  /// Create answer for marked for review
  factory Answer.markedForReview({
    required String questionId,
    required List<String> selectedOptionIds,
    int timeSpent = 0,
    DateTime? answeredAt,
  }) {
    return Answer(
      questionId: questionId,
      selectedOptionIds: selectedOptionIds,
      timeSpent: timeSpent,
      answeredAt: answeredAt ?? DateTime.now(),
      isMarkedForReview: true,
    );
  }

  /// Create copy with updated values
  Answer copyWith({
    String? questionId,
    List<String>? selectedOptionIds,
    int? timeSpent,
    DateTime? answeredAt,
    bool? isCorrect,
    double? score,
    bool? isSkipped,
    bool? isMarkedForReview,
    Map<String, dynamic>? metadata,
  }) {
    return Answer(
      questionId: questionId ?? this.questionId,
      selectedOptionIds: selectedOptionIds ?? this.selectedOptionIds,
      timeSpent: timeSpent ?? this.timeSpent,
      answeredAt: answeredAt ?? this.answeredAt,
      isCorrect: isCorrect ?? this.isCorrect,
      score: score ?? this.score,
      isSkipped: isSkipped ?? this.isSkipped,
      isMarkedForReview: isMarkedForReview ?? this.isMarkedForReview,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        questionId,
        selectedOptionIds,
        timeSpent,
        answeredAt,
        isCorrect,
        score,
        isSkipped,
        isMarkedForReview,
        metadata,
      ];

  @override
  String toString() {
    return 'Answer(questionId: $questionId, selectedOptions: $selectedOptionIds, timeSpent: ${timeSpent}s, isAnswered: $isAnswered)';
  }
}