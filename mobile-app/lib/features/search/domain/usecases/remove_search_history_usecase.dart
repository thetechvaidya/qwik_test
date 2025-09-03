import 'package:dartz/dartz.dart';
import 'package:qwiktest_mobile/core/error/failures.dart';
import 'package:qwiktest_mobile/core/usecases/usecase.dart';
import 'package:qwiktest_mobile/features/search/domain/repositories/search_repository.dart';

class RemoveSearchHistoryUseCase implements UseCase<void, String> {
  final SearchRepository repository;

  RemoveSearchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.removeSearchHistory(params);
  }
}