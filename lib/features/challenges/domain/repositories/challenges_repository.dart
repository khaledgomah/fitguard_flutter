import '../entities/challenge.dart';

abstract class ChallengesRepository {
  Future<List<Challenge>> getChallenges();
  Future<Challenge?> getActiveChallenge();
  Future<Challenge> generateChallenge({
    required String title,
    required String type,
    required String difficulty,
  });
  Future<Challenge> completeDailyTask({
    required String challengeId,
    required String taskId,
  });
  Future<Challenge> completeChallenge({required String challengeId});
}
