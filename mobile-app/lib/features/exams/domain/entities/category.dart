import 'package:equatable/equatable.dart';

/// Category entity for organizing exams
class Category extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? iconUrl;
  final String? imageUrl;
  final String color;
  final int sortOrder;
  final bool isActive;
  final String? parentId;
  final List<Category> subcategories;
  final int examCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryStats? stats;

  const Category({
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

  /// Check if this is a root category (no parent)
  bool get isRootCategory => parentId == null;

  /// Check if this category has subcategories
  bool get hasSubcategories => subcategories.isNotEmpty;

  /// Get the category hierarchy path
  String getHierarchyPath([String separator = ' > ']) {
    // This would need to be implemented with parent category data
    // For now, just return the category name
    return name;
  }

  /// Get formatted exam count
  String get formattedExamCount {
    if (examCount == 0) return 'No exams';
    if (examCount == 1) return '1 exam';
    return '$examCount exams';
  }

  /// Create copy with updated values
  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    String? imageUrl,
    String? color,
    int? sortOrder,
    bool? isActive,
    String? parentId,
    List<Category>? subcategories,
    int? examCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    CategoryStats? stats,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      parentId: parentId ?? this.parentId,
      subcategories: subcategories ?? this.subcategories,
      examCount: examCount ?? this.examCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        iconUrl,
        imageUrl,
        color,
        sortOrder,
        isActive,
        parentId,
        subcategories,
        examCount,
        createdAt,
        updatedAt,
        stats,
      ];
}

/// Category statistics
class CategoryStats extends Equatable {
  final int totalExams;
  final int activeExams;
  final int totalAttempts;
  final double averageScore;
  final int totalUsers;
  final DateTime? lastActivityAt;

  const CategoryStats({
    required this.totalExams,
    required this.activeExams,
    required this.totalAttempts,
    required this.averageScore,
    required this.totalUsers,
    this.lastActivityAt,
  });

  /// Get activity status
  String get activityStatus {
    if (lastActivityAt == null) return 'No activity';
    
    final now = DateTime.now();
    final difference = now.difference(lastActivityAt!);
    
    if (difference.inDays == 0) return 'Active today';
    if (difference.inDays == 1) return 'Active yesterday';
    if (difference.inDays < 7) return 'Active ${difference.inDays} days ago';
    if (difference.inDays < 30) return 'Active ${(difference.inDays / 7).floor()} weeks ago';
    return 'Active ${(difference.inDays / 30).floor()} months ago';
  }

  @override
  List<Object?> get props => [
        totalExams,
        activeExams,
        totalAttempts,
        averageScore,
        totalUsers,
        lastActivityAt,
      ];
}

/// Category filter for exam listing
class CategoryFilter extends Equatable {
  final String? categoryId;
  final String? subcategoryId;
  final bool includeSubcategories;
  final bool activeOnly;

  const CategoryFilter({
    this.categoryId,
    this.subcategoryId,
    this.includeSubcategories = true,
    this.activeOnly = true,
  });

  /// Check if filter is empty
  bool get isEmpty => categoryId == null && subcategoryId == null;

  /// Check if filter has category
  bool get hasCategory => categoryId != null;

  /// Check if filter has subcategory
  bool get hasSubcategory => subcategoryId != null;

  /// Convert to query parameters
  Map<String, dynamic> toJson() {
    final params = <String, dynamic>{};
    
    if (categoryId != null) {
      params['category_id'] = categoryId;
    }
    
    if (subcategoryId != null) {
      params['subcategory_id'] = subcategoryId;
    }
    
    if (includeSubcategories) {
      params['include_subcategories'] = true;
    }
    
    if (activeOnly) {
      params['active_only'] = true;
    }
    
    return params;
  }

  /// Create copy with updated values
  CategoryFilter copyWith({
    String? categoryId,
    String? subcategoryId,
    bool? includeSubcategories,
    bool? activeOnly,
  }) {
    return CategoryFilter(
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      includeSubcategories: includeSubcategories ?? this.includeSubcategories,
      activeOnly: activeOnly ?? this.activeOnly,
    );
  }

  /// Clear all filters
  CategoryFilter clear() {
    return const CategoryFilter();
  }

  @override
  List<Object?> get props => [
        categoryId,
        subcategoryId,
        includeSubcategories,
        activeOnly,
      ];
}