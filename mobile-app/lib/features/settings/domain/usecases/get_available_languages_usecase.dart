import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

class GetAvailableLanguagesUseCase implements NoParamsUseCase<List<String>> {
  const GetAvailableLanguagesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, List<String>>> call() async {
    return await _repository.getAvailableLanguages();
  }
}