import 'package:equatable/equatable.dart';
import '../../domain/entities/injury_log.dart';
import '../../domain/entities/injury_pattern.dart';

abstract class InjuryState extends Equatable {
  const InjuryState();

  @override
  List<Object?> get props => [];
}

class InjuryInitial extends InjuryState {}

class InjuryLoading extends InjuryState {}

class InjuriesLoaded extends InjuryState {
  final List<InjuryLog> injuries;
  final int total;

  const InjuriesLoaded({required this.injuries, required this.total});

  @override
  List<Object?> get props => [injuries, total];
}

class InjuryDetailLoaded extends InjuryState {
  final InjuryLog injury;

  const InjuryDetailLoaded(this.injury);

  @override
  List<Object?> get props => [injury];
}

class InjuryPatternsLoaded extends InjuryState {
  final List<InjuryPattern> patterns;

  const InjuryPatternsLoaded(this.patterns);

  @override
  List<Object?> get props => [patterns];
}

class InjurySuccess extends InjuryState {
  final InjuryLog injuryLog;

  const InjurySuccess(this.injuryLog);

  @override
  List<Object?> get props => [injuryLog];
}

class InjuryError extends InjuryState {
  final String message;

  const InjuryError(this.message);

  @override
  List<Object?> get props => [message];
}
