// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentActivityModel _$RecentActivityModelFromJson(Map<String, dynamic> json) =>
    RecentActivityModel(
      id: json['id'] as String,
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>,
      examId: json['examId'] as String?,
      examTitle: json['examTitle'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      achievementId: json['achievementId'] as String?,
      achievementTitle: json['achievementTitle'] as String?,
      streakCount: (json['streakCount'] as num?)?.toInt(),
      pointsEarned: (json['pointsEarned'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecentActivityModelToJson(
        RecentActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'completedAt': instance.completedAt.toIso8601String(),
      'metadata': instance.metadata,
      'examId': instance.examId,
      'examTitle': instance.examTitle,
      'score': instance.score,
      'achievementId': instance.achievementId,
      'achievementTitle': instance.achievementTitle,
      'streakCount': instance.streakCount,
      'pointsEarned': instance.pointsEarned,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.examCompleted: 'examCompleted',
  ActivityType.achievementUnlocked: 'achievementUnlocked',
  ActivityType.streakMilestone: 'streakMilestone',
  ActivityType.perfectScore: 'perfectScore',
  ActivityType.firstExam: 'firstExam',
  ActivityType.levelUp: 'levelUp',
  ActivityType.categoryMastery: 'categoryMastery',
  ActivityType.timeRecord: 'timeRecord',
};
