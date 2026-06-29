import '../../domain/entities/create_injury_dto.dart';
import '../../domain/entities/injury_log.dart';
import '../../domain/entities/injury_pattern.dart';
import '../../domain/entities/paginated_injuries.dart';
import '../../domain/entities/update_injury_dto.dart';
import '../../domain/repositories/injury_repository.dart';
import '../datasource/injury_remote_datasource.dart';
import '../models/injury_log_model.dart';
import '../models/injury_pattern_model.dart';

class InjuryRepositoryImpl implements InjuryRepository {
  const InjuryRepositoryImpl({required InjuryRemoteDataSource dataSource})
    : _dataSource = dataSource;

  final InjuryRemoteDataSource _dataSource;

  @override
  Future<PaginatedInjuries> getInjuries({
    int page = 1,
    int limit = 10,
    String? sort,
    String? recoveryStatus,
    String? severity,
    String? muscleGroup,
  }) async {
    final result = await _dataSource.getInjuries(
      page: page,
      limit: limit,
      sort: sort,
      recoveryStatus: recoveryStatus,
      severity: severity,
      muscleGroup: muscleGroup,
    );

    return PaginatedInjuries(
      injuries: result.injuries.map((m) => m.toEntity()).toList(),
      total: result.total,
    );
  }

  @override
  Future<InjuryLog> getInjuryById(String id) async {
    final model = await _dataSource.getInjuryById(id);
    return model.toEntity();
  }

  @override
  Future<InjuryLog> createInjury(CreateInjuryDto dto) async {
    final model = await _dataSource.createInjury(dto.toJson());
    return model.toEntity();
  }

  @override
  Future<InjuryLog> updateInjury(String id, UpdateInjuryDto dto) async {
    final model = await _dataSource.updateInjury(id, dto.toJson());
    return model.toEntity();
  }

  @override
  Future<void> deleteInjury(String id) async {
    await _dataSource.deleteInjury(id);
  }

  @override
  Future<List<InjuryPattern>> getPatterns() async {
    final models = await _dataSource.getPatterns();
    return models.map((m) => m.toEntity()).toList();
  }
}
