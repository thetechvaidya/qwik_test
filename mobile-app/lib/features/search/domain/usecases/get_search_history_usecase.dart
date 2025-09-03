import 'package:dartz/dartz.dart';
import 'package:qwiktest_mobile/core/error/failures.dart';
import 'package:qwiktest_mobile/core/usecases/usecase.dart';
import 'package:qwiktest_mobile/features/search/domain/repositories/search_repository.dart';

class GetSearchHistoryUseCase implements UseCase<List<String>, NoParams> {
  final SearchRepository repository;

  GetSearchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getSearchHistory();
  }
}