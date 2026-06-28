import 'recovery_phase.dart';

class RecoveryProtocol {
  const RecoveryProtocol({
    required this.id,
    required this.injuryName,
    required this.injuryType,
    required this.severity,
    required this.status, // 'active', 'completed'
    required this.currentPhaseIndex,
    required this.phases,
    this.startDate,
    this.updatedAt,
  });

  final String id;
  final String injuryName;
  final String injuryType;
  final String severity;
  final String status;
  final int currentPhaseIndex;
  final List<RecoveryPhase> phases;
  final DateTime? startDate;
  final DateTime? updatedAt;

  RecoveryProtocol copyWith({
    String? id,
    String? injuryName,
    String? injuryType,
    String? severity,
    String? status,
    int? currentPhaseIndex,
    List<RecoveryPhase>? phases,
    DateTime? startDate,
    DateTime? updatedAt,
  }) {
    return RecoveryProtocol(
      id: id ?? this.id,
      injuryName: injuryName ?? this.injuryName,
      injuryType: injuryType ?? this.injuryType,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      currentPhaseIndex: currentPhaseIndex ?? this.currentPhaseIndex,
      phases: phases ?? this.phases,
      startDate: startDate ?? this.startDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get overallProgress {
    if (phases.isEmpty) return 0.0;
    final totalProgress = phases.fold<double>(
      0.0,
      (sum, phase) => sum + (phase.status == 'completed' ? 100.0 : (phase.status == 'active' ? phase.progressPercentage : 0.0)),
    );
    return totalProgress / (phases.length * 100.0);
  }
}
