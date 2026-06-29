class CreateInjuryDto {
  final String muscleGroup;
  final String injuryType;
  final String severity;
  final DateTime dateOccurred;
  final String? recoveryStatus;
  final String? notes;

  const CreateInjuryDto({
    required this.muscleGroup,
    required this.injuryType,
    required this.severity,
    required this.dateOccurred,
    this.recoveryStatus,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'muscleGroup': muscleGroup,
      'injuryType': injuryType,
      'severity': severity,
      'dateOccurred': dateOccurred.toIso8601String(),
      if (recoveryStatus != null) 'recoveryStatus': recoveryStatus,
      if (notes != null) 'notes': notes,
    };
  }
}
