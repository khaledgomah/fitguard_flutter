import '../entities/injury_log.dart';
import '../repositories/injury_repository.dart';

class GetInjuryByIdUseCase {
  final InjuryRepository _repository;

  const GetInjuryByIdUseCase(this._repository);

  Future<InjuryLog> call(String id) {
    return _repository.getInjuryById(id);
  }
}
