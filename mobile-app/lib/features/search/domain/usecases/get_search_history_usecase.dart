import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../exams/domain/entities/search_history.dart';
import '../repositories/search_repository.dart';

/// Use case for getting search history
class GetSearchHistoryUseCase implements UseCase<List<SearchHistory>, GetSearchHistoryParams> {
  final SearchRepository repository;

  GetSearchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<SearchHistory>>> call(GetSearchHistoryParams params) async {
    return await repository.getSearchHistory(
      limit: params.limit,
      category: params.category,
    );
  }
}

/// Parameters for getting search history
class GetSearchHistoryParams {
  final int limit;
  final String? category;

  const GetSearchHistoryParams({
    this.limit = 20,
    this.category,
  });
}