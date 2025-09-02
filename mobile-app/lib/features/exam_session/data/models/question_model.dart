import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/question.dart';
import 'option_model.dart';

part 'question_model.g.dart';

@HiveType(typeId: 19)
@JsonSerializable()
class QuestionModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final String id;

  @HiveField(1)
  @JsonKey(name: 'type')
  final String type;

  @HiveField(2)
  @JsonKey(name: 'question_text')
  final String questionText;

  @HiveField(3)
  @JsonKey(name: 'options')
  final List<OptionModel> options;

  @HiveField(4)
  @JsonKey(name: 'time_limit')
  final int? timeLimit;

  @HiveField(5)
  @JsonKey(name: 'explanation')
  final String? explanation;

  @HiveField(6)
  @JsonKey(name: 'difficulty')
  final String difficulty;

  @HiveField(7)
  @JsonKey(name: 'marks')
  final double marks;

  @HiveField(8)
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @HiveField(9)
  @JsonKey(name: 'audio_url')
  final String? audioUrl;

  @HiveField(10)
  @JsonKey(name: 'video_url')
  final String? videoUrl;

  @HiveField(11)
  @JsonKey(name: 'order')
  final int order;

  @HiveField(12)
  @JsonKey(name: 'is_required')
  final bool isRequired;

  @HiveField(13)
  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;

  QuestionModel({
    required this.id,
    required this.type,
    required this.questionText,
    this.options = const [],
    this.timeLimit,
    this.explanation,
    this.difficulty = 'medium',
    this.marks = 1.0,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
    required this.order,
    this.isRequired = true,
    this.metadata,
  });

  /// Convert from JSON
  factory QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);

  /// Convert from domain entity
  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      type: question.type.name,
      questionText: question.questionText,
      options: question.options.map((option) => OptionModel.fromEntity(option)).toList(),
      timeLimit: question.timeLimit,
      explanation: question.explanation,
      difficulty: question.difficulty.name,
      marks: question.marks,
      imageUrl: question.imageUrl,
      audioUrl: question.audioUrl,
      videoUrl: question.videoUrl,
      order: question.order,
      isRequired: question.isRequired,
      metadata: question.metadata,
    );
  }

  /// Convert to domain entity
  Question toEntity() {
    return Question(
      id: id,
      type: _parseQuestionType(type),
      questionText: questionText,
      options: options.map((option) => option.toEntity()).toList(),
      timeLimit: timeLimit,
      explanation: explanation,
      difficulty: _parseQuestionDifficulty(difficulty),
      marks: marks,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      videoUrl: videoUrl,
      order: order,
      isRequired: isRequired,
      metadata: metadata,
    );
  }

  /// Parse question type from string
  QuestionType _parseQuestionType(String type) {
    switch (type.toLowerCase()) {
      case 'multiple_choice':
        return QuestionType.multipleChoice;
      case 'single_choice':
        return QuestionType.singleChoice;
      case 'true_false':
        return QuestionType.trueFalse;
      default:
        return QuestionType.singleChoice;
    }
  }

  /// Parse question difficulty from string
  QuestionDifficulty _parseQuestionDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return QuestionDifficulty.easy;
      case 'medium':
        return QuestionDifficulty.medium;
      case 'hard':
        return QuestionDifficulty.hard;
      default:
        return QuestionDifficulty.medium;
    }
  }
}