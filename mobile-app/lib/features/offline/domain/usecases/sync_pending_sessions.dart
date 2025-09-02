import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/offline_repository.dart';

class SyncPendingSessions implements UseCase<void, NoParams> {
  final OfflineRepository repository;

  SyncPendingSessions(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.syncPendingSessions();
  }
}