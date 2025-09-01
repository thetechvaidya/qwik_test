import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

/// Use case for getting exam details by ID
class GetExamDetailUseCase implements UseCase<Exam, GetExamDetailParams> {
  final ExamRepository _repository;

  GetExamDetailUseCase(this._repository);

  @override
  Future<Either<Failure, Exam>> call(GetExamDetailParams params) async {
    return await _repository.getExamById(params.examId);
  }
}

/// Parameters for GetExamDetailUseCase
class GetExamDetailParams {
  final String examId;

  const GetExamDetailParams({
    required this.examId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetExamDetailParams && other.examId == examId;
  }

  @override
  int get hashCode => examId.hashCode;

  @override
  String toString() => 'GetExamDetailParams(examId: $examId)';
}