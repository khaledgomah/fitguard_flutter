import 'package:flutter/foundation.dart';

import '../../domain/entities/recovery_protocol.dart';
import '../../domain/repositories/recovery_repository.dart';

class RecoveryController extends ChangeNotifier {
  RecoveryController({required RecoveryRepository recoveryRepository})
      : _recoveryRepository = recoveryRepository;

  final RecoveryRepository _recoveryRepository;

  List<RecoveryProtocol> _protocols = [];
  RecoveryProtocol? _activeProtocol;
  bool _isLoading = false;
  String? _errorMessage;

  List<RecoveryProtocol> get protocols => _protocols;
  RecoveryProtocol? get activeProtocol => _activeProtocol;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProtocols() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _protocols = await _recoveryRepository.getRecoveryProtocols();
      _activeProtocol = await _recoveryRepository.getActiveRecoveryProtocol();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateRecoveryProtocol({
    required String injuryName,
    required String injuryType,
    required String severity,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newProtocol = await _recoveryRepository.generateRecoveryProtocol(
        injuryName: injuryName,
        injuryType: injuryType,
        severity: severity,
      );
      _activeProtocol = newProtocol;
      // Add to list if not present
      if (!_protocols.any((p) => p.id == newProtocol.id)) {
        _protocols = [newProtocol, ..._protocols];
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePhaseProgress({
    required String protocolId,
    required String phaseId,
    required double progressPercentage,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _recoveryRepository.updatePhaseProgress(
        protocolId: protocolId,
        phaseId: phaseId,
        progressPercentage: progressPercentage,
      );

      final index = _protocols.indexWhere((p) => p.id == protocolId);
      if (index != -1) {
        final List<RecoveryProtocol> newList = List.from(_protocols);
        newList[index] = updated;
        _protocols = newList;
      }

      if (_activeProtocol?.id == protocolId) {
        _activeProtocol = updated.status == 'completed' ? null : updated;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> completePhase({
    required String protocolId,
    required String phaseId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _recoveryRepository.completePhase(
        protocolId: protocolId,
        phaseId: phaseId,
      );

      final index = _protocols.indexWhere((p) => p.id == protocolId);
      if (index != -1) {
        final List<RecoveryProtocol> newList = List.from(_protocols);
        newList[index] = updated;
        _protocols = newList;
      }

      if (_activeProtocol?.id == protocolId) {
        _activeProtocol = updated.status == 'completed' ? null : updated;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeProtocol({required String protocolId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _recoveryRepository.completeProtocol(
        protocolId: protocolId,
      );

      final index = _protocols.indexWhere((p) => p.id == protocolId);
      if (index != -1) {
        final List<RecoveryProtocol> newList = List.from(_protocols);
        newList[index] = updated;
        _protocols = newList;
      }

      if (_activeProtocol?.id == protocolId) {
        _activeProtocol = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
