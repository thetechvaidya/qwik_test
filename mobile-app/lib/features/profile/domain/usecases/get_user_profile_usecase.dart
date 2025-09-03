import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase implements UseCase<UserProfile, GetUserProfileParams> {
  const GetUserProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, UserProfile>> call(GetUserProfileParams params) async {
    if (params.userId != null) {
      return await _repository.getUserProfile(params.userId!);
    } else {
      return await _repository.getCurrentUserProfile();
    }
  }
}

class GetUserProfileParams extends Equatable {
  const GetUserProfileParams({
    this.userId,
  });

  final String? userId;

  @override
  List<Object?> get props => [userId];

  @override
  String toString() => 'GetUserProfileParams(userId: $userId)';
}