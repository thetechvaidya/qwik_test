import 'package:dartz/dartz.dart';
import 'package:qwiktest_mobile/core/error/failures.dart';
import 'package:qwiktest_mobile/core/usecases/usecase.dart';
import 'package:qwiktest_mobile/features/search/domain/repositories/search_repository.dart';

class ClearSearchHistoryUseCase implements UseCase<void, NoParams> {
  final SearchRepository repository;

  ClearSearchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearSearchHistory();
  }
}