import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class UploadAvatarUseCase implements UseCase<String, UploadAvatarParams> {
  const UploadAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, String>> call(UploadAvatarParams params) async {
    return await _repository.uploadAvatar(params.userId, params.imagePath);
  }
}

class UploadAvatarParams extends Equatable {
  const UploadAvatarParams({
    required this.userId,
    required this.imagePath,
  });

  final String userId;
  final String imagePath;

  @override
  List<Object> get props => [userId, imagePath];

  @override
  String toString() => 'UploadAvatarParams(userId: $userId, imagePath: $imagePath)';
}