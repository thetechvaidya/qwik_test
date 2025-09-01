import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

/// Use case for getting recent exams
class GetRecentExamsUseCase implements UseCase<List<Exam>, GetRecentExamsParams> {
  final ExamRepository _repository;

  GetRecentExamsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Exam>>> call(GetRecentExamsParams params) async {
    return await _repository.getRecentExams(limit: params.limit);
  }
}

/// Parameters for GetRecentExamsUseCase
class GetRecentExamsParams {
  final int limit;

  const GetRecentExamsParams({
    this.limit = 10,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetRecentExamsParams && other.limit == limit;
  }

  @override
  int get hashCode => limit.hashCode;

  @override
  String toString() => 'GetRecentExamsParams(limit: $limit)';
}