// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestion_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchSuggestionModelAdapter extends TypeAdapter<SearchSuggestionModel> {
  @override
  final int typeId = 11;

  @override
  SearchSuggestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchSuggestionModel(
      id: fields[0] as String,
      text: fields[1] as String,
      type: fields[2] as SearchSuggestionTypeModel,
      popularity: fields[7] as int,
      categoryId: fields[3] as String?,
      categoryName: fields[4] as String?,
      examId: fields[5] as String?,
      examTitle: fields[6] as String?,
      metadata: (fields[8] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SearchSuggestionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.categoryName)
      ..writeByte(5)
      ..write(obj.examId)
      ..writeByte(6)
      ..write(obj.examTitle)
      ..writeByte(7)
      ..write(obj.popularity)
      ..writeByte(8)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchSuggestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SearchSuggestionTypeModelAdapter
    extends TypeAdapter<SearchSuggestionTypeModel> {
  @override
  final int typeId = 12;

  @override
  SearchSuggestionTypeModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SearchSuggestionTypeModel.exam;
      case 1:
        return SearchSuggestionTypeModel.category;
      case 2:
        return SearchSuggestionTypeModel.query;
      case 3:
        return SearchSuggestionTypeModel.history;
      default:
        return SearchSuggestionTypeModel.exam;
    }
  }

  @override
  void write(BinaryWriter writer, SearchSuggestionTypeModel obj) {
    switch (obj) {
      case SearchSuggestionTypeModel.exam:
        writer.writeByte(0);
        break;
      case SearchSuggestionTypeModel.category:
        writer.writeByte(1);
        break;
      case SearchSuggestionTypeModel.query:
        writer.writeByte(2);
        break;
      case SearchSuggestionTypeModel.history:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchSuggestionTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
