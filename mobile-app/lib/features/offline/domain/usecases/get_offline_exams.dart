import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/offline_exam.dart';
import '../repositories/offline_repository.dart';

class GetOfflineExams implements UseCase<List<OfflineExam>, NoParams> {
  final OfflineRepository repository;

  GetOfflineExams(this.repository);

  @override
  Future<Either<Failure, List<OfflineExam>>> call(NoParams params) async {
    return await repository.getOfflineExams();
  }
}