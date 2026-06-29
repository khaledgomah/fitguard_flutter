import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_session.dart';
import '../models/auth_user.dart';

abstract class TokenStorage {
  Future<void> saveSession(AuthSession session);

  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<AuthUser?> readUser();

  Future<void> clearSession();

  Future<bool> hasSeenOnboarding();

  Future<void> markOnboardingSeen();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );

  static const _accessTokenKey = 'fitguard_access_token';
  static const _refreshTokenKey = 'fitguard_refresh_token';
  static const _userKey = 'fitguard_auth_user';
  static const _onboardingKey = 'fitguard_seen_onboarding';

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> saveSession(AuthSession session) async {
    await _secureStorage.write(
      key: _accessTokenKey,
      value: session.accessToken,
    );
    await _secureStorage.write(
      key: _refreshTokenKey,
      value: session.refreshToken,
    );
    final user = session.user;
    if (user != null) {
      await _secureStorage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
    }
  }

  @override
  Future<String?> readAccessToken() =>
      _secureStorage.read(key: _accessTokenKey);

  @override
  Future<String?> readRefreshToken() =>
      _secureStorage.read(key: _refreshTokenKey);

  @override
  Future<AuthUser?> readUser() async {
    final rawUser = await _secureStorage.read(key: _userKey);
    if (rawUser == null || rawUser.isEmpty) return null;

    try {
      final decoded = jsonDecode(rawUser);
      if (decoded is Map) {
        return AuthUser.fromJson(Map<String, dynamic>.from(decoded));
      }
      return null;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _userKey);
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    final value = await _secureStorage.read(key: _onboardingKey);
    return value == 'true';
  }

  @override
  Future<void> markOnboardingSeen() {
    return _secureStorage.write(key: _onboardingKey, value: 'true');
  }
}
