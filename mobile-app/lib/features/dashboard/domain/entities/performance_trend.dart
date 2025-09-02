import 'package:equatable/equatable.dart';

/// Entity representing performance trend data for charts and analytics
class PerformanceTrend extends Equatable {
  final String id;
  final DateTime date;
  final double score;
  final int examCount;
  final Duration totalTimeSpent;
  final String category;
  final TrendPeriod period;
  final Map<String, dynamic> metadata;
  final double? accuracy;
  final int? questionsAnswered;
  final int? correctAnswers;
  final double? averageTimePerQuestion;
  final List<String> examIds;

  const PerformanceTrend({
    required this.id,
    required this.date,
    required this.score,
    required this.examCount,
    required this.totalTimeSpent,
    required this.category,
    required this.period,
    required this.metadata,
    this.accuracy,
    this.questionsAnswered,
    this.correctAnswers,
    this.averageTimePerQuestion,
    required this.examIds,
  });

  /// Calculate accuracy percentage
  double getAccuracyPercentage() {
    if (accuracy != null) return accuracy!;
    if (questionsAnswered == null || correctAnswers == null) return 0.0;
    if (questionsAnswered! == 0) return 0.0;
    return (correctAnswers! / questionsAnswered! * 100).clamp(0.0, 100.0);
  }

  /// Get performance rating based on score
  PerformanceRating getPerformanceRating() {
    if (score >= 90) return PerformanceRating.excellent;
    if (score >= 80) return PerformanceRating.good;
    if (score >= 70) return PerformanceRating.average;
    if (score >= 60) return PerformanceRating.belowAverage;
    return PerformanceRating.poor;
  }

  /// Get trend direction compared to previous period
  TrendDirection getTrendDirection(PerformanceTrend? previousTrend) {
    if (previousTrend == null) return TrendDirection.neutral;
    
    final scoreDifference = score - previousTrend.score;
    
    if (scoreDifference > 5) return TrendDirection.improving;
    if (scoreDifference < -5) return TrendDirection.declining;
    return TrendDirection.stable;
  }

  /// Get score change percentage
  double getScoreChangePercentage(PerformanceTrend? previousTrend) {
    if (previousTrend == null || previousTrend.score == 0) return 0.0;
    return ((score - previousTrend.score) / previousTrend.score * 100);
  }

  /// Get formatted time spent
  String getFormattedTimeSpent() {
    final hours = totalTimeSpent.inHours;
    final minutes = totalTimeSpent.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get average score per exam
  double getAverageScorePerExam() {
    if (examCount == 0) return 0.0;
    return score / examCount;
  }

  /// Get efficiency score (score per minute)
  double getEfficiencyScore() {
    final totalMinutes = totalTimeSpent.inMinutes;
    if (totalMinutes == 0) return 0.0;
    return score / totalMinutes;
  }

  /// Check if this is a peak performance period
  bool isPeakPerformance() {
    return score >= 85 && examCount >= 3 && getAccuracyPercentage() >= 80;
  }

  /// Get performance insights
  List<String> getPerformanceInsights(PerformanceTrend? previousTrend) {
    final insights = <String>[];
    
    // Score insights
    if (previousTrend != null) {
      final scoreChange = getScoreChangePercentage(previousTrend);
      if (scoreChange > 10) {
        insights.add('Great improvement! Score increased by ${scoreChange.toStringAsFixed(1)}%');
      } else if (scoreChange < -10) {
        insights.add('Score decreased by ${scoreChange.abs().toStringAsFixed(1)}%. Consider reviewing weak areas.');
      }
    }
    
    // Exam count insights
    if (examCount > 5) {
      insights.add('High activity period with $examCount exams completed');
    } else if (examCount == 1) {
      insights.add('Single exam completed - consider taking more for better insights');
    }
    
    // Time insights
    if (averageTimePerQuestion != null && averageTimePerQuestion! < 30) {
      insights.add('Fast completion time - excellent time management');
    } else if (averageTimePerQuestion != null && averageTimePerQuestion! > 120) {
      insights.add('Consider practicing for faster completion times');
    }
    
    // Accuracy insights
    final accuracy = getAccuracyPercentage();
    if (accuracy >= 95) {
      insights.add('Outstanding accuracy! Keep up the excellent work');
    } else if (accuracy < 70) {
      insights.add('Focus on accuracy - review incorrect answers');
    }
    
    return insights;
  }

  /// Get chart data point
  ChartDataPoint toChartDataPoint() {
    return ChartDataPoint(
      x: date.millisecondsSinceEpoch.toDouble(),
      y: score,
      label: _getDateLabel(),
      metadata: {
        'examCount': examCount,
        'timeSpent': totalTimeSpent.inMinutes,
        'accuracy': getAccuracyPercentage(),
      },
    );
  }

  /// Get formatted date label based on period
  String _getDateLabel() {
    switch (period) {
      case TrendPeriod.daily:
        return '${date.day}/${date.month}';
      case TrendPeriod.weekly:
        return 'Week ${_getWeekOfYear()}';
      case TrendPeriod.monthly:
        return '${_getMonthName()} ${date.year}';
      case TrendPeriod.yearly:
        return '${date.year}';
    }
  }

  /// Get week of year
  int _getWeekOfYear() {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil();
  }

  /// Get month name
  String _getMonthName() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[date.month - 1];
  }

  @override
  List<Object?> get props => [
        id,
        date,
        score,
        examCount,
        totalTimeSpent,
        category,
        period,
        metadata,
        accuracy,
        questionsAnswered,
        correctAnswers,
        averageTimePerQuestion,
        examIds,
      ];

  @override
  String toString() {
    return 'PerformanceTrend(id: $id, date: $date, score: $score, examCount: $examCount)';
  }
}

/// Chart data point for visualization
class ChartDataPoint extends Equatable {
  final double x;
  final double y;
  final String label;
  final Map<String, dynamic> metadata;

  const ChartDataPoint({
    required this.x,
    required this.y,
    required this.label,
    required this.metadata,
  });

  @override
  List<Object?> get props => [x, y, label, metadata];
}

/// Enum for trend periods
enum TrendPeriod {
  daily,
  weekly,
  monthly,
  yearly,
}

/// Enum for performance ratings
enum PerformanceRating {
  excellent,
  good,
  average,
  belowAverage,
  poor,
}

/// Enum for trend directions
enum TrendDirection {
  improving,
  stable,
  declining,
  neutral,
}

/// Extensions for enums
extension TrendPeriodExtension on TrendPeriod {
  String get displayName {
    switch (this) {
      case TrendPeriod.daily:
        return 'Daily';
      case TrendPeriod.weekly:
        return 'Weekly';
      case TrendPeriod.monthly:
        return 'Monthly';
      case TrendPeriod.yearly:
        return 'Yearly';
    }
  }

  Duration get duration {
    switch (this) {
      case TrendPeriod.daily:
        return const Duration(days: 1);
      case TrendPeriod.weekly:
        return const Duration(days: 7);
      case TrendPeriod.monthly:
        return const Duration(days: 30);
      case TrendPeriod.yearly:
        return const Duration(days: 365);
    }
  }
}

extension PerformanceRatingExtension on PerformanceRating {
  String get displayName {
    switch (this) {
      case PerformanceRating.excellent:
        return 'Excellent';
      case PerformanceRating.good:
        return 'Good';
      case PerformanceRating.average:
        return 'Average';
      case PerformanceRating.belowAverage:
        return 'Below Average';
      case PerformanceRating.poor:
        return 'Needs Improvement';
    }
  }

  String get color {
    switch (this) {
      case PerformanceRating.excellent:
        return '#4CAF50'; // Green
      case PerformanceRating.good:
        return '#8BC34A'; // Light Green
      case PerformanceRating.average:
        return '#FF9800'; // Orange
      case PerformanceRating.belowAverage:
        return '#FF5722'; // Deep Orange
      case PerformanceRating.poor:
        return '#F44336'; // Red
    }
  }
}

extension TrendDirectionExtension on TrendDirection {
  String get displayName {
    switch (this) {
      case TrendDirection.improving:
        return 'Improving';
      case TrendDirection.stable:
        return 'Stable';
      case TrendDirection.declining:
        return 'Declining';
      case TrendDirection.neutral:
        return 'Neutral';
    }
  }

  String get icon {
    switch (this) {
      case TrendDirection.improving:
        return '📈';
      case TrendDirection.stable:
        return '➡️';
      case TrendDirection.declining:
        return '📉';
      case TrendDirection.neutral:
        return '➖';
    }
  }

  String get color {
    switch (this) {
      case TrendDirection.improving:
        return '#4CAF50'; // Green
      case TrendDirection.stable:
        return '#2196F3'; // Blue
      case TrendDirection.declining:
        return '#F44336'; // Red
      case TrendDirection.neutral:
        return '#9E9E9E'; // Grey
    }
  }
}