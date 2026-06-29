import 'package:equatable/equatable.dart';

abstract class RecoveryState extends Equatable {
  const RecoveryState();

  @override
  List<Object?> get props => [];
}

class RecoveryInitial extends RecoveryState {}

class RecoveryLoading extends RecoveryState {}

class RecoveryLoaded extends RecoveryState {
  final Map<String, dynamic>? activeProtocol;

  const RecoveryLoaded({this.activeProtocol});

  @override
  List<Object?> get props => [activeProtocol];
}

class RecoveryError extends RecoveryState {
  final String message;

  const RecoveryError(this.message);

  @override
  List<Object?> get props => [message];
}
