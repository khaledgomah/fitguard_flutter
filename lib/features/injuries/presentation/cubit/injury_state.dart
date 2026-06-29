import 'package:equatable/equatable.dart';
import '../../data/models/injury_log.dart';

abstract class InjuryState extends Equatable {
  const InjuryState();

  @override
  List<Object?> get props => [];
}

class InjuryInitial extends InjuryState {}

class InjuryLoading extends InjuryState {}

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
