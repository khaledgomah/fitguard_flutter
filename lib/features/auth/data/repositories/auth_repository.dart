import 'dart:convert';

import '../../../../core/network/api_exception.dart';
import '../models/auth_session.dart';
import '../services/auth_api.dart';
import '../services/token_storage.dart';

class AuthRepository {
  const AuthRepository({
    required AuthApi authApi,
    required TokenStorage tokenStorage,
  }) : _authApi = authApi,
       _tokenStorage = tokenStorage;

  final AuthApi _authApi;
  final TokenStorage _tokenStorage;

  Future<AuthSession?> restoreSession() async {
    final accessToken = await _tokenStorage.readAccessToken();
    final refreshToken = await _tokenStorage.readRefreshToken();
    final savedUser = await _tokenStorage.readUser();

    if (_hasValue(accessToken) &&
        _hasValue(refreshToken) &&
        !_isAccessTokenExpired(accessToken!)) {
      return AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken!,
        user: savedUser,
      );
    }

    if (_hasValue(refreshToken)) {
      try {
        final refreshed = await _authApi.refreshToken(refreshToken!);
        final session = refreshed.copyWith(user: refreshed.user ?? savedUser);
        await _tokenStorage.saveSession(session);
        return session;
      } on ApiException {
        await _tokenStorage.clearSession();
        return null;
      }
    }

    return null;
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final session = await _authApi.login(email: email, password: password);
    await _tokenStorage.saveSession(session);
    return session;
  }

  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
    required String sport,
    required int age,
    required double weight,
    required double height,
  }) async {
    final session = await _authApi.register(
      name: name,
      email: email,
      password: password,
      sport: sport,
      age: age,
      weight: weight,
      height: height,
    );
    await _tokenStorage.saveSession(session);
    return session;
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.readRefreshToken();

    try {
      if (_hasValue(refreshToken)) {
        await _authApi.logout(refreshToken!);
      }
    } finally {
      await _tokenStorage.clearSession();
    }
  }

  Future<bool> hasSeenOnboarding() => _tokenStorage.hasSeenOnboarding();

  Future<void> markOnboardingSeen() => _tokenStorage.markOnboardingSeen();

  bool _hasValue(String? value) => value != null && value.isNotEmpty;

  bool _isAccessTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true;

    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload is! Map || payload['exp'] == null) return true;

      final expirationSeconds = payload['exp'];
      if (expirationSeconds is! num) return true;

      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        expirationSeconds.toInt() * 1000,
      );
      return DateTime.now().isAfter(
        expiresAt.subtract(const Duration(minutes: 1)),
      );
    } on FormatException {
      return true;
    }
  }
}
