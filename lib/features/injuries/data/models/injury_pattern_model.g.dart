// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injury_pattern_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InjuryPatternModelImpl _$$InjuryPatternModelImplFromJson(
  Map<String, dynamic> json,
) => _$InjuryPatternModelImpl(
  muscleGroup: json['muscleGroup'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$InjuryPatternModelImplToJson(
  _$InjuryPatternModelImpl instance,
) => <String, dynamic>{
  'muscleGroup': instance.muscleGroup,
  'count': instance.count,
};
