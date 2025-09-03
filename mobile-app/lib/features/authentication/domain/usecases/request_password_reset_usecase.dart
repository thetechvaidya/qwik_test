import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RequestPasswordResetUseCase implements UseCase<void, RequestPasswordResetParams> {
  const RequestPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(RequestPasswordResetParams params) async {
    return await _repository.requestPasswordReset(params.email);
  }
}

class RequestPasswordResetParams extends Equatable {
  const RequestPasswordResetParams({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'RequestPasswordResetParams(email: $email)';
}