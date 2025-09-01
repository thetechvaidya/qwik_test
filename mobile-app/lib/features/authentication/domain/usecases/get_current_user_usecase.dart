import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase implements NoParamsUseCase<User> {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call() async {
    return await _repository.getCurrentUser();
  }
}