import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/recovery_repository.dart';
import 'recovery_state.dart';

class RecoveryCubit extends Cubit<RecoveryState> {
  final RecoveryRepository repository;

  RecoveryCubit({required this.repository}) : super(RecoveryInitial());

  Future<void> fetchActiveProtocol() async {
    emit(RecoveryLoading());
    try {
      final protocol = await repository.getActiveProtocol();
      emit(RecoveryLoaded(activeProtocol: protocol));
    } catch (e) {
      emit(RecoveryError(e.toString()));
    }
  }

  Future<void> completePhase(String id, int phaseNumber) async {
    if (state is RecoveryLoaded) {
      try {
        await repository.completePhase(id, phaseNumber);
        await fetchActiveProtocol(); // Re-fetch to update state
      } catch (e) {
        emit(RecoveryError(e.toString()));
      }
    }
  }

  Future<void> toggleExercise(String id, int phaseNumber, String exerciseId) async {
    if (state is RecoveryLoaded) {
      try {
        await repository.toggleExercise(id, phaseNumber, exerciseId);
        await fetchActiveProtocol(); // Re-fetch to update state
      } catch (e) {
        emit(RecoveryError(e.toString()));
      }
    }
  }
}
