import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/performance_trend.dart';
import '../repositories/dashboard_repository.dart';

class GetPerformanceTrends implements UseCase<List<PerformanceTrend>, GetPerformanceTrendsParams> {
  final DashboardRepository repository;

  GetPerformanceTrends(this.repository);

  @override
  Future<Either<Failure, List<PerformanceTrend>>> call(GetPerformanceTrendsParams params) async {
    return await repository.getPerformanceTrends(
      params.userId,
      period: params.period,
      subject: params.subject,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetPerformanceTrendsParams {
  final String userId;
  final String? period;
  final String? subject;
  final DateTime? startDate;
  final DateTime? endDate;

  GetPerformanceTrendsParams({
    required this.userId,
    this.period,
    this.subject,
    this.startDate,
    this.endDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetPerformanceTrendsParams &&
        other.userId == userId &&
        other.period == period &&
        other.subject == subject &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => Object.hash(userId, period, subject, startDate, endDate);
}