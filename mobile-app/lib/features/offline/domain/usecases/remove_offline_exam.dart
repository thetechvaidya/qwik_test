import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/offline_repository.dart';

class RemoveOfflineExam implements UseCase<void, RemoveOfflineExamParams> {
  final OfflineRepository repository;

  RemoveOfflineExam(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveOfflineExamParams params) async {
    return await repository.removeOfflineExam(params.examId);
  }
}

class RemoveOfflineExamParams {
  final String examId;

  RemoveOfflineExamParams({required this.examId});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RemoveOfflineExamParams && other.examId == examId;
  }

  @override
  int get hashCode => examId.hashCode;
}