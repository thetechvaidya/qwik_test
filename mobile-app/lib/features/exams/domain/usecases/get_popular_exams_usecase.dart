import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

/// Use case for getting popular exams
class GetPopularExamsUseCase implements UseCase<List<Exam>, GetPopularExamsParams> {
  final ExamRepository _repository;

  GetPopularExamsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Exam>>> call(GetPopularExamsParams params) async {
    return await _repository.getPopularExams(limit: params.limit);
  }
}

/// Parameters for GetPopularExamsUseCase
class GetPopularExamsParams {
  final int limit;

  const GetPopularExamsParams({
    this.limit = 10,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetPopularExamsParams && other.limit == limit;
  }

  @override
  int get hashCode => limit.hashCode;

  @override
  String toString() => 'GetPopularExamsParams(limit: $limit)';
}