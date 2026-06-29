import 'package:dio/dio.dart';
import '../models/dashboard_stats.dart';

class DashboardRepository {
  DashboardRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<DashboardStats> getStats() async {
    try {
      final response = await _dio.get('/api/dashboard/stats');
      if (response.data['success'] == true) {
        return DashboardStats.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load stats');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
