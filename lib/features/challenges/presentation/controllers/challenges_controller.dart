import 'package:flutter/foundation.dart';

import '../../domain/entities/challenge.dart';
import '../../domain/repositories/challenges_repository.dart';

class ChallengesController extends ChangeNotifier {
  ChallengesController({required ChallengesRepository challengesRepository})
      : _challengesRepository = challengesRepository;

  final ChallengesRepository _challengesRepository;

  List<Challenge> _challenges = [];
  Challenge? _activeChallenge;
  bool _isLoading = false;
  String? _errorMessage;

  List<Challenge> get challenges => _challenges;
  Challenge? get activeChallenge => _activeChallenge;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadChallenges() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _challenges = await _challengesRepository.getChallenges();
      _activeChallenge = await _challengesRepository.getActiveChallenge();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateChallenge({
    required String title,
    required String type,
    required String difficulty,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newChallenge = await _challengesRepository.generateChallenge(
        title: title,
        type: type,
        difficulty: difficulty,
      );
      _activeChallenge = newChallenge;
      // Add to list if not present
      if (!_challenges.any((c) => c.id == newChallenge.id)) {
        _challenges = [newChallenge, ..._challenges];
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeDailyTask({
    required String challengeId,
    required String taskId,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _challengesRepository.completeDailyTask(
        challengeId: challengeId,
        taskId: taskId,
      );

      // Update in local lists
      final index = _challenges.indexWhere((c) => c.id == challengeId);
      if (index != -1) {
        final List<Challenge> newList = List.from(_challenges);
        newList[index] = updated;
        _challenges = newList;
      }

      if (_activeChallenge?.id == challengeId) {
        _activeChallenge = updated.isCompleted ? null : updated;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> completeChallenge({required String challengeId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _challengesRepository.completeChallenge(
        challengeId: challengeId,
      );

      final index = _challenges.indexWhere((c) => c.id == challengeId);
      if (index != -1) {
        final List<Challenge> newList = List.from(_challenges);
        newList[index] = updated;
        _challenges = newList;
      }

      if (_activeChallenge?.id == challengeId) {
        _activeChallenge = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
