import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/offline_exam.dart';
import '../repositories/offline_repository.dart';

class DownloadOfflineExam implements UseCase<OfflineExam, DownloadOfflineExamParams> {
  final OfflineRepository repository;

  DownloadOfflineExam(this.repository);

  @override
  Future<Either<Failure, OfflineExam>> call(DownloadOfflineExamParams params) async {
    return await repository.downloadExam(params.examId);
  }
}

class DownloadOfflineExamParams {
  final String examId;

  DownloadOfflineExamParams({required this.examId});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DownloadOfflineExamParams && other.examId == examId;
  }

  @override
  int get hashCode => examId.hashCode;
}