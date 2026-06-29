import 'package:dio/dio.dart';

import '../models/app_notification.dart';

class NotificationRepository {
  NotificationRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await _dio.get('/api/notifications');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(AppNotification.fromJson)
              .toList();
        }
        return const [];
      }
      throw Exception(
        response.data['message'] ?? 'Failed to load notifications',
      );
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<AppNotification> markAsRead(String id) async {
    try {
      final response = await _dio.put('/api/notifications/$id/read');
      if (response.data['success'] == true) {
        return AppNotification.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Failed to mark as read');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _dio.put('/api/notifications/read-all');
      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to mark all as read',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final response = await _dio.delete('/api/notifications/$id');
      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to delete notification',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
