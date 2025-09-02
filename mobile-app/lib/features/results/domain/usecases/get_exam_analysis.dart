import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/results_repository.dart';

class GetExamAnalysis implements UseCase<Map<String, dynamic>, GetExamAnalysisParams> {
  final ResultsRepository repository;

  GetExamAnalysis(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(GetExamAnalysisParams params) async {
    return await repository.getExamAnalysis(
      params.userId,
      params.examId,
    );
  }
}

class GetExamAnalysisParams {
  final String userId;
  final String examId;

  GetExamAnalysisParams({
    required this.userId,
    required this.examId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetExamAnalysisParams &&
        other.userId == userId &&
        other.examId == examId;
  }

  @override
  int get hashCode => Object.hash(userId, examId);
}