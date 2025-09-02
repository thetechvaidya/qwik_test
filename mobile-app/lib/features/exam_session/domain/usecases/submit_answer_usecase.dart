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
      questionId: params.questionId,
      selectedOptionIds: params.selectedOptionIds,
      timeSpent: params.timeSpent,
    );
  }
}

/// Parameters for SubmitAnswerUseCase
class SubmitAnswerParams {
  final String sessionId;
  final String questionId;
  final List<String> selectedOptionIds;
  final int timeSpent;

  const SubmitAnswerParams({
    required this.sessionId,
    required this.questionId,
    required this.selectedOptionIds,
    required this.timeSpent,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubmitAnswerParams &&
        other.sessionId == sessionId &&
        other.questionId == questionId &&
        other.selectedOptionIds == selectedOptionIds &&
        other.timeSpent == timeSpent;
  }

  @override
  int get hashCode => Object.hash(sessionId, questionId, selectedOptionIds, timeSpent);

  @override
  String toString() => 'SubmitAnswerParams(sessionId: $sessionId, questionId: $questionId, selectedOptionIds: $selectedOptionIds, timeSpent: $timeSpent)';
}