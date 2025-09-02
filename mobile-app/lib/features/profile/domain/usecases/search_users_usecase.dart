import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class SearchUsersUseCase implements UseCase<List<UserProfile>, SearchUsersParams> {
  const SearchUsersUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, List<UserProfile>>> call(SearchUsersParams params) async {
    return await _repository.searchUsers(params.query, params.page, params.limit);
  }
}

class SearchUsersParams extends Equatable {
  const SearchUsersParams({
    required this.query,
    this.page = 1,
    this.limit = 20,
  });

  final String query;
  final int page;
  final int limit;

  @override
  List<Object> get props => [query, page, limit];

  @override
  String toString() => 'SearchUsersParams(query: $query, page: $page, limit: $limit)';
}