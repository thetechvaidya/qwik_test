import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_stats.dart';

part 'user_stats_model.g.dart';

@JsonSerializable()
class UserStatsModel extends UserStats {
  const UserStatsModel({
    super.totalExamsTaken = 0,
    super.totalPoints = 0,
    super.averageScore = 0.0,
    super.rank = 0,
    super.streakDays = 0,
    super.certificatesEarned = 0,
    super.studyHours = 0,
    super.correctAnswers = 0,
    super.totalQuestions = 0,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserStatsModelFromJson(json);
    } catch (e) {
      // Provide fallback values if JSON parsing fails
      return const UserStatsModel();
    }
  }

  Map<String, dynamic> toJson() => _$UserStatsModelToJson(this);

  factory UserStatsModel.fromEntity(UserStats stats) {
    return UserStatsModel(
      totalExamsTaken: stats.totalExamsTaken,
      totalPoints: stats.totalPoints,
      averageScore: stats.averageScore,
      rank: stats.rank,
      streakDays: stats.streakDays,
      certificatesEarned: stats.certificatesEarned,
      studyHours: stats.studyHours,
      correctAnswers: stats.correctAnswers,
      totalQuestions: stats.totalQuestions,
    );
  }

  UserStats toEntity() {
    return UserStats(
      totalExamsTaken: totalExamsTaken,
      totalPoints: totalPoints,
      averageScore: averageScore,
      rank: rank,
      streakDays: streakDays,
      certificatesEarned: certificatesEarned,
      studyHours: studyHours,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
    );
  }

  /// Create stats model with validation for reasonable values
  factory UserStatsModel.withValidation({
    int? totalExamsTaken,
    int? totalPoints,
    double? averageScore,
    int? rank,
    int? streakDays,
    int? certificatesEarned,
    int? studyHours,
    int? correctAnswers,
    int? totalQuestions,
  }) {
    return UserStatsModel(
      totalExamsTaken: (totalExamsTaken ?? 0).clamp(0, 999999),
      totalPoints: (totalPoints ?? 0).clamp(0, 999999999),
      averageScore: (averageScore ?? 0.0).clamp(0.0, 100.0),
      rank: (rank ?? 0).clamp(0, 999999999),
      streakDays: (streakDays ?? 0).clamp(0, 9999),
      certificatesEarned: (certificatesEarned ?? 0).clamp(0, 999999),
      studyHours: (studyHours ?? 0).clamp(0, 999999),
      correctAnswers: (correctAnswers ?? 0).clamp(0, 999999999),
      totalQuestions: (totalQuestions ?? 0).clamp(0, 999999999),
    );
  }
}