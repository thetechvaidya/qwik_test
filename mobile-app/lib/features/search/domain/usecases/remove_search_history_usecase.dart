import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

/// Use case for removing a specific search history item
class RemoveSearchHistoryUseCase implements UseCase<void, RemoveSearchHistoryParams> {
  final SearchRepository repository;

  RemoveSearchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveSearchHistoryParams params) async {
    return await repository.removeSearchHistory(params.historyId);
  }
}

/// Parameters for removing search history
class RemoveSearchHistoryParams {
  final String historyId;

  const RemoveSearchHistoryParams({
    required this.historyId,
  });
}