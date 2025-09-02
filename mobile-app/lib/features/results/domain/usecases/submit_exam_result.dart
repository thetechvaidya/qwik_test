import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam_result.dart';
import '../repositories/results_repository.dart';

class SubmitExamResult implements UseCase<ExamResult, SubmitExamResultParams> {
  final ResultsRepository repository;

  SubmitExamResult(this.repository);

  @override
  Future<Either<Failure, ExamResult>> call(SubmitExamResultParams params) async {
    return await repository.submitExamResult(
      params.userId,
      params.examResult,
    );
  }
}

class SubmitExamResultParams {
  final String userId;
  final ExamResult examResult;

  SubmitExamResultParams({
    required this.userId,
    required this.examResult,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubmitExamResultParams &&
        other.userId == userId &&
        other.examResult == examResult;
  }

  @override
  int get hashCode => Object.hash(userId, examResult);
}