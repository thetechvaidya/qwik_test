import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

/// Use case for refreshing authentication token
class RefreshTokenUseCase implements UseCase<AuthToken, NoParams> {
  const RefreshTokenUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthToken>> call(NoParams params) async {
    return await _repository.refreshToken();
  }
}