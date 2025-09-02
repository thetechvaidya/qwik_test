import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

/// Use case for clearing all search history
class ClearSearchHistoryUseCase implements UseCase<void, NoParams> {
  final SearchRepository repository;

  ClearSearchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearSearchHistory();
  }
}