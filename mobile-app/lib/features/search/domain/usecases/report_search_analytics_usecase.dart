import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

/// Use case for reporting search analytics
class ReportSearchAnalyticsUseCase implements UseCase<void, ReportSearchAnalyticsParams> {
  final SearchRepository _repository;

  ReportSearchAnalyticsUseCase({required SearchRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(ReportSearchAnalyticsParams params) async {
    try {
      await _repository.reportSearchAnalytics(
        query: params.query,
        categoryId: params.categoryId,
        resultCount: params.resultCount,
        hasResults: params.hasResults,
      );
      return const Right(null);
    } catch (e) {
      // Analytics failures should not affect the user experience
      return const Right(null);
    }
  }
}

/// Parameters for reporting search analytics
class ReportSearchAnalyticsParams {
  final String query;
  final String? categoryId;
  final int? resultCount;
  final bool? hasResults;

  const ReportSearchAnalyticsParams({
    required this.query,
    this.categoryId,
    this.resultCount,
    this.hasResults,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReportSearchAnalyticsParams &&
        other.query == query &&
        other.categoryId == categoryId &&
        other.resultCount == resultCount &&
        other.hasResults == hasResults;
  }

  @override
  int get hashCode => Object.hash(query, categoryId, resultCount, hasResults);

  @override
  String toString() => 'ReportSearchAnalyticsParams(query: $query, categoryId: $categoryId, resultCount: $resultCount, hasResults: $hasResults)';
}