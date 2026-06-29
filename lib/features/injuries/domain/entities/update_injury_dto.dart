class UpdateInjuryDto {
  final String? muscleGroup;
  final String? injuryType;
  final String? severity;
  final DateTime? dateOccurred;
  final String? recoveryStatus;
  final String? notes;

  const UpdateInjuryDto({
    this.muscleGroup,
    this.injuryType,
    this.severity,
    this.dateOccurred,
    this.recoveryStatus,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      if (muscleGroup != null) 'muscleGroup': muscleGroup,
      if (injuryType != null) 'injuryType': injuryType,
      if (severity != null) 'severity': severity,
      if (dateOccurred != null)
        'dateOccurred': dateOccurred!.toIso8601String(),
      if (recoveryStatus != null) 'recoveryStatus': recoveryStatus,
      if (notes != null) 'notes': notes,
    };
  }
}
