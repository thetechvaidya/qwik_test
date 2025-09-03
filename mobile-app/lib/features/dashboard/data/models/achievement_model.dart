import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/achievement.dart';

part 'achievement_model.g.dart';

@JsonSerializable()
class AchievementModel extends Achievement {
  const AchievementModel({
    required super.id,
    required super.title,
    required super.description,
    required super.icon,
    required super.progress,
    required super.total,
    required super.isUnlocked,
    super.unlockedAt,
    required super.category,
    required super.points,
    required super.difficulty,
    required super.requirements,
    super.badgeUrl,
    super.isHidden = false,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementModelToJson(this);

  /// Create from entity
  factory AchievementModel.fromEntity(Achievement entity) {
    return AchievementModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      icon: entity.icon,
      progress: entity.progress,
      total: entity.total,
      isUnlocked: entity.isUnlocked,
      unlockedAt: entity.unlockedAt,
      category: entity.category,
      points: entity.points,
      difficulty: entity.difficulty,
      requirements: entity.requirements,
      badgeUrl: entity.badgeUrl,
      isHidden: entity.isHidden,
    );
  }

  /// Convert to entity
  Achievement toEntity() {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      progress: progress,
      total: total,
      isUnlocked: isUnlocked,
      unlockedAt: unlockedAt,
      category: category,
      points: points,
      difficulty: difficulty,
      requirements: requirements,
      badgeUrl: badgeUrl,
      isHidden: isHidden,
    );
  }

  /// Copy with new values
  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? progress,
    int? total,
    bool? isUnlocked,
    DateTime? unlockedAt,
    AchievementCategory? category,
    int? points,
    AchievementDifficulty? difficulty,
    List<String>? requirements,
    String? badgeUrl,
    bool? isHidden,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      progress: progress ?? this.progress,
      total: total ?? this.total,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      category: category ?? this.category,
      points: points ?? this.points,
      difficulty: difficulty ?? this.difficulty,
      requirements: requirements ?? this.requirements,
      badgeUrl: badgeUrl ?? this.badgeUrl,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  /// Create sample achievements for testing
  static List<AchievementModel> getSampleAchievements() {
    return [
      AchievementModel(
        id: 'first_exam',
        title: 'First Steps',
        description: 'Complete your first exam',
        icon: '🎯',
        progress: 0,
        total: 1,
        isUnlocked: false,
        category: AchievementCategory.examCompletion,
        points: 100,
        difficulty: AchievementDifficulty.bronze,
        requirements: ['Complete 1 exam'],
      ),
      AchievementModel(
        id: 'perfect_score',
        title: 'Perfectionist',
        description: 'Achieve a perfect score on any exam',
        icon: '💯',
        progress: 0,
        total: 1,
        isUnlocked: false,
        category: AchievementCategory.performance,
        points: 500,
        difficulty: AchievementDifficulty.gold,
        requirements: ['Score 100% on an exam'],
      ),
      AchievementModel(
        id: 'week_streak',
        title: 'Week Warrior',
        description: 'Maintain a 7-day learning streak',
        icon: '🔥',
        progress: 0,
        total: 7,
        isUnlocked: false,
        category: AchievementCategory.streak,
        points: 300,
        difficulty: AchievementDifficulty.silver,
        requirements: ['Study for 7 consecutive days'],
      ),
      AchievementModel(
        id: 'exam_master',
        title: 'Exam Master',
        description: 'Complete 100 exams',
        icon: '🏆',
        progress: 0,
        total: 100,
        isUnlocked: false,
        category: AchievementCategory.examCompletion,
        points: 1000,
        difficulty: AchievementDifficulty.platinum,
        requirements: ['Complete 100 exams'],
      ),
      AchievementModel(
        id: 'speed_demon',
        title: 'Speed Demon',
        description: 'Complete an exam in under 5 minutes',
        icon: '⚡',
        progress: 0,
        total: 1,
        isUnlocked: false,
        category: AchievementCategory.special,
        points: 250,
        difficulty: AchievementDifficulty.gold,
        requirements: ['Complete exam in under 5 minutes'],
      ),
    ];
  }

  @override
  String toString() {
    return 'AchievementModel(id: $id, title: $title, progress: $progress/$total, unlocked: $isUnlocked)';
  }
}