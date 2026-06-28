import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_exception.dart';
import '../models/recovery_protocol_model.dart';

class RecoveryApi {
  RecoveryApi({Dio? dio, String? baseUrl})
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

  Future<List<RecoveryProtocolModel>> getRecoveryProtocols() async {
    try {
      final response = await _dio.get<Object?>('/recovery');
      final data = response.data;
      if (data is List) {
        return data
            .map((item) => RecoveryProtocolModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      return [];
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<RecoveryProtocolModel?> getActiveRecoveryProtocol() async {
    try {
      final response = await _dio.get<Object?>('/recovery/active');
      final data = response.data;
      if (data == null) return null;
      if (data is Map) {
        return RecoveryProtocolModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      throw _toApiException(error);
    }
  }

  Future<RecoveryProtocolModel> generateRecoveryProtocol({
    required String injuryName,
    required String injuryType,
    required String severity,
  }) async {
    try {
      final response = await _dio.post<Object?>(
        '/recovery/generate',
        data: {
          'injuryName': injuryName,
          'injuryType': injuryType,
          'severity': severity,
        },
      );
      if (response.data is Map) {
        return RecoveryProtocolModel.fromJson(Map<String, dynamic>.from(response.data as Map));
      }
      throw const ApiException('Invalid response format');
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<RecoveryProtocolModel> updatePhaseProgress({
    required String protocolId,
    required String phaseId,
    required double progressPercentage,
  }) async {
    try {
      final response = await _dio.post<Object?>(
        '/recovery/$protocolId/phases/$phaseId/progress',
        data: {'progressPercentage': progressPercentage},
      );
      if (response.data is Map) {
        return RecoveryProtocolModel.fromJson(Map<String, dynamic>.from(response.data as Map));
      }
      throw const ApiException('Invalid response format');
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<RecoveryProtocolModel> completePhase({
    required String protocolId,
    required String phaseId,
  }) async {
    try {
      final response = await _dio.post<Object?>(
        '/recovery/$protocolId/phases/$phaseId/complete',
      );
      if (response.data is Map) {
        return RecoveryProtocolModel.fromJson(Map<String, dynamic>.from(response.data as Map));
      }
      throw const ApiException('Invalid response format');
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<RecoveryProtocolModel> completeProtocol({required String protocolId}) async {
    try {
      final response = await _dio.post<Object?>(
        '/recovery/$protocolId/complete',
      );
      if (response.data is Map) {
        return RecoveryProtocolModel.fromJson(Map<String, dynamic>.from(response.data as Map));
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
