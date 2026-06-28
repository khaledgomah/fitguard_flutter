import 'dart:developer';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/repositories/challenges_repository.dart';
import '../datasource/challenges_api.dart';
import '../models/challenge_model.dart';
import '../models/daily_task_model.dart';

class ChallengesRepositoryImpl implements ChallengesRepository {
  ChallengesRepositoryImpl({required ChallengesApi challengesApi})
      : _challengesApi = challengesApi;

  final ChallengesApi _challengesApi;

  // In-memory cache/mock storage for demo/testing
  final List<ChallengeModel> _mockChallenges = [];
  ChallengeModel? _mockActiveChallenge;

  void _ensureMockInitialized() {
    if (_mockChallenges.isNotEmpty) return;

    // Create a pre-built 30-day Core Stability Challenge
    final coreTasks = List.generate(30, (index) {
      final day = index + 1;
      return DailyTaskModel(
        id: 'core_task_$day',
        day: day,
        title: _getCoreTaskTitle(day),
        description: _getCoreTaskDescription(day),
        durationMinutes: 10 + (day % 3) * 5,
        isCompleted: day < 4, // Day 1-3 completed by default
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      );
    });

    final activeCoreChallenge = ChallengeModel(
      id: 'active_core_challenge_1',
      title: '30-Day Core Stability',
      description: 'Strengthen your core muscles to prevent lower back injuries and improve balance.',
      type: 'injury_prevention',
      difficulty: 'intermediate',
      durationDays: 30,
      currentDay: 4,
      isCompleted: false,
      dailyTasks: coreTasks,
      startDate: DateTime.now().subtract(const Duration(days: 3)),
    );

    // Create a completed 10-day shoulder mobility challenge
    final mobilityTasks = List.generate(10, (index) {
      final day = index + 1;
      return DailyTaskModel(
        id: 'mobility_task_$day',
        day: day,
        title: _getMobilityTaskTitle(day),
        description: _getMobilityTaskDescription(day),
        durationMinutes: 8,
        isCompleted: true,
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      );
    });

    final completedChallenge = ChallengeModel(
      id: 'completed_mobility_challenge',
      title: '10-Day Shoulder Mobility',
      description: 'Improve shoulder range of motion and relieve tension in the upper back.',
      type: 'mobility',
      difficulty: 'beginner',
      durationDays: 10,
      currentDay: 10,
      isCompleted: true,
      dailyTasks: mobilityTasks,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
    );

    _mockChallenges.addAll([activeCoreChallenge, completedChallenge]);
    _mockActiveChallenge = activeCoreChallenge;
  }

  @override
  Future<List<Challenge>> getChallenges() async {
    try {
      final remote = await _challengesApi.getChallenges();
      return remote;
    } catch (e) {
      log('ChallengesApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      return _mockChallenges;
    }
  }

  @override
  Future<Challenge?> getActiveChallenge() async {
    try {
      final remote = await _challengesApi.getActiveChallenge();
      return remote;
    } catch (e) {
      log('ChallengesApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      return _mockActiveChallenge;
    }
  }

  @override
  Future<Challenge> generateChallenge({
    required String title,
    required String type,
    required String difficulty,
  }) async {
    try {
      final remote = await _challengesApi.generateChallenge(
        title: title,
        type: type,
        difficulty: difficulty,
      );
      return remote;
    } catch (e) {
      log('ChallengesApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      final newId = 'challenge_${DateTime.now().millisecondsSinceEpoch}';
      final tasks = List.generate(30, (index) {
        final day = index + 1;
        return DailyTaskModel(
          id: '${newId}_task_$day',
          day: day,
          title: _getGeneratedTaskTitle(type, day),
          description: _getGeneratedTaskDescription(type, day),
          durationMinutes: 10 + (day % 3) * 5,
          isCompleted: false,
          videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        );
      });

      final newChallenge = ChallengeModel(
        id: newId,
        title: title,
        description: 'AI-Generated $difficulty challenge focused on $type.',
        type: type,
        difficulty: difficulty,
        durationDays: 30,
        currentDay: 1,
        isCompleted: false,
        dailyTasks: tasks,
        startDate: DateTime.now(),
      );

      _mockChallenges.add(newChallenge);
      _mockActiveChallenge = newChallenge;
      return newChallenge;
    }
  }

  @override
  Future<Challenge> completeDailyTask({
    required String challengeId,
    required String taskId,
  }) async {
    try {
      final remote = await _challengesApi.completeDailyTask(
        challengeId: challengeId,
        taskId: taskId,
      );
      return remote;
    } catch (e) {
      log('ChallengesApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      final index = _mockChallenges.indexWhere((c) => c.id == challengeId);
      if (index != -1) {
        final challenge = _mockChallenges[index];
        final updatedTasks = challenge.dailyTasks.map((t) {
          if (t.id == taskId) {
            return t.copyWith(isCompleted: true);
          }
          return t;
        }).toList();

        final completedCount = updatedTasks.where((t) => t.isCompleted).length;
        final isCompleted = completedCount == challenge.durationDays;
        
        int currentDay = challenge.currentDay;
        final completedTask = challenge.dailyTasks.firstWhere((t) => t.id == taskId);
        if (completedTask.day == challenge.currentDay && currentDay < challenge.durationDays) {
          currentDay += 1;
        }

        final updatedChallenge = challenge.copyWith(
          dailyTasks: updatedTasks,
          isCompleted: isCompleted,
          currentDay: currentDay,
        ) as ChallengeModel;

        _mockChallenges[index] = updatedChallenge;
        if (_mockActiveChallenge?.id == challengeId) {
          _mockActiveChallenge = isCompleted ? null : updatedChallenge;
        }
        return updatedChallenge;
      }
      throw const ApiException('Challenge not found locally');
    }
  }

  @override
  Future<Challenge> completeChallenge({required String challengeId}) async {
    try {
      final remote = await _challengesApi.completeChallenge(challengeId: challengeId);
      return remote;
    } catch (e) {
      log('ChallengesApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      final index = _mockChallenges.indexWhere((c) => c.id == challengeId);
      if (index != -1) {
        final challenge = _mockChallenges[index];
        final updatedTasks = challenge.dailyTasks.map((t) => t.copyWith(isCompleted: true)).toList();
        final updatedChallenge = challenge.copyWith(
          dailyTasks: updatedTasks,
          isCompleted: true,
        ) as ChallengeModel;

        _mockChallenges[index] = updatedChallenge;
        if (_mockActiveChallenge?.id == challengeId) {
          _mockActiveChallenge = null;
        }
        return updatedChallenge;
      }
      throw const ApiException('Challenge not found locally');
    }
  }

  // --- Helper methods to generate realistic dummy challenges content ---

  String _getCoreTaskTitle(int day) {
    final list = [
      'Plank Hold',
      'Bird-Dog Balance',
      'Deadbug Extensions',
      'Side Plank Right',
      'Side Plank Left',
      'Glute Bridges',
      'Cobra Stretch',
      'Flutter Kicks',
      'Supermans',
      'Russian Twists'
    ];
    return list[(day - 1) % list.length];
  }

  String _getCoreTaskDescription(int day) {
    return 'Perform 3 sets of the exercise focusing on core engagement. Maintain deep breathing and control your movement throughout the duration.';
  }

  String _getMobilityTaskTitle(int day) {
    final list = [
      'Cat-Cow Stretch',
      'Shoulder Pass-Throughs',
      'Doorway Chest Opener',
      'Child\'s Pose Reach',
      'Thread the Needle',
      'Scapular Push-ups',
      'T-Spine Rotations'
    ];
    return list[(day - 1) % list.length];
  }

  String _getMobilityTaskDescription(int day) {
    return 'Gently stretch and articulate the joint through its full range of motion. Do not force any range that causes pain.';
  }

  String _getGeneratedTaskTitle(String type, int day) {
    if (type.contains('mobility')) return _getMobilityTaskTitle(day);
    if (type.contains('strength')) return 'Strength Progression: ${_getCoreTaskTitle(day)}';
    return 'Active Prevention: ${_getCoreTaskTitle(day)}';
  }

  String _getGeneratedTaskDescription(String type, int day) {
    return 'AI custom daily routine for day $day. Spend time warming up first. Follow the instructions to maintain correct biomechanical form.';
  }
}
