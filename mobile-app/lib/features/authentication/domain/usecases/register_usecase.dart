import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  @override
  List<Object> get props => [name, email, password, passwordConfirmation];

  @override
  String toString() => 'RegisterParams(name: $name, email: $email, password: [HIDDEN], passwordConfirmation: [HIDDEN])';
}