import '../../data/models/challenge_model.dart';

abstract class ChallengeState {}

class ChallengeInitial extends ChallengeState {}

class ChallengeLoading extends ChallengeState {}

class ChallengeGenerating extends ChallengeState {}

class NoActiveChallenge extends ChallengeState {}

class ActiveChallengeLoaded extends ChallengeState {
  final ChallengeModel challenge;

  ActiveChallengeLoaded(this.challenge);
}

class ChallengeError extends ChallengeState {
  final String message;

  ChallengeError(this.message);
}
