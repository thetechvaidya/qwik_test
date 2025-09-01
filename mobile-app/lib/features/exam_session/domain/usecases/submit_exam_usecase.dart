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
      forceSubmit: params.forceSubmit,
    );
  }
}

/// Parameters for SubmitExamUseCase
class SubmitExamParams {
  final String sessionId;
  final bool forceSubmit;

  const SubmitExamParams({
    required this.sessionId,
    this.forceSubmit = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubmitExamParams &&
        other.sessionId == sessionId &&
        other.forceSubmit == forceSubmit;
  }

  @override
  int get hashCode => sessionId.hashCode ^ forceSubmit.hashCode;

  @override
  String toString() => 'SubmitExamParams(sessionId: $sessionId, forceSubmit: $forceSubmit)';
}