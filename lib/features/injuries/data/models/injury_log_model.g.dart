// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injury_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InjuryLogModelImpl _$$InjuryLogModelImplFromJson(Map<String, dynamic> json) =>
    _$InjuryLogModelImpl(
      id: json['_id'] as String,
      muscleGroup: json['muscleGroup'] as String,
      injuryType: json['injuryType'] as String,
      severity: json['severity'] as String,
      dateOccurred: DateTime.parse(json['dateOccurred'] as String),
      recoveryStatus: json['recoveryStatus'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$InjuryLogModelImplToJson(
  _$InjuryLogModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'muscleGroup': instance.muscleGroup,
  'injuryType': instance.injuryType,
  'severity': instance.severity,
  'dateOccurred': instance.dateOccurred.toIso8601String(),
  'recoveryStatus': instance.recoveryStatus,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
