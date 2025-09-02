import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/recent_activity.dart';

part 'recent_activity_model.g.dart';

@JsonSerializable()
class RecentActivityModel extends RecentActivity {
  const RecentActivityModel({
    required super.id,
    required super.type,
    required super.title,
    required super.description,
    required super.completedAt,
    required super.metadata,
    super.examId,
    super.examTitle,
    super.score,
    super.achievementId,
    super.achievementTitle,
    super.streakCount,
    super.pointsEarned,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      id: json['id'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ActivityType.examCompleted,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      metadata: Map<String, dynamic>.from(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
      examId: json['examId'] as String?,
      examTitle: json['examTitle'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      achievementId: json['achievementId'] as String?,
      achievementTitle: json['achievementTitle'] as String?,
      streakCount: json['streakCount'] as int?,
      pointsEarned: json['pointsEarned'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'completedAt': completedAt.toIso8601String(),
      'metadata': metadata,
      'examId': examId,
      'examTitle': examTitle,
      'score': score,
      'achievementId': achievementId,
      'achievementTitle': achievementTitle,
      'streakCount': streakCount,
      'pointsEarned': pointsEarned,
    };
  }

  /// Create from entity
  factory RecentActivityModel.fromEntity(RecentActivity entity) {
    return RecentActivityModel(
      id: entity.id,
      type: entity.type,
      title: entity.title,
      description: entity.description,
      completedAt: entity.completedAt,
      metadata: entity.metadata,
      examId: entity.examId,
      examTitle: entity.examTitle,
      score: entity.score,
      achievementId: entity.achievementId,
      achievementTitle: entity.achievementTitle,
      streakCount: entity.streakCount,
      pointsEarned: entity.pointsEarned,
    );
  }

  /// Convert to entity
  RecentActivity toEntity() {
    return RecentActivity(
      id: id,
      type: type,
      title: title,
      description: description,
      completedAt: completedAt,
      metadata: metadata,
      examId: examId,
      examTitle: examTitle,
      score: score,
      achievementId: achievementId,
      achievementTitle: achievementTitle,
      streakCount: streakCount,
      pointsEarned: pointsEarned,
    );
  }

  /// Copy with new values
  RecentActivityModel copyWith({
    String? id,
    ActivityType? type,
    String? title,
    String? description,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
    String? examId,
    String? examTitle,
    double? score,
    String? achievementId,
    String? achievementTitle,
    int? streakCount,
    int? pointsEarned,
  }) {
    return RecentActivityModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
      examId: examId ?? this.examId,
      examTitle: examTitle ?? this.examTitle,
      score: score ?? this.score,
      achievementId: achievementId ?? this.achievementId,
      achievementTitle: achievementTitle ?? this.achievementTitle,
      streakCount: streakCount ?? this.streakCount,
      pointsEarned: pointsEarned ?? this.pointsEarned,
    );
  }

  /// Factory methods for different activity types
  factory RecentActivityModel.examCompleted({
    required String id,
    required String examId,
    required String examTitle,
    required double score,
    required DateTime completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
  }) {
    return RecentActivityModel(
      id: id,
      type: ActivityType.examCompleted,
      title: 'Exam Completed',
      description: 'Completed "$examTitle" with ${score.toStringAsFixed(1)}% score',
      completedAt: completedAt,
      metadata: metadata ?? {},
      examId: examId,
      examTitle: examTitle,
      score: score,
      pointsEarned: pointsEarned,
    );
  }

  factory RecentActivityModel.achievementUnlocked({
    required String id,
    required String achievementId,
    required String achievementTitle,
    required DateTime completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
  }) {
    return RecentActivityModel(
      id: id,
      type: ActivityType.achievementUnlocked,
      title: 'Achievement Unlocked',
      description: 'Unlocked "$achievementTitle" achievement',
      completedAt: completedAt,
      metadata: metadata ?? {},
      achievementId: achievementId,
      achievementTitle: achievementTitle,
      pointsEarned: pointsEarned,
    );
  }

  factory RecentActivityModel.streakMilestone({
    required String id,
    required int streakCount,
    required DateTime completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
  }) {
    return RecentActivityModel(
      id: id,
      type: ActivityType.streakMilestone,
      title: 'Streak Milestone',
      description: 'Reached $streakCount day learning streak!',
      completedAt: completedAt,
      metadata: metadata ?? {},
      streakCount: streakCount,
      pointsEarned: pointsEarned,
    );
  }

  factory RecentActivityModel.perfectScore({
    required String id,
    required String examId,
    required String examTitle,
    required DateTime completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
  }) {
    return RecentActivityModel(
      id: id,
      type: ActivityType.perfectScore,
      title: 'Perfect Score',
      description: 'Perfect score on "$examTitle"!',
      completedAt: completedAt,
      metadata: metadata ?? {},
      examId: examId,
      examTitle: examTitle,
      score: 100.0,
      pointsEarned: pointsEarned,
    );
  }

  factory RecentActivityModel.firstExam({
    required String id,
    required String examId,
    required String examTitle,
    required DateTime completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
  }) {
    return RecentActivityModel(
      id: id,
      type: ActivityType.firstExam,
      title: 'First Exam',
      description: 'Completed first exam: "$examTitle"',
      completedAt: completedAt,
      metadata: metadata ?? {},
      examId: examId,
      examTitle: examTitle,
      pointsEarned: pointsEarned,
    );
  }

  factory RecentActivityModel.levelUp({
    required String id,
    required int newLevel,
    required DateTime completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
  }) {
    return RecentActivityModel(
      id: id,
      type: ActivityType.levelUp,
      title: 'Level Up',
      description: 'Reached level $newLevel!',
      completedAt: completedAt,
      metadata: (metadata ?? {})..['newLevel'] = newLevel,
      pointsEarned: pointsEarned,
    );
  }

  factory RecentActivityModel.categoryMastery({
    required String id,
    required String category,
    required DateTime completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
  }) {
    return RecentActivityModel(
      id: id,
      type: ActivityType.categoryMastery,
      title: 'Category Mastery',
      description: 'Mastered $category category!',
      completedAt: completedAt,
      metadata: (metadata ?? {})..['category'] = category,
      pointsEarned: pointsEarned,
    );
  }

  factory RecentActivityModel.timeRecord({
    required String id,
    required String examTitle,
    required Duration recordTime,
    required DateTime completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
  }) {
    return RecentActivityModel(
      id: id,
      type: ActivityType.timeRecord,
      title: 'Time Record',
      description: 'New time record on "$examTitle": ${recordTime.inMinutes}m ${recordTime.inSeconds % 60}s',
      completedAt: completedAt,
      metadata: (metadata ?? {})..['recordTimeSeconds'] = recordTime.inSeconds,
      pointsEarned: pointsEarned,
    );
  }

  /// Create sample activities for testing
  static List<RecentActivityModel> getSampleActivities() {
    final now = DateTime.now();
    return [
      RecentActivityModel.examCompleted(
        id: 'activity_1',
        examId: 'exam_1',
        examTitle: 'Mathematics Basics',
        score: 85.5,
        completedAt: now.subtract(const Duration(hours: 2)),
        pointsEarned: 855,
      ),
      RecentActivityModel.achievementUnlocked(
        id: 'activity_2',
        achievementId: 'first_exam',
        achievementTitle: 'First Steps',
        completedAt: now.subtract(const Duration(hours: 2, minutes: 5)),
        pointsEarned: 100,
      ),
      RecentActivityModel.streakMilestone(
        id: 'activity_3',
        streakCount: 7,
        completedAt: now.subtract(const Duration(days: 1)),
        pointsEarned: 300,
      ),
      RecentActivityModel.perfectScore(
        id: 'activity_4',
        examId: 'exam_2',
        examTitle: 'Science Quiz',
        completedAt: now.subtract(const Duration(days: 2)),
        pointsEarned: 1200,
      ),
    ];
  }

  @override
  String toString() {
    return 'RecentActivityModel(id: $id, type: $type, title: $title, completedAt: $completedAt)';
  }
}