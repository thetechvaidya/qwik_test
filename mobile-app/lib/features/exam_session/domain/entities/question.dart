import 'package:equatable/equatable.dart';
import 'option.dart';

/// Question type enumeration
enum QuestionType {
  multipleChoice,
  trueFalse,
  singleChoice;

  String get displayName {
    switch (this) {
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.singleChoice:
        return 'Single Choice';
    }
  }
}

/// Question difficulty enumeration
enum QuestionDifficulty {
  easy,
  medium,
  hard;

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
}

/// Question entity for exam sessions
class Question extends Equatable {
  final String id;
  final QuestionType type;
  final String questionText;
  final List<Option> options;
  final int? timeLimit; // in seconds
  final String? explanation;
  final QuestionDifficulty difficulty;
  final double marks;
  final String? imageUrl;
  final String? audioUrl;
  final String? videoUrl;
  final Map<String, dynamic>? metadata;
  final int order;
  final bool isRequired;

  const Question({
    required this.id,
    required this.type,
    required this.questionText,
    required this.options,
    this.timeLimit,
    this.explanation,
    this.difficulty = QuestionDifficulty.medium,
    this.marks = 1.0,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
    this.metadata,
    required this.order,
    this.isRequired = true,
  });

  /// Check if question is multiple choice
  bool get isMultipleChoice => type == QuestionType.multipleChoice;

  /// Check if question is true/false
  bool get isTrueFalse => type == QuestionType.trueFalse;

  /// Check if question is single choice
  bool get isSingleChoice => type == QuestionType.singleChoice;

  /// Check if question has time limit
  bool get hasTimeLimit => timeLimit != null && timeLimit! > 0;

  /// Get correct options
  List<Option> getCorrectOptions() {
    return options.where((option) => option.isCorrect).toList();
  }

  /// Get option by id
  Option? getOptionById(String optionId) {
    try {
      return options.firstWhere((option) => option.id == optionId);
    } catch (e) {
      return null;
    }
  }

  /// Get sorted options by order
  List<Option> get sortedOptions {
    final sortedList = List<Option>.from(options);
    sortedList.sort((a, b) => a.order.compareTo(b.order));
    return sortedList;
  }

  /// Check if question has media content
  bool get hasMedia => imageUrl != null || audioUrl != null || videoUrl != null;

  /// Get formatted time limit
  String? get formattedTimeLimit {
    if (!hasTimeLimit) return null;
    
    final minutes = timeLimit! ~/ 60;
    final seconds = timeLimit! % 60;
    
    if (minutes > 0) {
      return seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes}m';
    }
    return '${seconds}s';
  }

  /// Validate answer selection
  bool isValidAnswerSelection(List<String> selectedOptionIds) {
    if (selectedOptionIds.isEmpty && isRequired) return false;
    
    switch (type) {
      case QuestionType.singleChoice:
      case QuestionType.trueFalse:
        return selectedOptionIds.length <= 1;
      case QuestionType.multipleChoice:
        return selectedOptionIds.isNotEmpty;
    }
  }

  /// Create copy with updated values
  Question copyWith({
    String? id,
    QuestionType? type,
    String? questionText,
    List<Option>? options,
    int? timeLimit,
    String? explanation,
    QuestionDifficulty? difficulty,
    double? marks,
    String? imageUrl,
    String? audioUrl,
    String? videoUrl,
    Map<String, dynamic>? metadata,
    int? order,
    bool? isRequired,
  }) {
    return Question(
      id: id ?? this.id,
      type: type ?? this.type,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      timeLimit: timeLimit ?? this.timeLimit,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
      marks: marks ?? this.marks,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      metadata: metadata ?? this.metadata,
      order: order ?? this.order,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        questionText,
        options,
        timeLimit,
        explanation,
        difficulty,
        marks,
        imageUrl,
        audioUrl,
        videoUrl,
        metadata,
        order,
        isRequired,
      ];

  @override
  String toString() {
    return 'Question(id: $id, type: $type, questionText: $questionText, options: ${options.length})';
  }
}