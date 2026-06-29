import 'package:equatable/equatable.dart';

class InjuryPattern extends Equatable {
  final String muscleGroup;
  final int count;

  const InjuryPattern({
    required this.muscleGroup,
    required this.count,
  });

  @override
  List<Object?> get props => [muscleGroup, count];
}
