// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 14;

  @override
  CategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      iconUrl: fields[3] as String?,
      imageUrl: fields[4] as String?,
      color: fields[5] as String,
      sortOrder: fields[6] as int,
      isActive: fields[7] as bool,
      parentId: fields[8] as String?,
      subcategories: (fields[9] as List).cast<CategoryModel>(),
      examCount: fields[10] as int,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
      stats: fields[13] as CategoryStatsModel?,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.iconUrl)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.sortOrder)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.parentId)
      ..writeByte(9)
      ..write(obj.subcategories)
      ..writeByte(10)
      ..write(obj.examCount)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.stats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryStatsModelAdapter extends TypeAdapter<CategoryStatsModel> {
  @override
  final int typeId = 15;

  @override
  CategoryStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryStatsModel(
      totalExams: fields[0] as int,
      activeExams: fields[1] as int,
      totalAttempts: fields[2] as int,
      averageScore: fields[3] as double,
      totalUsers: fields[4] as int,
      lastActivityAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryStatsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.totalExams)
      ..writeByte(1)
      ..write(obj.activeExams)
      ..writeByte(2)
      ..write(obj.totalAttempts)
      ..writeByte(3)
      ..write(obj.averageScore)
      ..writeByte(4)
      ..write(obj.totalUsers)
      ..writeByte(5)
      ..write(obj.lastActivityAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryFilterModelAdapter extends TypeAdapter<CategoryFilterModel> {
  @override
  final int typeId = 16;

  @override
  CategoryFilterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryFilterModel(
      categoryId: fields[0] as String?,
      subcategoryId: fields[1] as String?,
      includeSubcategories: fields[2] as bool,
      activeOnly: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryFilterModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.categoryId)
      ..writeByte(1)
      ..write(obj.subcategoryId)
      ..writeByte(2)
      ..write(obj.includeSubcategories)
      ..writeByte(3)
      ..write(obj.activeOnly);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryFilterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String?,
      imageUrl: json['image_url'] as String?,
      color: json['color'] as String? ?? '#2196F3',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      parentId: json['parent_id'] as String?,
      subcategories: (json['subcategories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      examCount: (json['exam_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      stats: json['stats'] == null
          ? null
          : CategoryStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'image_url': instance.imageUrl,
      'color': instance.color,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'parent_id': instance.parentId,
      'subcategories': instance.subcategories,
      'exam_count': instance.examCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'stats': instance.stats,
    };

CategoryStatsModel _$CategoryStatsModelFromJson(Map<String, dynamic> json) =>
    CategoryStatsModel(
      totalExams: (json['total_exams'] as num).toInt(),
      activeExams: (json['active_exams'] as num).toInt(),
      totalAttempts: (json['total_attempts'] as num).toInt(),
      averageScore: (json['average_score'] as num).toDouble(),
      totalUsers: (json['total_users'] as num).toInt(),
      lastActivityAt: json['last_activity_at'] == null
          ? null
          : DateTime.parse(json['last_activity_at'] as String),
    );

Map<String, dynamic> _$CategoryStatsModelToJson(CategoryStatsModel instance) =>
    <String, dynamic>{
      'total_exams': instance.totalExams,
      'active_exams': instance.activeExams,
      'total_attempts': instance.totalAttempts,
      'average_score': instance.averageScore,
      'total_users': instance.totalUsers,
      'last_activity_at': instance.lastActivityAt?.toIso8601String(),
    };

CategoryFilterModel _$CategoryFilterModelFromJson(Map<String, dynamic> json) =>
    CategoryFilterModel(
      categoryId: json['category_id'] as String?,
      subcategoryId: json['subcategory_id'] as String?,
      includeSubcategories: json['include_subcategories'] as bool? ?? true,
      activeOnly: json['active_only'] as bool? ?? true,
    );

Map<String, dynamic> _$CategoryFilterModelToJson(
        CategoryFilterModel instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'subcategory_id': instance.subcategoryId,
      'include_subcategories': instance.includeSubcategories,
      'active_only': instance.activeOnly,
    };
