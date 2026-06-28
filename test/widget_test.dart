import 'package:fitguard/app/fitguard_app.dart';
import 'package:fitguard/features/auth/data/models/auth_session.dart';
import 'package:fitguard/features/auth/data/models/auth_user.dart';
import 'package:fitguard/features/auth/data/repositories/auth_repository.dart';
import 'package:fitguard/features/auth/data/services/auth_api.dart';
import 'package:fitguard/features/auth/data/services/token_storage.dart';
import 'package:fitguard/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitguard/features/challenges/data/datasource/challenges_api.dart';
import 'package:fitguard/features/challenges/data/repositories/challenges_repository_impl.dart';
import 'package:fitguard/features/challenges/presentation/controllers/challenges_controller.dart';
import 'package:fitguard/features/recovery_protocols/data/datasource/recovery_api.dart';
import 'package:fitguard/features/recovery_protocols/data/repositories/recovery_repository_impl.dart';
import 'package:fitguard/features/recovery_protocols/presentation/controllers/recovery_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders onboarding when signed out', (tester) async {
    final storage = _MemoryTokenStorage();
    final repository = AuthRepository(
      authApi: AuthApi(),
      tokenStorage: storage,
    );

    final challengesApi = ChallengesApi();
    final challengesRepository = ChallengesRepositoryImpl(challengesApi: challengesApi);
    final challengesController = ChallengesController(challengesRepository: challengesRepository);

    final recoveryApi = RecoveryApi();
    final recoveryRepository = RecoveryRepositoryImpl(recoveryApi: recoveryApi);
    final recoveryController = RecoveryController(recoveryRepository: recoveryRepository);

    await tester.pumpWidget(
      FitGuardApp(
        authController: AuthController(authRepository: repository),
        challengesController: challengesController,
        recoveryController: recoveryController,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('FitGuard AI'), findsOneWidget);
    expect(find.text('Protect every session'), findsOneWidget);
  });
}

class _MemoryTokenStorage implements TokenStorage {
  AuthSession? _session;
  bool _seenOnboarding = false;

  @override
  Future<void> saveSession(AuthSession session) async {
    _session = session;
  }

  @override
  Future<String?> readAccessToken() async => _session?.accessToken;

  @override
  Future<String?> readRefreshToken() async => _session?.refreshToken;

  @override
  Future<AuthUser?> readUser() async => _session?.user;

  @override
  Future<void> clearSession() async {
    _session = null;
  }

  @override
  Future<bool> hasSeenOnboarding() async => _seenOnboarding;

  @override
  Future<void> markOnboardingSeen() async {
    _seenOnboarding = true;
  }
}
