import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/performance_trend.dart';

part 'performance_trend_model.g.dart';

@JsonSerializable()
class PerformanceTrendModel extends PerformanceTrend {
  const PerformanceTrendModel({
    required super.id,
    required super.date,
    required super.score,
    required super.examCount,
    required super.totalTimeSpent,
    required super.category,
    required super.period,
    required super.metadata,
    super.accuracy,
    super.questionsAnswered,
    super.correctAnswers,
    super.averageTimePerQuestion,
    required super.examIds,
  });

  factory PerformanceTrendModel.fromJson(Map<String, dynamic> json) =>
      _$PerformanceTrendModelFromJson(json);

  Map<String, dynamic> toJson() => _$PerformanceTrendModelToJson(this);

  /// Create from entity
  factory PerformanceTrendModel.fromEntity(PerformanceTrend entity) {
    return PerformanceTrendModel(
      id: entity.id,
      date: entity.date,
      score: entity.score,
      examCount: entity.examCount,
      totalTimeSpent: entity.totalTimeSpent,
      category: entity.category,
      period: entity.period,
      metadata: entity.metadata,
      accuracy: entity.accuracy,
      questionsAnswered: entity.questionsAnswered,
      correctAnswers: entity.correctAnswers,
      averageTimePerQuestion: entity.averageTimePerQuestion,
      examIds: entity.examIds,
    );
  }

  /// Convert to entity
  PerformanceTrend toEntity() {
    return PerformanceTrend(
      id: id,
      date: date,
      score: score,
      examCount: examCount,
      totalTimeSpent: totalTimeSpent,
      category: category,
      period: period,
      metadata: metadata,
      accuracy: accuracy,
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      averageTimePerQuestion: averageTimePerQuestion,
      examIds: examIds,
    );
  }

  /// Copy with new values
  PerformanceTrendModel copyWith({
    String? id,
    DateTime? date,
    double? score,
    int? examCount,
    Duration? totalTimeSpent,
    String? category,
    TrendPeriod? period,
    Map<String, dynamic>? metadata,
    double? accuracy,
    int? questionsAnswered,
    int? correctAnswers,
    Duration? averageTimePerQuestion,
    List<String>? examIds,
  }) {
    return PerformanceTrendModel(
      id: id ?? this.id,
      date: date ?? this.date,
      score: score ?? this.score,
      examCount: examCount ?? this.examCount,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      category: category ?? this.category,
      period: period ?? this.period,
      metadata: metadata ?? this.metadata,
      accuracy: accuracy ?? this.accuracy,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      averageTimePerQuestion: averageTimePerQuestion ?? this.averageTimePerQuestion,
      examIds: examIds ?? this.examIds,
    );
  }

  /// Factory methods for different periods
  factory PerformanceTrendModel.daily({
    required String id,
    required DateTime date,
    required double score,
    required int examCount,
    required Duration totalTimeSpent,
    required String category,
    required List<String> examIds,
    double? accuracy,
    int? questionsAnswered,
    int? correctAnswers,
    Duration? averageTimePerQuestion,
    Map<String, dynamic>? metadata,
  }) {
    return PerformanceTrendModel(
      id: id,
      date: date,
      score: score,
      examCount: examCount,
      totalTimeSpent: totalTimeSpent,
      category: category,
      period: TrendPeriod.daily,
      metadata: metadata ?? {},
      accuracy: accuracy,
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      averageTimePerQuestion: averageTimePerQuestion,
      examIds: examIds,
    );
  }

  factory PerformanceTrendModel.weekly({
    required String id,
    required DateTime weekStart,
    required double averageScore,
    required int totalExams,
    required Duration totalTimeSpent,
    required String category,
    required List<String> examIds,
    double? accuracy,
    int? questionsAnswered,
    int? correctAnswers,
    Duration? averageTimePerQuestion,
    Map<String, dynamic>? metadata,
  }) {
    return PerformanceTrendModel(
      id: id,
      date: weekStart,
      score: averageScore,
      examCount: totalExams,
      totalTimeSpent: totalTimeSpent,
      category: category,
      period: TrendPeriod.weekly,
      metadata: metadata ?? {},
      accuracy: accuracy,
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      averageTimePerQuestion: averageTimePerQuestion,
      examIds: examIds,
    );
  }

  factory PerformanceTrendModel.monthly({
    required String id,
    required DateTime monthStart,
    required double averageScore,
    required int totalExams,
    required Duration totalTimeSpent,
    required String category,
    required List<String> examIds,
    double? accuracy,
    int? questionsAnswered,
    int? correctAnswers,
    Duration? averageTimePerQuestion,
    Map<String, dynamic>? metadata,
  }) {
    return PerformanceTrendModel(
      id: id,
      date: monthStart,
      score: averageScore,
      examCount: totalExams,
      totalTimeSpent: totalTimeSpent,
      category: category,
      period: TrendPeriod.monthly,
      metadata: metadata ?? {},
      accuracy: accuracy,
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      averageTimePerQuestion: averageTimePerQuestion,
      examIds: examIds,
    );
  }

  /// Create sample trends for testing
  static List<PerformanceTrendModel> getSampleTrends() {
    final now = DateTime.now();
    return List.generate(30, (index) {
      final date = now.subtract(Duration(days: 29 - index));
      final score = 70 + (index * 0.5) + (index % 3 * 5); // Trending upward with variation
      
      return PerformanceTrendModel.daily(
        id: 'trend_$index',
        date: date,
        score: score.clamp(0, 100),
        examCount: (index % 3) + 1,
        totalTimeSpent: Duration(minutes: 30 + (index % 5 * 10)),
        category: ['Mathematics', 'Science', 'History'][index % 3],
        examIds: ['exam_${index}_1', if (index % 3 > 0) 'exam_${index}_2'],
        accuracy: (score * 0.9).clamp(0, 100),
        questionsAnswered: 20 + (index % 5 * 2),
        correctAnswers: ((20 + (index % 5 * 2)) * (score / 100)).round(),
        averageTimePerQuestion: Duration(seconds: 45 + (index % 10 * 5)),
      );
    });
  }

  /// Create aggregated trend from multiple trends
  static PerformanceTrendModel aggregate({
    required String id,
    required List<PerformanceTrendModel> trends,
    required TrendPeriod period,
    required DateTime periodStart,
    required String category,
  }) {
    if (trends.isEmpty) {
      return PerformanceTrendModel(
        id: id,
        date: periodStart,
        score: 0,
        examCount: 0,
        totalTimeSpent: Duration.zero,
        category: category,
        period: period,
        metadata: {},
        examIds: [],
      );
    }

    final totalScore = trends.fold(0.0, (sum, trend) => sum + trend.score);
    final totalExams = trends.fold(0, (sum, trend) => sum + trend.examCount);
    final totalTime = trends.fold(
      Duration.zero,
      (sum, trend) => sum + trend.totalTimeSpent,
    );
    final allExamIds = trends.expand((trend) => trend.examIds).toList();
    
    final totalQuestions = trends
        .where((t) => t.questionsAnswered != null)
        .fold(0, (sum, trend) => sum + trend.questionsAnswered!);
    
    final totalCorrect = trends
        .where((t) => t.correctAnswers != null)
        .fold(0, (sum, trend) => sum + trend.correctAnswers!);

    return PerformanceTrendModel(
      id: id,
      date: periodStart,
      score: totalExams > 0 ? totalScore / totalExams : 0,
      examCount: totalExams,
      totalTimeSpent: totalTime,
      category: category,
      period: period,
      metadata: {
        'aggregatedFrom': trends.length,
        'dateRange': {
          'start': trends.first.date.toIso8601String(),
          'end': trends.last.date.toIso8601String(),
        },
      },
      accuracy: totalQuestions > 0 ? (totalCorrect / totalQuestions * 100) : null,
      questionsAnswered: totalQuestions > 0 ? totalQuestions : null,
      correctAnswers: totalCorrect > 0 ? totalCorrect : null,
      averageTimePerQuestion: totalQuestions > 0
          ? Duration(milliseconds: totalTime.inMilliseconds ~/ totalQuestions)
          : null,
      examIds: allExamIds,
    );
  }

  @override
  String toString() {
    return 'PerformanceTrendModel(id: $id, date: $date, score: $score, examCount: $examCount)';
  }
}