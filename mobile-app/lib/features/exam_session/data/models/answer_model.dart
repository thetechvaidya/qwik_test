import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/answer.dart';

part 'answer_model.g.dart';

@HiveType(typeId: 20)
@JsonSerializable()
class AnswerModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'question_id')
  final String questionId;

  @HiveField(1)
  @JsonKey(name: 'selected_option_ids')
  final List<String> selectedOptionIds;

  @HiveField(2)
  @JsonKey(name: 'time_spent')
  final int timeSpent;

  @HiveField(3)
  @JsonKey(name: 'answered_at')
  final DateTime? answeredAt;

  @HiveField(4)
  @JsonKey(name: 'is_correct')
  final bool? isCorrect;

  @HiveField(5)
  @JsonKey(name: 'score')
  final double? score;

  @HiveField(6)
  @JsonKey(name: 'is_skipped')
  final bool isSkipped;

  @HiveField(7)
  @JsonKey(name: 'is_marked_for_review')
  final bool isMarkedForReview;

  @HiveField(8)
  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;

  AnswerModel({
    required this.questionId,
    this.selectedOptionIds = const [],
    this.timeSpent = 0,
    this.answeredAt,
    this.isCorrect,
    this.score,
    this.isSkipped = false,
    this.isMarkedForReview = false,
    this.metadata,
  });

  /// Convert from JSON
  factory AnswerModel.fromJson(Map<String, dynamic> json) => _$AnswerModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$AnswerModelToJson(this);

  /// Convert from domain entity
  factory AnswerModel.fromEntity(Answer answer) {
    return AnswerModel(
      questionId: answer.questionId,
      selectedOptionIds: answer.selectedOptionIds,
      timeSpent: answer.timeSpent,
      answeredAt: answer.answeredAt,
      isCorrect: answer.isCorrect,
      score: answer.score,
      isSkipped: answer.isSkipped,
      isMarkedForReview: answer.isMarkedForReview,
      metadata: answer.metadata,
    );
  }

  /// Convert to domain entity
  Answer toEntity() {
    return Answer(
      questionId: questionId,
      selectedOptionIds: selectedOptionIds,
      timeSpent: timeSpent,
      answeredAt: answeredAt,
      isCorrect: isCorrect,
      score: score,
      isSkipped: isSkipped,
      isMarkedForReview: isMarkedForReview,
      metadata: metadata,
    );
  }
}