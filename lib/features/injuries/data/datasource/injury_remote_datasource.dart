import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_exception.dart';
import '../models/injury_log_model.dart';
import '../models/injury_pattern_model.dart';

class InjuryRemoteDataSource {
  InjuryRemoteDataSource({Dio? dio, String? baseUrl})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? '${AppConfig.apiBaseUrl}/injuries',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 20),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  final Dio _dio;

  Future<({List<InjuryLogModel> injuries, int total})> getInjuries({
    int page = 1,
    int limit = 10,
    String? sort,
    String? recoveryStatus,
    String? severity,
    String? muscleGroup,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (sort != null) 'sort': sort,
        if (recoveryStatus != null) 'recoveryStatus': recoveryStatus,
        if (severity != null) 'severity': severity,
        if (muscleGroup != null) 'muscleGroup': muscleGroup,
      };

      final response = await _dio.get<Object?>('/', queryParameters: queryParams);
      final data = _extractDataMap(response.data);

      final injuriesList = data['data'];
      final total = data['total'] as int? ?? 0;

      final injuries = (injuriesList is List)
          ? injuriesList
              .map(
                (e) => InjuryLogModel.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList()
          : <InjuryLogModel>[];

      return (injuries: injuries, total: total);
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<InjuryLogModel> getInjuryById(String id) async {
    try {
      final response = await _dio.get<Object?>('/$id');
      final data = _extractDataMap(response.data);
      final item = data['data'] as Map<String, dynamic>;
      return InjuryLogModel.fromJson(item);
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<InjuryLogModel> createInjury(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post<Object?>('/', data: body);
      final data = _extractDataMap(response.data);
      final item = data['data'] as Map<String, dynamic>;
      return InjuryLogModel.fromJson(item);
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<InjuryLogModel> updateInjury(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.put<Object?>('/$id', data: body);
      final data = _extractDataMap(response.data);
      final item = data['data'] as Map<String, dynamic>;
      return InjuryLogModel.fromJson(item);
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<void> deleteInjury(String id) async {
    try {
      await _dio.delete<Object?>('/$id');
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<List<InjuryPatternModel>> getPatterns() async {
    try {
      final response = await _dio.get<Object?>('/patterns');
      final data = _extractDataMap(response.data);
      final items = data['data'] as List;

      return items
          .map(
            (e) => InjuryPatternModel.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  /// Extracts the top-level response object and validates [success].
  Map<String, dynamic> _extractDataMap(Object? response) {
    final map =
        response is Map<String, dynamic>
            ? Map<String, dynamic>.from(response)
            : <String, dynamic>{};

    final success = map['success'] as bool? ?? false;
    if (!success) {
      final message = (map['message'] as String?) ?? 'Unknown error';
      throw ApiException(message);
    }

    return map;
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
      final map = Map<String, dynamic>.from(data);

      // Extract first validation error from the errors array
      final errorsData = map['data'];
      if (errorsData is Map) {
        final errors = errorsData['errors'];
        if (errors is List && errors.isNotEmpty) {
          final firstError = errors.first;
          if (firstError is Map && firstError['msg'] != null) {
            return firstError['msg'].toString();
          }
        }
      }

      if (map['message'] != null) {
        return map['message'].toString();
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Check that the FitGuard backend is running.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Could not reach the FitGuard backend. Check the API URL and server.';
    }

    if (error.response?.statusCode == 401) {
      return 'Session expired. Please login again.';
    }

    if (error.response?.statusCode == 404) {
      return 'Injury log not found.';
    }

    return error.message ?? 'Something went wrong. Please try again.';
  }
}
