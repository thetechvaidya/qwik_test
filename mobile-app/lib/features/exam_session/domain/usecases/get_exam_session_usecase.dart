import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam_session.dart';
import '../repositories/exam_session_repository.dart';

/// Use case for getting exam session details by session ID
class GetExamSessionUseCase implements UseCase<ExamSession, GetExamSessionParams> {
  final ExamSessionRepository _repository;

  GetExamSessionUseCase(this._repository);

  @override
  Future<Either<Failure, ExamSession>> call(GetExamSessionParams params) async {
    return await _repository.getExamSession(params.sessionId);
  }
}

/// Parameters for GetExamSessionUseCase
class GetExamSessionParams {
  final String sessionId;

  const GetExamSessionParams({
    required this.sessionId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetExamSessionParams && other.sessionId == sessionId;
  }

  @override
  int get hashCode => sessionId.hashCode;

  @override
  String toString() => 'GetExamSessionParams(sessionId: $sessionId)';
}