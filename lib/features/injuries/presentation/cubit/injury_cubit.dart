import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/injury_repository.dart';
import 'injury_state.dart';

class InjuryCubit extends Cubit<InjuryState> {
  final InjuryRepository repository;

  InjuryCubit({required this.repository}) : super(InjuryInitial());

  Future<void> submitInjuryAndGenerateProtocol({
    required String muscleGroup,
    required String injuryType,
    required String severity,
    required DateTime dateOccurred,
  }) async {
    emit(InjuryLoading());
    try {
      // 1. Log the injury
      final injury = await repository.logInjury(
        muscleGroup: muscleGroup,
        injuryType: injuryType,
        severity: severity,
        dateOccurred: dateOccurred,
      );

      // 2. Generate the AI recovery protocol using the new injury ID
      await repository.generateRecoveryProtocol(injury.id);

      emit(InjurySuccess(injury));
    } catch (e) {
      emit(InjuryError(e.toString()));
    }
  }
}
