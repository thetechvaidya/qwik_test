import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/offline_exam.dart';
import '../repositories/offline_repository.dart';

class GetOfflineExam implements UseCase<OfflineExam?, GetOfflineExamParams> {
  final OfflineRepository repository;

  GetOfflineExam(this.repository);

  @override
  Future<Either<Failure, OfflineExam?>> call(GetOfflineExamParams params) async {
    return await repository.getOfflineExam(params.examId);
  }
}

class GetOfflineExamParams {
  final String examId;

  GetOfflineExamParams({required this.examId});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetOfflineExamParams && other.examId == examId;
  }

  @override
  int get hashCode => examId.hashCode;
}