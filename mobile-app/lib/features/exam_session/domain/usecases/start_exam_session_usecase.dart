import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exam_session.dart';
import '../repositories/exam_session_repository.dart';

/// Use case for starting a new exam session
class StartExamSessionUseCase implements UseCase<ExamSession, StartExamSessionParams> {
  final ExamSessionRepository _repository;

  StartExamSessionUseCase(this._repository);

  @override
  Future<Either<Failure, ExamSession>> call(StartExamSessionParams params) async {
    return await _repository.startExamSession(
      examId: params.examId,
      settings: params.settings,
    );
  }
}

/// Parameters for StartExamSessionUseCase
class StartExamSessionParams {
  final String examId;
  final Map<String, dynamic>? settings;

  const StartExamSessionParams({
    required this.examId,
    this.settings,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StartExamSessionParams &&
        other.examId == examId &&
        _mapEquals(other.settings, settings);
  }

  @override
  int get hashCode => examId.hashCode ^ settings.hashCode;

  @override
  String toString() => 'StartExamSessionParams(examId: $examId, settings: $settings)';

  /// Helper method to compare maps
  bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}