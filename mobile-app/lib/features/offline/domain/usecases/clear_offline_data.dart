import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/offline_repository.dart';

class ClearOfflineData implements UseCase<void, ClearOfflineDataParams> {
  final OfflineRepository repository;

  ClearOfflineData(this.repository);

  @override
  Future<Either<Failure, void>> call(ClearOfflineDataParams params) async {
    if (params.clearAll) {
      return await repository.clearAllOfflineData();
    } else {
      return await repository.clearExpiredExams();
    }
  }
}

class ClearOfflineDataParams {
  final bool clearAll;

  ClearOfflineDataParams({required this.clearAll});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClearOfflineDataParams && other.clearAll == clearAll;
  }

  @override
  int get hashCode => clearAll.hashCode;
}