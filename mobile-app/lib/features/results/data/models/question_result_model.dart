import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/question_result.dart';

part 'question_result_model.g.dart';

@JsonSerializable()
class QuestionResultModel extends QuestionResult {
  const QuestionResultModel({
    required super.id,
    required super.questionId,
    required super.examResultId,
    required super.questionText,
    required super.questionType,
    required super.options,
    required super.correctAnswers,
    required super.userAnswers,
    required super.resultType,
    required super.pointsEarned,
    required super.maxPoints,
    required super.timeSpent,
    required super.answeredAt,
    super.explanation,
    super.topic,
    super.subtopic,
    super.difficulty,
    super.metadata,
    super.isMarkedForReview,
    super.userNote,
    super.tags,
  });

  factory QuestionResultModel.fromJson(Map<String, dynamic> json) {
    return QuestionResultModel(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      examResultId: json['examResultId'] as String,
      questionText: json['questionText'] as String,
      questionType: QuestionType.values.firstWhere(
        (e) => e.name == json['questionType'],
        orElse: () => QuestionType.multipleChoice,
      ),
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswers: (json['correctAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      userAnswers: (json['userAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      resultType: QuestionResultType.values.firstWhere(
        (e) => e.name == json['resultType'],
        orElse: () => QuestionResultType.incorrect,
      ),
      pointsEarned: (json['pointsEarned'] as num).toDouble(),
      maxPoints: (json['maxPoints'] as num).toDouble(),
      timeSpent: Duration(
        milliseconds: json['timeSpentMs'] as int,
      ),
      answeredAt: DateTime.parse(json['answeredAt'] as String),
      explanation: json['explanation'] as String?,
      topic: json['topic'] as String?,
      subtopic: json['subtopic'] as String?,
      difficulty: json['difficulty'] != null
          ? QuestionDifficulty.values.firstWhere(
              (e) => e.name == json['difficulty'],
              orElse: () => QuestionDifficulty.medium,
            )
          : null,
      metadata: Map<String, dynamic>.from(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
      isMarkedForReview: json['isMarkedForReview'] as bool? ?? false,
      userNote: json['userNote'] as String?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'examResultId': examResultId,
      'questionText': questionText,
      'questionType': questionType.name,
      'options': options,
      'correctAnswers': correctAnswers,
      'userAnswers': userAnswers,
      'resultType': resultType.name,
      'pointsEarned': pointsEarned,
      'maxPoints': maxPoints,
      'timeSpentMs': timeSpent.inMilliseconds,
      'answeredAt': answeredAt.toIso8601String(),
      'explanation': explanation,
      'topic': topic,
      'subtopic': subtopic,
      'difficulty': difficulty?.name,
      'metadata': metadata,
      'isMarkedForReview': isMarkedForReview,
      'userNote': userNote,
      'tags': tags,
    };
  }

  /// Create from entity
  factory QuestionResultModel.fromEntity(QuestionResult entity) {
    return QuestionResultModel(
      id: entity.id,
      questionId: entity.questionId,
      examResultId: entity.examResultId,
      questionText: entity.questionText,
      questionType: entity.questionType,
      options: entity.options,
      correctAnswers: entity.correctAnswers,
      userAnswers: entity.userAnswers,
      resultType: entity.resultType,
      pointsEarned: entity.pointsEarned,
      maxPoints: entity.maxPoints,
      timeSpent: entity.timeSpent,
      answeredAt: entity.answeredAt,
      explanation: entity.explanation,
      topic: entity.topic,
      subtopic: entity.subtopic,
      difficulty: entity.difficulty,
      metadata: entity.metadata,
      isMarkedForReview: entity.isMarkedForReview,
      userNote: entity.userNote,
      tags: entity.tags,
    );
  }

  /// Convert to entity
  QuestionResult toEntity() {
    return QuestionResult(
      id: id,
      questionId: questionId,
      examResultId: examResultId,
      questionText: questionText,
      questionType: questionType,
      options: options,
      correctAnswers: correctAnswers,
      userAnswers: userAnswers,
      resultType: resultType,
      pointsEarned: pointsEarned,
      maxPoints: maxPoints,
      timeSpent: timeSpent,
      answeredAt: answeredAt,
      explanation: explanation,
      topic: topic,
      subtopic: subtopic,
      difficulty: difficulty,
      metadata: metadata,
      isMarkedForReview: isMarkedForReview,
      userNote: userNote,
      tags: tags,
    );
  }

  /// Copy with new values
  QuestionResultModel copyWith({
    String? id,
    String? questionId,
    String? examResultId,
    String? questionText,
    QuestionType? questionType,
    List<String>? options,
    List<String>? correctAnswers,
    List<String>? userAnswers,
    QuestionResultType? resultType,
    double? pointsEarned,
    double? maxPoints,
    Duration? timeSpent,
    DateTime? answeredAt,
    String? explanation,
    String? topic,
    String? subtopic,
    QuestionDifficulty? difficulty,
    Map<String, dynamic>? metadata,
    bool? isMarkedForReview,
    String? userNote,
    List<String>? tags,
  }) {
    return QuestionResultModel(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      examResultId: examResultId ?? this.examResultId,
      questionText: questionText ?? this.questionText,
      questionType: questionType ?? this.questionType,
      options: options ?? this.options,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      userAnswers: userAnswers ?? this.userAnswers,
      resultType: resultType ?? this.resultType,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      maxPoints: maxPoints ?? this.maxPoints,
      timeSpent: timeSpent ?? this.timeSpent,
      answeredAt: answeredAt ?? this.answeredAt,
      explanation: explanation ?? this.explanation,
      topic: topic ?? this.topic,
      subtopic: subtopic ?? this.subtopic,
      difficulty: difficulty ?? this.difficulty,
      metadata: metadata ?? this.metadata,
      isMarkedForReview: isMarkedForReview ?? this.isMarkedForReview,
      userNote: userNote ?? this.userNote,
      tags: tags ?? this.tags,
    );
  }

  /// Create sample question results for testing
  static List<QuestionResultModel> getSampleResults() {
    final now = DateTime.now();
    return [
      QuestionResultModel(
        id: 'qr_1',
        questionId: 'q_math_001',
        examResultId: 'result_1',
        questionText: 'What is the derivative of x²?',
        questionType: QuestionType.multipleChoice,
        options: ['2x', 'x²', '2', 'x'],
        correctAnswers: ['2x'],
        userAnswers: ['2x'],
        resultType: QuestionResultType.correct,
        pointsEarned: 5.0,
        maxPoints: 5.0,
        timeSpent: const Duration(seconds: 30),
        answeredAt: now.subtract(const Duration(minutes: 45)),
        explanation: 'The derivative of x² is 2x using the power rule.',
        topic: 'Calculus',
        subtopic: 'Derivatives',
        difficulty: QuestionDifficulty.medium,
        metadata: {
          'attempts': 1,
          'hintUsed': false,
        },
        tags: ['calculus', 'derivatives', 'power-rule'],
      ),
      QuestionResultModel(
        id: 'qr_2',
        questionId: 'q_math_002',
        examResultId: 'result_1',
        questionText: 'Solve for x: 2x + 5 = 13',
        questionType: QuestionType.shortAnswer,
        options: [],
        correctAnswers: ['4'],
        userAnswers: ['3'],
        resultType: QuestionResultType.incorrect,
        pointsEarned: 0.0,
        maxPoints: 3.0,
        timeSpent: const Duration(seconds: 45),
        answeredAt: now.subtract(const Duration(minutes: 44)),
        explanation: 'Subtract 5 from both sides: 2x = 8, then divide by 2: x = 4',
        topic: 'Algebra',
        subtopic: 'Linear Equations',
        difficulty: QuestionDifficulty.easy,
        metadata: {
          'attempts': 1,
          'hintUsed': false,
        },
        isMarkedForReview: true,
        userNote: 'Need to review basic algebra',
        tags: ['algebra', 'linear-equations'],
      ),
      QuestionResultModel(
        id: 'qr_3',
        questionId: 'q_math_003',
        examResultId: 'result_1',
        questionText: 'Which of the following are prime numbers?',
        questionType: QuestionType.multipleSelect,
        options: ['2', '4', '7', '9', '11'],
        correctAnswers: ['2', '7', '11'],
        userAnswers: ['2', '7'],
        resultType: QuestionResultType.partiallyCorrect,
        pointsEarned: 2.0,
        maxPoints: 4.0,
        timeSpent: const Duration(seconds: 60),
        answeredAt: now.subtract(const Duration(minutes: 43)),
        explanation: 'Prime numbers are 2, 7, and 11. 4 and 9 are composite numbers.',
        topic: 'Number Theory',
        subtopic: 'Prime Numbers',
        difficulty: QuestionDifficulty.medium,
        metadata: {
          'attempts': 1,
          'hintUsed': true,
        },
        tags: ['number-theory', 'prime-numbers'],
      ),
      QuestionResultModel(
        id: 'qr_4',
        questionId: 'q_math_004',
        examResultId: 'result_1',
        questionText: 'Is the statement "All squares are rectangles" true or false?',
        questionType: QuestionType.trueFalse,
        options: ['True', 'False'],
        correctAnswers: ['True'],
        userAnswers: ['True'],
        resultType: QuestionResultType.correct,
        pointsEarned: 2.0,
        maxPoints: 2.0,
        timeSpent: const Duration(seconds: 15),
        answeredAt: now.subtract(const Duration(minutes: 42)),
        explanation: 'A square is a special type of rectangle where all sides are equal.',
        topic: 'Geometry',
        subtopic: 'Quadrilaterals',
        difficulty: QuestionDifficulty.easy,
        metadata: {
          'attempts': 1,
          'hintUsed': false,
        },
        tags: ['geometry', 'quadrilaterals'],
      ),
      QuestionResultModel(
        id: 'qr_5',
        questionId: 'q_math_005',
        examResultId: 'result_1',
        questionText: 'Calculate the area of a circle with radius 5 units.',
        questionType: QuestionType.shortAnswer,
        options: [],
        correctAnswers: ['25π', '78.54'],
        userAnswers: ['25π'],
        resultType: QuestionResultType.correct,
        pointsEarned: 4.0,
        maxPoints: 4.0,
        timeSpent: const Duration(seconds: 40),
        answeredAt: now.subtract(const Duration(minutes: 41)),
        explanation: 'Area = πr² = π × 5² = 25π ≈ 78.54 square units',
        topic: 'Geometry',
        subtopic: 'Circle Area',
        difficulty: QuestionDifficulty.medium,
        metadata: {
          'attempts': 1,
          'hintUsed': false,
          'formulaProvided': true,
        },
        tags: ['geometry', 'circles', 'area'],
      ),
    ];
  }

  /// Create question result with specific correctness
  factory QuestionResultModel.withCorrectness({
    required String questionId,
    required String examResultId,
    required bool isCorrect,
    QuestionType type = QuestionType.multipleChoice,
    QuestionDifficulty difficulty = QuestionDifficulty.medium,
    double maxPoints = 5.0,
  }) {
    final now = DateTime.now();
    final timeSpent = Duration(
      seconds: 20 + (difficulty.index * 15) + (type.index * 10),
    );

    String questionText;
    List<String> options;
    List<String> correctAnswers;
    List<String> userAnswers;
    String topic;
    String subtopic;

    switch (type) {
      case QuestionType.multipleChoice:
        questionText = 'Sample multiple choice question';
        options = ['Option A', 'Option B', 'Option C', 'Option D'];
        correctAnswers = ['Option A'];
        userAnswers = isCorrect ? ['Option A'] : ['Option B'];
        topic = 'General Knowledge';
        subtopic = 'Multiple Choice';
        break;
      case QuestionType.trueFalse:
        questionText = 'Sample true/false question';
        options = ['True', 'False'];
        correctAnswers = ['True'];
        userAnswers = isCorrect ? ['True'] : ['False'];
        topic = 'Logic';
        subtopic = 'Boolean Logic';
        break;
      case QuestionType.shortAnswer:
        questionText = 'Sample short answer question';
        options = [];
        correctAnswers = ['correct answer'];
        userAnswers = isCorrect ? ['correct answer'] : ['wrong answer'];
        topic = 'Writing';
        subtopic = 'Short Response';
        break;
      case QuestionType.multipleSelect:
        questionText = 'Sample multiple select question';
        options = ['Option A', 'Option B', 'Option C', 'Option D'];
        correctAnswers = ['Option A', 'Option C'];
        userAnswers = isCorrect 
            ? ['Option A', 'Option C'] 
            : ['Option A', 'Option B'];
        topic = 'Analysis';
        subtopic = 'Multiple Selection';
        break;
      case QuestionType.essay:
        questionText = 'Sample essay question';
        options = [];
        correctAnswers = ['comprehensive essay response'];
        userAnswers = isCorrect 
            ? ['comprehensive essay response'] 
            : ['incomplete response'];
        topic = 'Writing';
        subtopic = 'Essay Writing';
        break;
    }

    return QuestionResultModel(
      id: 'qr_${DateTime.now().millisecondsSinceEpoch}',
      questionId: questionId,
      examResultId: examResultId,
      questionText: questionText,
      questionType: type,
      options: options,
      correctAnswers: correctAnswers,
      userAnswers: userAnswers,
      resultType: isCorrect 
          ? QuestionResultType.correct 
          : QuestionResultType.incorrect,
      pointsEarned: isCorrect ? maxPoints : 0.0,
      maxPoints: maxPoints,
      timeSpent: timeSpent,
      answeredAt: now,
      explanation: isCorrect 
          ? 'Correct! Well done.' 
          : 'Incorrect. Please review the concept.',
      topic: topic,
      subtopic: subtopic,
      difficulty: difficulty,
      metadata: {
        'generated': true,
        'correctness': isCorrect,
      },
      tags: [topic.toLowerCase().replaceAll(' ', '-')],
    );
  }

  /// Create question result for specific topic
  factory QuestionResultModel.forTopic({
    required String questionId,
    required String examResultId,
    required String topic,
    required String subtopic,
    required QuestionResultType resultType,
    QuestionType type = QuestionType.multipleChoice,
    QuestionDifficulty difficulty = QuestionDifficulty.medium,
  }) {
    final isCorrect = resultType == QuestionResultType.correct;
    final maxPoints = 3.0 + (difficulty.index * 2.0);
    final pointsEarned = resultType == QuestionResultType.correct
        ? maxPoints
        : resultType == QuestionResultType.partiallyCorrect
            ? maxPoints * 0.5
            : 0.0;

    return QuestionResultModel(
      id: 'qr_${topic.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
      questionId: questionId,
      examResultId: examResultId,
      questionText: 'Question about $subtopic in $topic',
      questionType: type,
      options: type == QuestionType.shortAnswer || type == QuestionType.essay
          ? []
          : ['Option A', 'Option B', 'Option C', 'Option D'],
      correctAnswers: type == QuestionType.shortAnswer || type == QuestionType.essay
          ? ['correct answer']
          : ['Option A'],
      userAnswers: isCorrect
          ? (type == QuestionType.shortAnswer || type == QuestionType.essay
              ? ['correct answer']
              : ['Option A'])
          : (type == QuestionType.shortAnswer || type == QuestionType.essay
              ? ['wrong answer']
              : ['Option B']),
      resultType: resultType,
      pointsEarned: pointsEarned,
      maxPoints: maxPoints,
      timeSpent: Duration(seconds: 30 + (difficulty.index * 20)),
      answeredAt: DateTime.now(),
      explanation: 'Explanation for $subtopic concept',
      topic: topic,
      subtopic: subtopic,
      difficulty: difficulty,
      metadata: {
        'topicGenerated': true,
        'resultType': resultType.name,
      },
      tags: [topic.toLowerCase().replaceAll(' ', '-'), subtopic.toLowerCase().replaceAll(' ', '-')],
    );
  }

  @override
  String toString() {
    return 'QuestionResultModel(id: $id, questionId: $questionId, resultType: $resultType, points: $pointsEarned/$maxPoints)';
  }
}