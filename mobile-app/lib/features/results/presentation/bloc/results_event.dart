import 'package:equatable/equatable.dart';
import '../../domain/entities/exam_result.dart';

abstract class ResultsEvent extends Equatable {
  const ResultsEvent();

  @override
  List<Object?> get props => [];
}

class LoadExamResults extends ResultsEvent {
  final String userId;
  final String? examId;
  final String? subject;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final int? offset;

  const LoadExamResults({
    required this.userId,
    this.examId,
    this.subject,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [
        userId,
        examId,
        subject,
        startDate,
        endDate,
        limit,
        offset,
      ];
}

class SubmitExamResultEvent extends ResultsEvent {
  final String userId;
  final ExamResult examResult;

  const SubmitExamResultEvent({
    required this.userId,
    required this.examResult,
  });

  @override
  List<Object?> get props => [userId, examResult];
}

class LoadQuestionResults extends ResultsEvent {
  final String userId;
  final String? examId;
  final String? questionId;
  final String? topic;
  final String? difficulty;
  final bool? isCorrect;
  final int? limit;
  final int? offset;

  const LoadQuestionResults({
    required this.userId,
    this.examId,
    this.questionId,
    this.topic,
    this.difficulty,
    this.isCorrect,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [
        userId,
        examId,
        questionId,
        topic,
        difficulty,
        isCorrect,
        limit,
        offset,
      ];
}

class LoadPerformanceAnalytics extends ResultsEvent {
  final String userId;
  final String? period;
  final String? subject;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadPerformanceAnalytics({
    required this.userId,
    this.period,
    this.subject,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, period, subject, startDate, endDate];
}

class LoadExamAnalysis extends ResultsEvent {
  final String userId;
  final String examId;

  const LoadExamAnalysis({
    required this.userId,
    required this.examId,
  });

  @override
  List<Object?> get props => [userId, examId];
}

class LoadStudyRecommendations extends ResultsEvent {
  final String userId;
  final String? subject;
  final List<String>? weakAreas;
  final int? limit;

  const LoadStudyRecommendations({
    required this.userId,
    this.subject,
    this.weakAreas,
    this.limit,
  });

  @override
  List<Object?> get props => [userId, subject, weakAreas, limit];
}

class RefreshResults extends ResultsEvent {
  final String userId;

  const RefreshResults({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ClearResultsCache extends ResultsEvent {
  const ClearResultsCache();
}

class FilterExamResults extends ResultsEvent {
  final String? subject;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minScore;
  final double? maxScore;

  const FilterExamResults({
    this.subject,
    this.startDate,
    this.endDate,
    this.minScore,
    this.maxScore,
  });

  @override
  List<Object?> get props => [subject, startDate, endDate, minScore, maxScore];
}

class SortExamResults extends ResultsEvent {
  final String sortBy; // 'date', 'score', 'subject'
  final bool ascending;

  const SortExamResults({
    required this.sortBy,
    this.ascending = true,
  });

  @override
  List<Object?> get props => [sortBy, ascending];
}