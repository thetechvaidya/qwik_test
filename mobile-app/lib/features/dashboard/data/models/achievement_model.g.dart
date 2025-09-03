// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievementModel _$AchievementModelFromJson(Map<String, dynamic> json) =>
    AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      progress: (json['progress'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
      category: $enumDecode(_$AchievementCategoryEnumMap, json['category']),
      points: (json['points'] as num).toInt(),
      difficulty:
          $enumDecode(_$AchievementDifficultyEnumMap, json['difficulty']),
      requirements: (json['requirements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      badgeUrl: json['badgeUrl'] as String?,
      isHidden: json['isHidden'] as bool? ?? false,
    );

Map<String, dynamic> _$AchievementModelToJson(AchievementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'progress': instance.progress,
      'total': instance.total,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
      'category': _$AchievementCategoryEnumMap[instance.category]!,
      'points': instance.points,
      'difficulty': _$AchievementDifficultyEnumMap[instance.difficulty]!,
      'requirements': instance.requirements,
      'badgeUrl': instance.badgeUrl,
      'isHidden': instance.isHidden,
    };

const _$AchievementCategoryEnumMap = {
  AchievementCategory.examCompletion: 'examCompletion',
  AchievementCategory.streak: 'streak',
  AchievementCategory.performance: 'performance',
  AchievementCategory.special: 'special',
};

const _$AchievementDifficultyEnumMap = {
  AchievementDifficulty.bronze: 'bronze',
  AchievementDifficulty.silver: 'silver',
  AchievementDifficulty.gold: 'gold',
  AchievementDifficulty.platinum: 'platinum',
  AchievementDifficulty.diamond: 'diamond',
};
