import 'package:dio/dio.dart';
import 'package:fitguard/core/services/notifications_service.dart';

import '../models/injury_log.dart';

class InjuryRepository {
  final Dio _dio;

  InjuryRepository({required Dio dio}) : _dio = dio;

  Future<InjuryLog> logInjury({
    required String muscleGroup,
    required String injuryType,
    required String severity,
    required DateTime dateOccurred,
  }) async {
    final response = await _dio.post('/api/injuries', data: {
      'muscleGroup': muscleGroup,
      'injuryType': injuryType,
      'severity': severity,
      'dateOccurred': dateOccurred.toIso8601String(),
    });

    if (response.statusCode == 201 && response.data['success'] == true) {
      final injury = InjuryLog.fromJson(response.data['data']);
      await NotificationService.showBackendNotificationIfNeeded(
        type: 'injury_reminder',
        message:
            'Injury logged: ${injury.severity} ${injury.injuryType} on ${injury.muscleGroup}. Take care and consider generating a recovery protocol.',
      );
      return injury;
    } else {
      throw Exception(response.data['message'] ?? 'Failed to log injury');
    }
  }

  Future<void> generateRecoveryProtocol(String injuryLogId) async {
    final response = await _dio.post('/api/recovery/generate', data: {
      'injuryLogId': injuryLogId,
    });

    if (response.statusCode == 201 && response.data['success'] == true) {
      await NotificationService.showBackendNotificationIfNeeded(
        type: 'recovery_reminder',
        message: 'Recovery protocol generated successfully. Let\'s start Phase 1.',
      );
    } else {
      throw Exception(response.data['message'] ?? 'Failed to generate protocol');
    }
  }
}
