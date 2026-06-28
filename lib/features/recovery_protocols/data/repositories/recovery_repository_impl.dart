import 'dart:developer';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/recovery_protocol.dart';
import '../../domain/repositories/recovery_repository.dart';
import '../datasource/recovery_api.dart';
import '../models/recovery_phase_model.dart';
import '../models/recovery_protocol_model.dart';

class RecoveryRepositoryImpl implements RecoveryRepository {
  RecoveryRepositoryImpl({required RecoveryApi recoveryApi})
      : _recoveryApi = recoveryApi;

  final RecoveryApi _recoveryApi;

  // In-memory cache/mock storage for demo/testing
  final List<RecoveryProtocolModel> _mockProtocols = [];
  RecoveryProtocolModel? _mockActiveProtocol;

  void _ensureMockInitialized() {
    if (_mockProtocols.isNotEmpty) return;

    final kneePhases = [
      const RecoveryPhaseModel(
        id: 'patellar_p1',
        phaseNumber: 1,
        name: 'Pain Management & Isometric Loading',
        description: 'Reduce acute inflammation, manage tendon pain, and begin gentle isometric loading to prevent muscle atrophy.',
        status: 'completed',
        exercises: ['Spanish Squats (Holds)', 'Wall Sits (Isometric)', 'Patellar Mobilization', 'Straight Leg Raises'],
        progressPercentage: 100.0,
      ),
      const RecoveryPhaseModel(
        id: 'patellar_p2',
        phaseNumber: 2,
        name: 'Isotonic Strength & Knee Extension',
        description: 'Restore full quad strength through full ranges of motion using progressive overload.',
        status: 'active',
        exercises: ['Leg Press (Heavy)', 'Bulgarian Split Squats', 'Poliquin Step-ups', 'Goblet Squats'],
        progressPercentage: 40.0,
      ),
      const RecoveryPhaseModel(
        id: 'patellar_p3',
        phaseNumber: 3,
        name: 'Plyometrics & Return to Sport',
        description: 'Introduce energy storage and release exercises to prepare the patellar tendon for high-velocity sports movement.',
        status: 'locked',
        exercises: ['Box Jumps', 'Depth Drops', 'Lateral Bounds', 'Sport-Specific Drills'],
        progressPercentage: 0.0,
      ),
    ];

    final kneeProtocol = RecoveryProtocolModel(
      id: 'knee_patellar_tendonitis_1',
      injuryName: 'Patellar Tendonitis',
      injuryType: 'Knee',
      severity: 'moderate',
      status: 'active',
      currentPhaseIndex: 1,
      phases: kneePhases,
      startDate: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    );

    final hamstringPhases = [
      const RecoveryPhaseModel(
        id: 'hamstring_p1',
        phaseNumber: 1,
        name: 'Acute Protection & Gentle ROM',
        description: 'Protect the muscle tissue, promote early mobilization, and reduce swelling.',
        status: 'completed',
        exercises: ['Prone Leg Curls (Bodyweight)', 'Hamstring Bridges (Double Leg)', 'Active Knee Extensions'],
        progressPercentage: 100.0,
      ),
      const RecoveryPhaseModel(
        id: 'hamstring_p2',
        phaseNumber: 2,
        name: 'Eccentric Re-strengthening',
        description: 'Rebuild structural integrity of the hamstring fibers under load and stretch.',
        status: 'completed',
        exercises: ['Romanian Deadlifts', 'Single-Leg Glute Bridges', 'Slider Leg Curls'],
        progressPercentage: 100.0,
      ),
      const RecoveryPhaseModel(
        id: 'hamstring_p3',
        phaseNumber: 3,
        name: 'High Velocity Eccentrics & Running',
        description: 'Prepare the hamstring for high sprinting loads and return to competitive environment.',
        status: 'completed',
        exercises: ['Nordic Hamstring Curls', 'A-Skips & B-Skips', 'Progressive Sprinting Intervals'],
        progressPercentage: 100.0,
      ),
    ];

    final completedHamstring = RecoveryProtocolModel(
      id: 'hamstring_strain_completed',
      injuryName: 'Hamstring Strain',
      injuryType: 'Thigh',
      severity: 'mild',
      status: 'completed',
      currentPhaseIndex: 2,
      phases: hamstringPhases,
      startDate: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(days: 15)),
    );

    _mockProtocols.addAll([kneeProtocol, completedHamstring]);
    _mockActiveProtocol = kneeProtocol;
  }

  @override
  Future<List<RecoveryProtocol>> getRecoveryProtocols() async {
    try {
      final remote = await _recoveryApi.getRecoveryProtocols();
      return remote;
    } catch (e) {
      log('RecoveryApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      return _mockProtocols;
    }
  }

  @override
  Future<RecoveryProtocol?> getActiveRecoveryProtocol() async {
    try {
      final remote = await _recoveryApi.getActiveRecoveryProtocol();
      return remote;
    } catch (e) {
      log('RecoveryApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      return _mockActiveProtocol;
    }
  }

  @override
  Future<RecoveryProtocol> generateRecoveryProtocol({
    required String injuryName,
    required String injuryType,
    required String severity,
  }) async {
    try {
      final remote = await _recoveryApi.generateRecoveryProtocol(
        injuryName: injuryName,
        injuryType: injuryType,
        severity: severity,
      );
      return remote;
    } catch (e) {
      log('RecoveryApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      final newId = 'protocol_${DateTime.now().millisecondsSinceEpoch}';

      final phases = [
        RecoveryPhaseModel(
          id: '${newId}_p1',
          phaseNumber: 1,
          name: 'Phase 1: Protection & Pain Control',
          description: 'Reduce acute swelling and maintain safe joint ranges of motion without overload.',
          status: 'active',
          exercises: ['Isometric contractions', 'Passive stretching', 'RICE protocol compliance'],
          progressPercentage: 0.0,
        ),
        RecoveryPhaseModel(
          id: '${newId}_p2',
          phaseNumber: 2,
          name: 'Phase 2: Progressive Reloading',
          description: 'Introduce concentric exercises and light loads to rebuild tissue threshold.',
          status: 'locked',
          exercises: ['Concentric strengthening', 'Active stretching', 'Closed kinetic chain work'],
          progressPercentage: 0.0,
        ),
        RecoveryPhaseModel(
          id: '${newId}_p3',
          phaseNumber: 3,
          name: 'Phase 3: Dynamic Adaptation',
          description: 'Rebuild explosive capacity, agility, and load tolerance under functional patterns.',
          status: 'locked',
          exercises: ['Plyometric movements', 'Functional drill progression', 'Symmetric load testing'],
          progressPercentage: 0.0,
        ),
      ];

      final newProtocol = RecoveryProtocolModel(
        id: newId,
        injuryName: injuryName,
        injuryType: injuryType,
        severity: severity,
        status: 'active',
        currentPhaseIndex: 0,
        phases: phases,
        startDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _mockProtocols.add(newProtocol);
      _mockActiveProtocol = newProtocol;
      return newProtocol;
    }
  }

  @override
  Future<RecoveryProtocol> updatePhaseProgress({
    required String protocolId,
    required String phaseId,
    required double progressPercentage,
  }) async {
    try {
      final remote = await _recoveryApi.updatePhaseProgress(
        protocolId: protocolId,
        phaseId: phaseId,
        progressPercentage: progressPercentage,
      );
      return remote;
    } catch (e) {
      log('RecoveryApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      final index = _mockProtocols.indexWhere((p) => p.id == protocolId);
      if (index != -1) {
        final protocol = _mockProtocols[index];
        final updatedPhases = protocol.phases.map((p) {
          if (p.id == phaseId) {
            final isFullyDone = progressPercentage >= 100.0;
            return (p as RecoveryPhaseModel).copyWith(
              progressPercentage: progressPercentage,
              status: isFullyDone ? 'completed' : 'active',
            ) as RecoveryPhaseModel;
          }
          return p;
        }).toList();

        final updatedProtocol = protocol.copyWith(
          phases: updatedPhases,
          updatedAt: DateTime.now(),
        ) as RecoveryProtocolModel;

        _mockProtocols[index] = updatedProtocol;
        if (_mockActiveProtocol?.id == protocolId) {
          _mockActiveProtocol = updatedProtocol;
        }
        return updatedProtocol;
      }
      throw const ApiException('Protocol not found locally');
    }
  }

  @override
  Future<RecoveryProtocol> completePhase({
    required String protocolId,
    required String phaseId,
  }) async {
    try {
      final remote = await _recoveryApi.completePhase(
        protocolId: protocolId,
        phaseId: phaseId,
      );
      return remote;
    } catch (e) {
      log('RecoveryApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      final index = _mockProtocols.indexWhere((p) => p.id == protocolId);
      if (index != -1) {
        final protocol = _mockProtocols[index];
        
        int nextPhaseIndex = protocol.currentPhaseIndex;
        final updatedPhases = protocol.phases.asMap().entries.map((entry) {
          final idx = entry.key;
          final p = entry.value;
          
          if (p.id == phaseId) {
            return (p as RecoveryPhaseModel).copyWith(
              status: 'completed',
              progressPercentage: 100.0,
            ) as RecoveryPhaseModel;
          }
          
          if (idx == protocol.currentPhaseIndex + 1 && protocol.phases[protocol.currentPhaseIndex].id == phaseId) {
            nextPhaseIndex = idx;
            return (p as RecoveryPhaseModel).copyWith(status: 'active') as RecoveryPhaseModel;
          }
          
          return p;
        }).toList();

        final allCompleted = updatedPhases.every((p) => p.status == 'completed');

        final updatedProtocol = protocol.copyWith(
          phases: updatedPhases,
          currentPhaseIndex: nextPhaseIndex,
          status: allCompleted ? 'completed' : 'active',
          updatedAt: DateTime.now(),
        ) as RecoveryProtocolModel;

        _mockProtocols[index] = updatedProtocol;
        if (_mockActiveProtocol?.id == protocolId) {
          _mockActiveProtocol = allCompleted ? null : updatedProtocol;
        }
        return updatedProtocol;
      }
      throw const ApiException('Protocol not found locally');
    }
  }

  @override
  Future<RecoveryProtocol> completeProtocol({required String protocolId}) async {
    try {
      final remote = await _recoveryApi.completeProtocol(protocolId: protocolId);
      return remote;
    } catch (e) {
      log('RecoveryApi error: $e. Falling back to local mocks.');
      _ensureMockInitialized();
      final index = _mockProtocols.indexWhere((p) => p.id == protocolId);
      if (index != -1) {
        final protocol = _mockProtocols[index];
        final updatedPhases = protocol.phases.map((p) => (p as RecoveryPhaseModel).copyWith(
          status: 'completed',
          progressPercentage: 100.0,
        ) as RecoveryPhaseModel).toList();

        final updatedProtocol = protocol.copyWith(
          phases: updatedPhases,
          status: 'completed',
          updatedAt: DateTime.now(),
        ) as RecoveryProtocolModel;

        _mockProtocols[index] = updatedProtocol;
        if (_mockActiveProtocol?.id == protocolId) {
          _mockActiveProtocol = null;
        }
        return updatedProtocol;
      }
      throw const ApiException('Protocol not found locally');
    }
  }
}
