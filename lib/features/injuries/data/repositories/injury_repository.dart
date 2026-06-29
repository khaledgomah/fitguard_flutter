import 'package:dio/dio.dart';
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
      return InjuryLog.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to log injury');
    }
  }

  Future<void> generateRecoveryProtocol(String injuryLogId) async {
    final response = await _dio.post('/api/recovery/generate', data: {
      'injuryLogId': injuryLogId,
    });

    if (response.statusCode != 201 && response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to generate protocol');
    }
  }
}
