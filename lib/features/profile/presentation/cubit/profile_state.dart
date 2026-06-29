import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileUpdating extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileUpdateError extends ProfileState {
  const ProfileUpdateError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
