import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/results_repository.dart';

class GetPerformanceAnalytics implements UseCase<Map<String, dynamic>, GetPerformanceAnalyticsParams> {
  final ResultsRepository repository;

  GetPerformanceAnalytics(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(GetPerformanceAnalyticsParams params) async {
    return await repository.getPerformanceAnalytics(
      params.userId,
      period: params.period,
      subject: params.subject,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetPerformanceAnalyticsParams {
  final String userId;
  final String? period;
  final String? subject;
  final DateTime? startDate;
  final DateTime? endDate;

  GetPerformanceAnalyticsParams({
    required this.userId,
    this.period,
    this.subject,
    this.startDate,
    this.endDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetPerformanceAnalyticsParams &&
        other.userId == userId &&
        other.period == period &&
        other.subject == subject &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => Object.hash(userId, period, subject, startDate, endDate);
}