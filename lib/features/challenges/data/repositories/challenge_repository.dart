import 'package:dio/dio.dart';
import 'package:fitguard/core/services/notifications_service.dart';

import '../models/challenge_model.dart';

class ChallengeRepository {
  final Dio dio;

  ChallengeRepository({required this.dio});

  Future<ChallengeModel?> getActiveChallenge() async {
    try {
      final response = await dio.get('/api/challenges/active');
      if (response.data['data'] != null) {
        return ChallengeModel.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch active challenge');
    }
  }

  Future<ChallengeModel> generateChallenge(String difficulty) async {
    try {
      final response = await dio.post(
        '/api/challenges/generate',
        data: {'difficulty': difficulty},
      );
      final challenge = ChallengeModel.fromJson(response.data['data']);
      final sport = challenge.sport.isEmpty ? 'fitness' : challenge.sport;
      await NotificationService.showBackendNotificationIfNeeded(
        type: 'challenge_nudge',
        message:
            'Your personalized 30-day $sport challenge (${challenge.difficulty}) has been generated! Complete Day 1 to start your streak.',
      );
      return challenge;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to generate challenge');
    }
  }

  Future<ChallengeModel> completeDay(String challengeId, int dayNumber) async {
    try {
      final response = await dio.put('/api/challenges/$challengeId/day/$dayNumber/complete');
      final challenge = ChallengeModel.fromJson(response.data['data']);
      final sport = challenge.sport.isEmpty ? 'fitness' : challenge.sport;
      final message = challenge.status == 'completed'
          ? 'Incredible job! You have fully completed your 30-day $sport challenge!'
          : 'Day $dayNumber of your $sport challenge is complete! Keep up the good work.';
      await NotificationService.showBackendNotificationIfNeeded(
        type: 'challenge_nudge',
        message: message,
      );
      return challenge;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to complete day');
    }
  }

  Future<void> abandonChallenge(String challengeId) async {
    try {
      await dio.put('/api/challenges/$challengeId/abandon');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to abandon challenge');
    }
  }
}
