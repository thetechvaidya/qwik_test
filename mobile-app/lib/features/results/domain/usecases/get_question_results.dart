import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/question_result.dart';
import '../repositories/results_repository.dart';

class GetQuestionResults implements UseCase<List<QuestionResult>, GetQuestionResultsParams> {
  final ResultsRepository repository;

  GetQuestionResults(this.repository);

  @override
  Future<Either<Failure, List<QuestionResult>>> call(GetQuestionResultsParams params) async {
    return await repository.getQuestionResults(
      params.userId,
      examId: params.examId,
      questionId: params.questionId,
      topic: params.topic,
      difficulty: params.difficulty,
      isCorrect: params.isCorrect,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetQuestionResultsParams {
  final String userId;
  final String? examId;
  final String? questionId;
  final String? topic;
  final String? difficulty;
  final bool? isCorrect;
  final int? limit;
  final int? offset;

  GetQuestionResultsParams({
    required this.userId,
    this.examId,
    this.questionId,
    this.topic,
    this.difficulty,
    this.isCorrect,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetQuestionResultsParams &&
        other.userId == userId &&
        other.examId == examId &&
        other.questionId == questionId &&
        other.topic == topic &&
        other.difficulty == difficulty &&
        other.isCorrect == isCorrect &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(
        userId,
        examId,
        questionId,
        topic,
        difficulty,
        isCorrect,
        limit,
        offset,
      );
}