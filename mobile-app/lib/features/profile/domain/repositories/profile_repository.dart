import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';



abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile(String userId);
  Future<Either<Failure, UserProfile>> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  );
  Future<Either<Failure, String>> uploadAvatar(
    String userId,
    String imagePath,
  );
  Future<Either<Failure, void>> deleteAvatar(String userId);


  Future<Either<Failure, List<UserProfile>>> searchUsers(
    String query, {
    int page = 1,
    int limit = 20,
  });
}