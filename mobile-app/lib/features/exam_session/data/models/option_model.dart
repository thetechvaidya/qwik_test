import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/option.dart';

part 'option_model.g.dart';

@HiveType(typeId: 18)
@JsonSerializable()
class OptionModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final String id;

  @HiveField(1)
  @JsonKey(name: 'text')
  final String text;

  @HiveField(2)
  @JsonKey(name: 'is_correct')
  final bool isCorrect;

  @HiveField(3)
  @JsonKey(name: 'order')
  final int order;

  @HiveField(4)
  @JsonKey(name: 'explanation')
  final String? explanation;

  @HiveField(5)
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  OptionModel({
    required this.id,
    required this.text,
    this.isCorrect = false,
    required this.order,
    this.explanation,
    this.imageUrl,
  });

  /// Convert from JSON
  factory OptionModel.fromJson(Map<String, dynamic> json) => _$OptionModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$OptionModelToJson(this);

  /// Convert from domain entity
  factory OptionModel.fromEntity(Option option) {
    return OptionModel(
      id: option.id,
      text: option.text,
      isCorrect: option.isCorrect,
      order: option.order,
      explanation: option.explanation,
      imageUrl: option.imageUrl,
    );
  }

  /// Convert to domain entity
  Option toEntity() {
    return Option(
      id: id,
      text: text,
      isCorrect: isCorrect,
      order: order,
      explanation: explanation,
      imageUrl: imageUrl,
    );
  }
}