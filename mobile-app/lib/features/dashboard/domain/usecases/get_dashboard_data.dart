import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardData implements UseCase<DashboardData, GetDashboardDataParams> {
  final DashboardRepository repository;

  GetDashboardData(this.repository);

  @override
  Future<Either<Failure, DashboardData>> call(GetDashboardDataParams params) async {
    return await repository.getDashboardData(params.userId);
  }
}

class GetDashboardDataParams {
  final String userId;

  GetDashboardDataParams({required this.userId});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetDashboardDataParams && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}