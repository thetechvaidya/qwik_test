import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase implements UseCase<UserProfile, UpdateUserProfileParams> {
  const UpdateUserProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, UserProfile>> call(UpdateUserProfileParams params) async {
    return await _repository.updateUserProfile(params.userId, params.updates);
  }
}

class UpdateUserProfileParams extends Equatable {
  const UpdateUserProfileParams({
    required this.userId,
    required this.updates,
  });

  final String userId;
  final Map<String, dynamic> updates;

  @override
  List<Object> get props => [userId, updates];

  @override
  String toString() => 'UpdateUserProfileParams(userId: $userId, updates: $updates)';
}