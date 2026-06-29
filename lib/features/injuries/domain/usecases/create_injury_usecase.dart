import '../entities/create_injury_dto.dart';
import '../entities/injury_log.dart';
import '../repositories/injury_repository.dart';

class CreateInjuryUseCase {
  final InjuryRepository _repository;

  const CreateInjuryUseCase(this._repository);

  Future<InjuryLog> call(CreateInjuryDto dto) {
    return _repository.createInjury(dto);
  }
}
