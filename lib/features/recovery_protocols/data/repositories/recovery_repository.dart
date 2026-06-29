import 'package:dio/dio.dart';

class RecoveryRepository {
  final Dio _dio;

  RecoveryRepository({required Dio dio}) : _dio = dio;

  Future<Map<String, dynamic>?> getActiveProtocol() async {
    try {
      final response = await _dio.get('/api/recovery/active');
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load protocol');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> completePhase(String id, int phaseNumber) async {
    try {
      final response = await _dio.put('/api/recovery/$id/phase/$phaseNumber/complete');
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to complete phase');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> toggleExercise(String id, int phaseNumber, String exerciseId) async {
    try {
      final response = await _dio.put('/api/recovery/$id/phase/$phaseNumber/exercise/$exerciseId/toggle');
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to toggle exercise');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
