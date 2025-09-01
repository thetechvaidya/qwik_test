import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

/// Use case for getting featured exams
class GetFeaturedExamsUseCase implements UseCase<List<Exam>, GetFeaturedExamsParams> {
  final ExamRepository _repository;

  GetFeaturedExamsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Exam>>> call(GetFeaturedExamsParams params) async {
    return await _repository.getFeaturedExams(limit: params.limit);
  }
}

/// Parameters for GetFeaturedExamsUseCase
class GetFeaturedExamsParams {
  final int limit;

  const GetFeaturedExamsParams({
    this.limit = 10,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetFeaturedExamsParams && other.limit == limit;
  }

  @override
  int get hashCode => limit.hashCode;

  @override
  String toString() => 'GetFeaturedExamsParams(limit: $limit)';
}