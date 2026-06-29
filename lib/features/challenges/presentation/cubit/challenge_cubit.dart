import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/challenge_repository.dart';
import 'challenge_state.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  final ChallengeRepository repository;

  ChallengeCubit({required this.repository}) : super(ChallengeInitial());

  Future<void> fetchActiveChallenge() async {
    emit(ChallengeLoading());
    try {
      final challenge = await repository.getActiveChallenge();
      if (challenge != null) {
        emit(ActiveChallengeLoaded(challenge));
      } else {
        emit(NoActiveChallenge());
      }
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  Future<void> generateChallenge(String difficulty) async {
    emit(ChallengeGenerating());
    try {
      final challenge = await repository.generateChallenge(difficulty);
      emit(ActiveChallengeLoaded(challenge));
    } catch (e) {
      emit(ChallengeError(e.toString()));
      // Fallback to fetching whatever was there before
      fetchActiveChallenge();
    }
  }

  Future<void> completeDay(String challengeId, int dayNumber) async {
    final currentState = state;
    if (currentState is! ActiveChallengeLoaded) return;
    
    try {
      final updatedChallenge = await repository.completeDay(challengeId, dayNumber);
      emit(ActiveChallengeLoaded(updatedChallenge));
    } catch (e) {
      emit(ChallengeError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> abandonChallenge(String challengeId) async {
    emit(ChallengeLoading());
    try {
      await repository.abandonChallenge(challengeId);
      emit(NoActiveChallenge());
    } catch (e) {
      emit(ChallengeError(e.toString()));
      fetchActiveChallenge();
    }
  }
}
