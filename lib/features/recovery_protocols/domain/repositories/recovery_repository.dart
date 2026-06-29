import '../entities/recovery_protocol.dart';

abstract class RecoveryRepository {
  Future<List<RecoveryProtocol>> getRecoveryProtocols();
  Future<RecoveryProtocol?> getActiveRecoveryProtocol();
  Future<RecoveryProtocol> generateRecoveryProtocol({
    required String injuryName,
    required String injuryType,
    required String severity,
  });
  Future<RecoveryProtocol> updatePhaseProgress({
    required String protocolId,
    required String phaseId,
    required double progressPercentage,
  });
  Future<RecoveryProtocol> completePhase({
    required String protocolId,
    required String phaseId,
  });
  Future<RecoveryProtocol> completeProtocol({required String protocolId});
}
