import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/create_injury_dto.dart';
import '../../domain/entities/update_injury_dto.dart';
import '../../domain/usecases/create_injury_usecase.dart';
import '../../domain/usecases/delete_injury_usecase.dart';
import '../../domain/usecases/get_injuries_usecase.dart';
import '../../domain/usecases/get_injury_by_id_usecase.dart';
import '../../domain/usecases/get_injury_patterns_usecase.dart';
import '../../domain/usecases/update_injury_usecase.dart';
import 'injury_state.dart';

class InjuryCubit extends Cubit<InjuryState> {
  final GetInjuriesUseCase _getInjuriesUseCase;
  final GetInjuryByIdUseCase _getInjuryByIdUseCase;
  final CreateInjuryUseCase _createInjuryUseCase;
  final UpdateInjuryUseCase _updateInjuryUseCase;
  final DeleteInjuryUseCase _deleteInjuryUseCase;
  final GetInjuryPatternsUseCase _getInjuryPatternsUseCase;

  InjuryCubit({
    required GetInjuriesUseCase getInjuriesUseCase,
    required GetInjuryByIdUseCase getInjuryByIdUseCase,
    required CreateInjuryUseCase createInjuryUseCase,
    required UpdateInjuryUseCase updateInjuryUseCase,
    required DeleteInjuryUseCase deleteInjuryUseCase,
    required GetInjuryPatternsUseCase getInjuryPatternsUseCase,
  })  : _getInjuriesUseCase = getInjuriesUseCase,
        _getInjuryByIdUseCase = getInjuryByIdUseCase,
        _createInjuryUseCase = createInjuryUseCase,
        _updateInjuryUseCase = updateInjuryUseCase,
        _deleteInjuryUseCase = deleteInjuryUseCase,
        _getInjuryPatternsUseCase = getInjuryPatternsUseCase,
        super(InjuryInitial());

  Future<void> getInjuries({
    int page = 1,
    int limit = 10,
    String? sort,
    String? recoveryStatus,
    String? severity,
    String? muscleGroup,
  }) async {
    emit(InjuryLoading());
    try {
      final result = await _getInjuriesUseCase(
        page: page,
        limit: limit,
        sort: sort,
        recoveryStatus: recoveryStatus,
        severity: severity,
        muscleGroup: muscleGroup,
      );
      emit(InjuriesLoaded(injuries: result.injuries, total: result.total));
    } catch (e) {
      emit(InjuryError(_formatError(e)));
    }
  }

  Future<void> getInjuryById(String id) async {
    emit(InjuryLoading());
    try {
      final injury = await _getInjuryByIdUseCase(id);
      emit(InjuryDetailLoaded(injury));
    } catch (e) {
      emit(InjuryError(_formatError(e)));
    }
  }

  Future<void> createInjury(CreateInjuryDto dto) async {
    emit(InjuryLoading());
    try {
      final injury = await _createInjuryUseCase(dto);
      emit(InjurySuccess(injury));
    } catch (e) {
      emit(InjuryError(_formatError(e)));
    }
  }

  Future<void> updateInjury(String id, UpdateInjuryDto dto) async {
    emit(InjuryLoading());
    try {
      final injury = await _updateInjuryUseCase(id, dto);
      emit(InjurySuccess(injury));
    } catch (e) {
      emit(InjuryError(_formatError(e)));
    }
  }

  Future<void> deleteInjury(String id) async {
    emit(InjuryLoading());
    try {
      await _deleteInjuryUseCase(id);
      emit(const InjuriesLoaded(injuries: [], total: 0));
    } catch (e) {
      emit(InjuryError(_formatError(e)));
    }
  }

  Future<void> getPatterns() async {
    emit(InjuryLoading());
    try {
      final patterns = await _getInjuryPatternsUseCase();
      emit(InjuryPatternsLoaded(patterns));
    } catch (e) {
      emit(InjuryError(_formatError(e)));
    }
  }

  String _formatError(Object e) {
    final msg = e.toString();
    return msg.replaceAll('Exception: ', '');
  }
}
