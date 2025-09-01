import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam_session.dart';
import '../repositories/exam_session_repository.dart';

/// Use case for updating exam session progress and state
class UpdateExamSessionUseCase implements UseCase<ExamSession, UpdateExamSessionParams> {
  final ExamSessionRepository _repository;

  UpdateExamSessionUseCase(this._repository);

  @override
  Future<Either<Failure, ExamSession>> call(UpdateExamSessionParams params) async {
    return await _repository.updateExamSession(
      sessionId: params.sessionId,
      updates: params.updates,
    );
  }
}

/// Parameters for UpdateExamSessionUseCase
class UpdateExamSessionParams {
  final String sessionId;
  final Map<String, dynamic> updates;

  const UpdateExamSessionParams({
    required this.sessionId,
    required this.updates,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateExamSessionParams &&
        other.sessionId == sessionId &&
        _mapEquals(other.updates, updates);
  }

  @override
  int get hashCode => sessionId.hashCode ^ updates.hashCode;

  @override
  String toString() => 'UpdateExamSessionParams(sessionId: $sessionId, updates: $updates)';

  /// Helper method to compare maps
  bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}