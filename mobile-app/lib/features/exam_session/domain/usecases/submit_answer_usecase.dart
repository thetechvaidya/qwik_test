import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/answer.dart';
import '../repositories/exam_session_repository.dart';

/// Use case for submitting an answer to a question in an exam session
class SubmitAnswerUseCase implements UseCase<Answer, SubmitAnswerParams> {
  final ExamSessionRepository _repository;

  SubmitAnswerUseCase(this._repository);

  @override
  Future<Either<Failure, Answer>> call(SubmitAnswerParams params) async {
    return await _repository.submitAnswer(
      sessionId: params.sessionId,
      answer: params.answer,
    );
  }
}

/// Parameters for SubmitAnswerUseCase
class SubmitAnswerParams {
  final String sessionId;
  final Answer answer;

  const SubmitAnswerParams({
    required this.sessionId,
    required this.answer,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubmitAnswerParams &&
        other.sessionId == sessionId &&
        other.answer == answer;
  }

  @override
  int get hashCode => sessionId.hashCode ^ answer.hashCode;

  @override
  String toString() => 'SubmitAnswerParams(sessionId: $sessionId, answer: $answer)';
}