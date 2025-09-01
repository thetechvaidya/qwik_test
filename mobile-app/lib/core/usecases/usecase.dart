import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base class for all use cases
/// 
/// [T] is the return type
/// [Params] is the parameter type
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use case that doesn't require any parameters
abstract class NoParamsUseCase<T> {
  Future<Either<Failure, T>> call();
}

/// Class to be used when no parameters are needed
class NoParams {
  const NoParams();
}