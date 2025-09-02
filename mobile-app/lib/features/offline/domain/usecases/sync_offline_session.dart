import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/offline_session_upload.dart';
import '../repositories/offline_repository.dart';

class SyncOfflineSession implements UseCase<void, SyncOfflineSessionParams> {
  final OfflineRepository repository;

  SyncOfflineSession(this.repository);

  @override
  Future<Either<Failure, void>> call(SyncOfflineSessionParams params) async {
    return await repository.syncOfflineSession(params.session);
  }
}

class SyncOfflineSessionParams {
  final OfflineSessionUpload session;

  SyncOfflineSessionParams({required this.session});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncOfflineSessionParams && other.session == session;
  }

  @override
  int get hashCode => session.hashCode;
}