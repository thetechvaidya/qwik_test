import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/exam_session_repository.dart';

/// Use case for abandoning an exam session
class AbandonExamSessionUseCase implements UseCase<void, AbandonExamSessionParams> {
  final ExamSessionRepository _repository;

  AbandonExamSessionUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(AbandonExamSessionParams params) async {
    return await _repository.abandonExamSession(
      sessionId: params.sessionId,
      reason: params.reason,
    );
  }
}

/// Parameters for AbandonExamSessionUseCase
class AbandonExamSessionParams {
  final String sessionId;
  final String? reason;

  const AbandonExamSessionParams({
    required this.sessionId,
    this.reason,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AbandonExamSessionParams &&
        other.sessionId == sessionId &&
        other.reason == reason;
  }

  @override
  int get hashCode => sessionId.hashCode ^ reason.hashCode;

  @override
  String toString() => 'AbandonExamSessionParams(sessionId: $sessionId, reason: $reason)';
}