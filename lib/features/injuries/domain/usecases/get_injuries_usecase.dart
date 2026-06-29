import '../entities/paginated_injuries.dart';
import '../repositories/injury_repository.dart';

class GetInjuriesUseCase {
  final InjuryRepository _repository;

  const GetInjuriesUseCase(this._repository);

  Future<PaginatedInjuries> call({
    int page = 1,
    int limit = 10,
    String? sort,
    String? recoveryStatus,
    String? severity,
    String? muscleGroup,
  }) {
    return _repository.getInjuries(
      page: page,
      limit: limit,
      sort: sort,
      recoveryStatus: recoveryStatus,
      severity: severity,
      muscleGroup: muscleGroup,
    );
  }
}
