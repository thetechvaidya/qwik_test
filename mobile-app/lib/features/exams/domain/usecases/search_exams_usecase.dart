import 'package:dartz/dartz.dart';
import 'package:qwiktest_mobile/core/error/failures.dart';
import 'package:qwiktest_mobile/core/usecases/usecase.dart';
import 'package:qwiktest_mobile/features/exams/domain/entities/exam.dart';
import 'package:qwiktest_mobile/features/exams/domain/repositories/exams_repository.dart';

class SearchExamsUseCase implements UseCase<List<Exam>, String> {
  final ExamsRepository repository;

  SearchExamsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Exam>>> call(String params) async {
    return await repository.searchExams(params);
  }
}