import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

@HiveType(typeId: 14)
@JsonSerializable()
class CategoryModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final String id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'description')
  final String description;

  @HiveField(3)
  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  @HiveField(4)
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @HiveField(5)
  @JsonKey(name: 'color')
  final String color;

  @HiveField(6)
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @HiveField(7)
  @JsonKey(name: 'is_active')
  final bool isActive;

  @HiveField(8)
  @JsonKey(name: 'parent_id')
  final String? parentId;

  @HiveField(9)
  @JsonKey(name: 'subcategories')
  final List<CategoryModel> subcategories;

  @HiveField(10)
  @JsonKey(name: 'exam_count')
  final int examCount;

  @HiveField(11)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @HiveField(12)
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @HiveField(13)
  @JsonKey(name: 'stats')
  final CategoryStatsModel? stats;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    this.imageUrl,
    this.color = '#2196F3',
    this.sortOrder = 0,
    this.isActive = true,
    this.parentId,
    this.subcategories = const [],
    this.examCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.stats,
  });

  /// Convert from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Convert from domain entity
  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      iconUrl: category.iconUrl,
      imageUrl: category.imageUrl,
      color: category.color,
      sortOrder: category.sortOrder,
      isActive: category.isActive,
      parentId: category.parentId,
      subcategories: category.subcategories
          .map((subcategory) => CategoryModel.fromEntity(subcategory))
          .toList(),
      examCount: category.examCount,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      stats: category.stats != null ? CategoryStatsModel.fromEntity(category.stats!) : null,
    );
  }

  /// Convert to domain entity
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      iconUrl: iconUrl,
      imageUrl: imageUrl,
      color: color,
      sortOrder: sortOrder,
      isActive: isActive,
      parentId: parentId,
      subcategories: subcategories
          .map((subcategory) => subcategory.toEntity())
          .toList(),
      examCount: examCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      stats: stats?.toEntity(),
    );
  }
}

@HiveType(typeId: 15)
@JsonSerializable()
class CategoryStatsModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'total_exams')
  final int totalExams;

  @HiveField(1)
  @JsonKey(name: 'active_exams')
  final int activeExams;

  @HiveField(2)
  @JsonKey(name: 'total_attempts')
  final int totalAttempts;

  @HiveField(3)
  @JsonKey(name: 'average_score')
  final double averageScore;

  @HiveField(4)
  @JsonKey(name: 'total_users')
  final int totalUsers;

  @HiveField(5)
  @JsonKey(name: 'last_activity_at')
  final DateTime? lastActivityAt;

  CategoryStatsModel({
    required this.totalExams,
    required this.activeExams,
    required this.totalAttempts,
    required this.averageScore,
    required this.totalUsers,
    this.lastActivityAt,
  });

  /// Convert from JSON
  factory CategoryStatsModel.fromJson(Map<String, dynamic> json) => _$CategoryStatsModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$CategoryStatsModelToJson(this);

  /// Convert from domain entity
  factory CategoryStatsModel.fromEntity(CategoryStats stats) {
    return CategoryStatsModel(
      totalExams: stats.totalExams,
      activeExams: stats.activeExams,
      totalAttempts: stats.totalAttempts,
      averageScore: stats.averageScore,
      totalUsers: stats.totalUsers,
      lastActivityAt: stats.lastActivityAt,
    );
  }

  /// Convert to domain entity
  CategoryStats toEntity() {
    return CategoryStats(
      totalExams: totalExams,
      activeExams: activeExams,
      totalAttempts: totalAttempts,
      averageScore: averageScore,
      totalUsers: totalUsers,
      lastActivityAt: lastActivityAt,
    );
  }
}

@HiveType(typeId: 16)
@JsonSerializable()
class CategoryFilterModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'category_id')
  final String? categoryId;

  @HiveField(1)
  @JsonKey(name: 'subcategory_id')
  final String? subcategoryId;

  @HiveField(2)
  @JsonKey(name: 'include_subcategories')
  final bool includeSubcategories;

  @HiveField(3)
  @JsonKey(name: 'active_only')
  final bool activeOnly;

  CategoryFilterModel({
    this.categoryId,
    this.subcategoryId,
    this.includeSubcategories = true,
    this.activeOnly = true,
  });

  /// Convert from JSON
  factory CategoryFilterModel.fromJson(Map<String, dynamic> json) => _$CategoryFilterModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$CategoryFilterModelToJson(this);

  /// Convert from domain entity
  factory CategoryFilterModel.fromEntity(CategoryFilter filter) {
    return CategoryFilterModel(
      categoryId: filter.categoryId,
      subcategoryId: filter.subcategoryId,
      includeSubcategories: filter.includeSubcategories,
      activeOnly: filter.activeOnly,
    );
  }

  /// Convert to domain entity
  CategoryFilter toEntity() {
    return CategoryFilter(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      includeSubcategories: includeSubcategories,
      activeOnly: activeOnly,
    );
  }
}