import 'package:equatable/equatable.dart';

/// Option entity for question choices
class Option extends Equatable {
  final String id;
  final String text;
  final bool isCorrect;
  final int order;
  final String? explanation;
  final String? imageUrl;

  const Option({
    required this.id,
    required this.text,
    this.isCorrect = false,
    required this.order,
    this.explanation,
    this.imageUrl,
  });

  /// Create copy with updated values
  Option copyWith({
    String? id,
    String? text,
    bool? isCorrect,
    int? order,
    String? explanation,
    String? imageUrl,
  }) {
    return Option(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
      order: order ?? this.order,
      explanation: explanation ?? this.explanation,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        isCorrect,
        order,
        explanation,
        imageUrl,
      ];

  @override
  String toString() {
    return 'Option(id: $id, text: $text, isCorrect: $isCorrect, order: $order)';
  }
}