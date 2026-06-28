import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_exception.dart';
import '../models/auth_session.dart';

class AuthApi {
  AuthApi({Dio? dio, String? baseUrl})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 20),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  final Dio _dio;

  Future<AuthSession> login({required String email, required String password}) {
    return _postForSession(
      '/auth/login',
      data: {'email': email.trim(), 'password': password},
    );
  }

  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
    required String sport,
    required int age,
    required double weight,
    required double height,
  }) {
    return _postForSession(
      '/auth/register',
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'sport': sport,
        'age': age,
        'weight': weight,
        'height': height,
      },
    );
  }

  Future<AuthSession> refreshToken(String refreshToken) {
    return _postForSession(
      '/auth/refresh-token',
      data: {'refreshToken': refreshToken},
    );
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<void>(
        '/auth/logout',
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<AuthSession> _postForSession(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post<Object?>(path, data: data);
      final session = AuthSession.fromApiResponse(response.data);

      if (!session.hasTokens) {
        throw const ApiException(
          'Authentication response did not include tokens',
        );
      }

      return session;
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
      final errorsData = data['data'];
      if (errorsData is Map) {
        final errors = errorsData['errors'];
        if (errors is List && errors.isNotEmpty) {
          final firstError = errors.first;
          if (firstError is Map && firstError['msg'] != null) {
            return firstError['msg'].toString();
          }
        }
      }

      if (data['message'] != null) {
        return data['message'].toString();
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Check that the FitGuard backend is running.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Could not reach the FitGuard backend. Check the API URL and server.';
    }

    return error.message ?? 'Something went wrong. Please try again.';
  }
}
