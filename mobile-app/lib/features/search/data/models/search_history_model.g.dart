// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHistoryModelAdapter extends TypeAdapter<SearchHistoryModel> {
  @override
  final int typeId = 10;

  @override
  SearchHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHistoryModel(
      id: fields[0] as String,
      query: fields[1] as String,
      searchedAt: fields[2] as DateTime,
      frequency: fields[3] as int,
      categoryId: fields[4] as String?,
      categoryName: fields[5] as String?,
      filters: (fields[6] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SearchHistoryModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.query)
      ..writeByte(2)
      ..write(obj.searchedAt)
      ..writeByte(3)
      ..write(obj.frequency)
      ..writeByte(4)
      ..write(obj.categoryId)
      ..writeByte(5)
      ..write(obj.categoryName)
      ..writeByte(6)
      ..write(obj.filters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
