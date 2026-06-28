import 'package:flutter/foundation.dart';

import '../../data/models/auth_session.dart';
import '../../data/models/auth_user.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus { initial, checking, authenticated, unauthenticated }

class AuthController extends ChangeNotifier {
  AuthController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.initial;
  AuthSession? _session;
  bool _hasSeenOnboarding = false;

  AuthStatus get status => _status;

  AuthSession? get session => _session;

  AuthUser? get user => _session?.user;

  bool get isAuthenticated => _status == AuthStatus.authenticated;

  bool get hasSeenOnboarding => _hasSeenOnboarding;

  Future<void> restoreSession() async {
    if (_status == AuthStatus.checking) return;

    _status = AuthStatus.checking;
    notifyListeners();

    _hasSeenOnboarding = await _authRepository.hasSeenOnboarding();
    final restoredSession = await _authRepository.restoreSession();

    if (restoredSession != null && restoredSession.hasTokens) {
      _session = restoredSession;
      _status = AuthStatus.authenticated;
    } else {
      _session = null;
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    await _authRepository.markOnboardingSeen();
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    final authSession = await _authRepository.login(
      email: email,
      password: password,
    );
    _session = authSession;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String sport,
    required int age,
    required double weight,
    required double height,
  }) async {
    final authSession = await _authRepository.register(
      name: name,
      email: email,
      password: password,
      sport: sport,
      age: age,
      weight: weight,
      height: height,
    );
    _session = authSession;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _session = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
