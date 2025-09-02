import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/results_repository.dart';

class GetStudyRecommendations implements UseCase<Map<String, dynamic>, GetStudyRecommendationsParams> {
  final ResultsRepository repository;

  GetStudyRecommendations(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(GetStudyRecommendationsParams params) async {
    return await repository.getStudyRecommendations(
      params.userId,
      subject: params.subject,
      weakAreas: params.weakAreas,
      limit: params.limit,
    );
  }
}

class GetStudyRecommendationsParams {
  final String userId;
  final String? subject;
  final List<String>? weakAreas;
  final int? limit;

  GetStudyRecommendationsParams({
    required this.userId,
    this.subject,
    this.weakAreas,
    this.limit,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetStudyRecommendationsParams &&
        other.userId == userId &&
        other.subject == subject &&
        _listEquals(other.weakAreas, weakAreas) &&
        other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(userId, subject, weakAreas, limit);

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}