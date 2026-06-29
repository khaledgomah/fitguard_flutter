import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/injury_pattern.dart';

part 'injury_pattern_model.freezed.dart';
part 'injury_pattern_model.g.dart';

@freezed
class InjuryPatternModel with _$InjuryPatternModel {
  const factory InjuryPatternModel({
    required String muscleGroup,
    required int count,
  }) = _InjuryPatternModel;

  factory InjuryPatternModel.fromJson(Map<String, dynamic> json) =>
      _$InjuryPatternModelFromJson(json);
}

/// Extension to convert InjuryPatternModel → InjuryPattern domain entity.
extension InjuryPatternModelX on InjuryPatternModel {
  InjuryPattern toEntity() => InjuryPattern(
    muscleGroup: muscleGroup,
    count: count,
  );
}
