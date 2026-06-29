import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({required NotificationRepository repository})
    : _repository = repository,
      super(NotificationInitial());

  final NotificationRepository _repository;

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await _repository.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> refreshNotifications() async {
    try {
      final notifications = await _repository.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> markAsRead(String id) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    try {
      final updated = await _repository.markAsRead(id);
      final notifications = currentState.notifications
          .map((notification) => notification.id == id ? updated : notification)
          .toList();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    try {
      await _repository.markAllAsRead();
      final notifications = await _repository.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteNotification(String id) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    try {
      await _repository.deleteNotification(id);
      final notifications = currentState.notifications
          .where((notification) => notification.id != id)
          .toList();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
