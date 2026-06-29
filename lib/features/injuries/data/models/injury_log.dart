class InjuryLog {
  final String id;
  final String muscleGroup;
  final String injuryType;
  final String severity;
  final DateTime dateOccurred;
  final String recoveryStatus;

  InjuryLog({
    required this.id,
    required this.muscleGroup,
    required this.injuryType,
    required this.severity,
    required this.dateOccurred,
    required this.recoveryStatus,
  });

  factory InjuryLog.fromJson(Map<String, dynamic> json) {
    return InjuryLog(
      id: json['_id'] ?? '',
      muscleGroup: json['muscleGroup'] ?? '',
      injuryType: json['injuryType'] ?? '',
      severity: json['severity'] ?? '',
      dateOccurred: DateTime.parse(json['dateOccurred']),
      recoveryStatus: json['recoveryStatus'] ?? '',
    );
  }
}
