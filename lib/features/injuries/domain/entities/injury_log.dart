import 'package:equatable/equatable.dart';

class InjuryLog extends Equatable {
  final String id;
  final String muscleGroup;
  final String injuryType;
  final String severity;
  final DateTime dateOccurred;
  final String recoveryStatus;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InjuryLog({
    required this.id,
    required this.muscleGroup,
    required this.injuryType,
    required this.severity,
    required this.dateOccurred,
    required this.recoveryStatus,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  InjuryLog copyWith({
    String? id,
    String? muscleGroup,
    String? injuryType,
    String? severity,
    DateTime? dateOccurred,
    String? recoveryStatus,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InjuryLog(
      id: id ?? this.id,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      injuryType: injuryType ?? this.injuryType,
      severity: severity ?? this.severity,
      dateOccurred: dateOccurred ?? this.dateOccurred,
      recoveryStatus: recoveryStatus ?? this.recoveryStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    muscleGroup,
    injuryType,
    severity,
    dateOccurred,
    recoveryStatus,
    notes,
    createdAt,
    updatedAt,
  ];
}
