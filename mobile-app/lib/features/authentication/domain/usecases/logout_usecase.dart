import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements NoParamsUseCase<void> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call() async {
    return await _repository.logout();
  }
}