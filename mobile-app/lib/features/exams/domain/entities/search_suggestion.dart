import 'package:equatable/equatable.dart';

/// Entity representing a search suggestion
class SearchSuggestion extends Equatable {
  final String id;
  final String text;
  final String type; // 'exam', 'category', 'tag', etc.
  final int frequency; // How often this suggestion was used
  final DateTime lastUsed;
  final Map<String, dynamic>? metadata;

  const SearchSuggestion({
    required this.id,
    required this.text,
    required this.type,
    this.frequency = 1,
    required this.lastUsed,
    this.metadata,
  });

  /// Create a copy with updated properties
  SearchSuggestion copyWith({
    String? id,
    String? text,
    String? type,
    int? frequency,
    DateTime? lastUsed,
    Map<String, dynamic>? metadata,
  }) {
    return SearchSuggestion(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      lastUsed: lastUsed ?? this.lastUsed,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        type,
        frequency,
        lastUsed,
        metadata,
      ];

  @override
  String toString() {
    return 'SearchSuggestion(id: $id, text: $text, type: $type, frequency: $frequency)';
  }
}