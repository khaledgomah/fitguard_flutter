// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/injury_log.dart';

part 'injury_log_model.freezed.dart';
part 'injury_log_model.g.dart';

@freezed
class InjuryLogModel with _$InjuryLogModel {
  const factory InjuryLogModel({
    @JsonKey(name: '_id') required String id,
    required String muscleGroup,
    required String injuryType,
    required String severity,
    required DateTime dateOccurred,
    required String recoveryStatus,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _InjuryLogModel;

  factory InjuryLogModel.fromJson(Map<String, dynamic> json) =>
      _$InjuryLogModelFromJson(json);
}

/// Extension to convert InjuryLogModel → InjuryLog domain entity.
extension InjuryLogModelX on InjuryLogModel {
  InjuryLog toEntity() => InjuryLog(
    id: id,
    muscleGroup: muscleGroup,
    injuryType: injuryType,
    severity: severity,
    dateOccurred: dateOccurred,
    recoveryStatus: recoveryStatus,
    notes: notes,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
