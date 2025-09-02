import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sync_status.dart';
import '../repositories/offline_repository.dart';

class GetSyncStatuses implements UseCase<List<SyncStatus>, NoParams> {
  final OfflineRepository repository;

  GetSyncStatuses(this.repository);

  @override
  Future<Either<Failure, List<SyncStatus>>> call(NoParams params) async {
    return await repository.getSyncStatuses();
  }
}