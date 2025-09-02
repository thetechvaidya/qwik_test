import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

class GetAvailableThemesUseCase implements NoParamsUseCase<List<String>> {
  const GetAvailableThemesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, List<String>>> call() async {
    return await _repository.getAvailableThemes();
  }
}