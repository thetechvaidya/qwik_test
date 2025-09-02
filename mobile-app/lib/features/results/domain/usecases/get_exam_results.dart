import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam_result.dart';
import '../repositories/results_repository.dart';

class GetExamResults implements UseCase<List<ExamResult>, GetExamResultsParams> {
  final ResultsRepository repository;

  GetExamResults(this.repository);

  @override
  Future<Either<Failure, List<ExamResult>>> call(GetExamResultsParams params) async {
    return await repository.getExamResults(
      params.userId,
      examId: params.examId,
      subject: params.subject,
      startDate: params.startDate,
      endDate: params.endDate,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetExamResultsParams {
  final String userId;
  final String? examId;
  final String? subject;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final int? offset;

  GetExamResultsParams({
    required this.userId,
    this.examId,
    this.subject,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetExamResultsParams &&
        other.userId == userId &&
        other.examId == examId &&
        other.subject == subject &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(
        userId,
        examId,
        subject,
        startDate,
        endDate,
        limit,
        offset,
      );
}