import '../entities/create_injury_dto.dart';
import '../entities/injury_log.dart';
import '../entities/injury_pattern.dart';
import '../entities/paginated_injuries.dart';
import '../entities/update_injury_dto.dart';

abstract class InjuryRepository {
  Future<PaginatedInjuries> getInjuries({
    int page = 1,
    int limit = 10,
    String? sort,
    String? recoveryStatus,
    String? severity,
    String? muscleGroup,
  });

  Future<InjuryLog> getInjuryById(String id);

  Future<InjuryLog> createInjury(CreateInjuryDto dto);

  Future<InjuryLog> updateInjury(String id, UpdateInjuryDto dto);

  Future<void> deleteInjury(String id);

  Future<List<InjuryPattern>> getPatterns();
}
