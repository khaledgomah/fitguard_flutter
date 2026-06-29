import 'package:equatable/equatable.dart';

import '../../data/models/app_notification.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  const NotificationLoaded(this.notifications);

  final List<AppNotification> notifications;

  int get unreadCount => notifications.where((n) => !n.read).length;

  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  const NotificationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
