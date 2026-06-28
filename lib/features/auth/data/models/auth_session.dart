import 'auth_user.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  final String accessToken;
  final String refreshToken;
  final AuthUser? user;

  bool get hasTokens => accessToken.isNotEmpty && refreshToken.isNotEmpty;

  factory AuthSession.fromApiResponse(Object? json) {
    final response = json is Map ? Map<String, dynamic>.from(json) : {};
    final rawData = response['data'] is Map ? response['data'] : response;
    final data = Map<String, dynamic>.from(rawData as Map);
    final rawUser = data['user'];

    return AuthSession(
      accessToken: (data['accessToken'] ?? data['access_token'] ?? '')
          .toString(),
      refreshToken: (data['refreshToken'] ?? data['refresh_token'] ?? '')
          .toString(),
      user: rawUser is Map
          ? AuthUser.fromJson(Map<String, dynamic>.from(rawUser))
          : null,
    );
  }

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    AuthUser? user,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }
}
