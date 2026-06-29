import '../repositories/injury_repository.dart';

class DeleteInjuryUseCase {
  final InjuryRepository _repository;

  const DeleteInjuryUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.deleteInjury(id);
  }
}
