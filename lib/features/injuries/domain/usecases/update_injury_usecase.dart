import '../entities/injury_log.dart';
import '../entities/update_injury_dto.dart';
import '../repositories/injury_repository.dart';

class UpdateInjuryUseCase {
  final InjuryRepository _repository;

  const UpdateInjuryUseCase(this._repository);

  Future<InjuryLog> call(String id, UpdateInjuryDto dto) {
    return _repository.updateInjury(id, dto);
  }
}
