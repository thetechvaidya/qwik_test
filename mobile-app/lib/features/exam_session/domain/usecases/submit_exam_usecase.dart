import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam_session.dart';
import '../repositories/exam_session_repository.dart';

/// Use case for submitting a completed exam session
class SubmitExamUseCase implements UseCase<ExamSession, SubmitExamParams> {
  final ExamSessionRepository _repository;

  SubmitExamUseCase(this._repository);

  @override
  Future<Either<Failure, ExamSession>> call(SubmitExamParams params) async {
    return await _repository.submitExamSession(
      sessionId: params.sessionId,
    );
  }
}

/// Parameters for SubmitExamUseCase
class SubmitExamParams {
  final String sessionId;

  const SubmitExamParams({
    required this.sessionId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubmitExamParams &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode => sessionId.hashCode;

  @override
  String toString() => 'SubmitExamParams(sessionId: $sessionId)';
}