import '../entities/injury_pattern.dart';
import '../repositories/injury_repository.dart';

class GetInjuryPatternsUseCase {
  final InjuryRepository _repository;

  const GetInjuryPatternsUseCase(this._repository);

  Future<List<InjuryPattern>> call() {
    return _repository.getPatterns();
  }
}
