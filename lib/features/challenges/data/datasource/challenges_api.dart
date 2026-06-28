import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_exception.dart';
import '../models/challenge_model.dart';

class ChallengesApi {
  ChallengesApi({Dio? dio, String? baseUrl})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 20),
                headers: {'Content-Type': 'application/json'},
              ),
            );

  final Dio _dio;

  void updateToken(String? token) {
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  Future<List<ChallengeModel>> getChallenges() async {
    try {
      final response = await _dio.get<Object?>('/challenges');
      final data = response.data;
      if (data is List) {
        return data
            .map((item) => ChallengeModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      return [];
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<ChallengeModel?> getActiveChallenge() async {
    try {
      final response = await _dio.get<Object?>('/challenges/active');
      final data = response.data;
      if (data == null) return null;
      if (data is Map) {
        return ChallengeModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      throw _toApiException(error);
    }
  }

  Future<ChallengeModel> generateChallenge({
    required String title,
    required String type,
    required String difficulty,
  }) async {
    try {
      final response = await _dio.post<Object?>(
        '/challenges/generate',
        data: {
          'title': title,
          'type': type,
          'difficulty': difficulty,
        },
      );
      if (response.data is Map) {
        return ChallengeModel.fromJson(Map<String, dynamic>.from(response.data as Map));
      }
      throw const ApiException('Invalid response format');
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<ChallengeModel> completeDailyTask({
    required String challengeId,
    required String taskId,
  }) async {
    try {
      final response = await _dio.post<Object?>(
        '/challenges/$challengeId/tasks/$taskId/complete',
      );
      if (response.data is Map) {
        return ChallengeModel.fromJson(Map<String, dynamic>.from(response.data as Map));
      }
      throw const ApiException('Invalid response format');
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<ChallengeModel> completeChallenge({required String challengeId}) async {
    try {
      final response = await _dio.post<Object?>(
        '/challenges/$challengeId/complete',
      );
      if (response.data is Map) {
        return ChallengeModel.fromJson(Map<String, dynamic>.from(response.data as Map));
      }
      throw const ApiException('Invalid response format');
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  ApiException _toApiException(DioException error) {
    return ApiException(
      _extractErrorMessage(error),
      statusCode: error.response?.statusCode,
    );
  }

  String _extractErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map) {
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Check that the FitGuard backend is running.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Could not reach the FitGuard backend.';
    }

    return error.message ?? 'Something went wrong. Please try again.';
  }
}
