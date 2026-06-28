import '../../domain/entities/recovery_protocol.dart';
import 'recovery_phase_model.dart';

class RecoveryProtocolModel extends RecoveryProtocol {
  const RecoveryProtocolModel({
    required super.id,
    required super.injuryName,
    required super.injuryType,
    required super.severity,
    required super.status,
    required super.currentPhaseIndex,
    required super.phases,
    super.startDate,
    super.updatedAt,
  });

  factory RecoveryProtocolModel.fromJson(Map<String, dynamic> json) {
    var phasesFromJson = json['phases'] as List? ?? [];
    List<RecoveryPhaseModel> phaseList = phasesFromJson
        .map((p) => RecoveryPhaseModel.fromJson(Map<String, dynamic>.from(p)))
        .toList();

    return RecoveryProtocolModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      injuryName: (json['injuryName'] ?? '').toString(),
      injuryType: (json['injuryType'] ?? '').toString(),
      severity: (json['severity'] ?? '').toString(),
      status: (json['status'] ?? 'active').toString(),
      currentPhaseIndex: _toInt(json['currentPhaseIndex'] ?? 0),
      phases: phaseList,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'injuryName': injuryName,
      'injuryType': injuryType,
      'severity': severity,
      'status': status,
      'currentPhaseIndex': currentPhaseIndex,
      'phases': phases
          .map((p) => (p is RecoveryPhaseModel)
              ? p.toJson()
              : RecoveryPhaseModel(
                  id: p.id,
                  phaseNumber: p.phaseNumber,
                  name: p.name,
                  description: p.description,
                  status: p.status,
                  exercises: p.exercises,
                  progressPercentage: p.progressPercentage,
                ).toJson())
          .toList(),
      'startDate': startDate?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
