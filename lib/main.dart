import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitguard/app/fitguard_app.dart';
import 'package:fitguard/core/services/firebase_service.dart';
import 'package:fitguard/core/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/services/auth_api.dart';
import 'features/auth/data/services/token_storage.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/challenges/data/datasource/challenges_api.dart';
import 'features/challenges/data/repositories/challenges_repository_impl.dart';
import 'features/challenges/presentation/controllers/challenges_controller.dart';
import 'features/recovery_protocols/data/datasource/recovery_api.dart';
import 'features/recovery_protocols/data/repositories/recovery_repository_impl.dart';
import 'features/recovery_protocols/presentation/controllers/recovery_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await FirebaseService.initialize();
  await NotificationService.initialize();
  await NotificationService.getDeviceToken();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  final tokenStorage = SecureTokenStorage();
  final authRepository = AuthRepository(
    authApi: AuthApi(),
    tokenStorage: tokenStorage,
  );

  final authController = AuthController(authRepository: authRepository);

  final challengesApi = ChallengesApi();
  final challengesRepository = ChallengesRepositoryImpl(challengesApi: challengesApi);
  final challengesController = ChallengesController(challengesRepository: challengesRepository);

  final recoveryApi = RecoveryApi();
  final recoveryRepository = RecoveryRepositoryImpl(recoveryApi: recoveryApi);
  final recoveryController = RecoveryController(recoveryRepository: recoveryRepository);

  authController.addListener(() {
    final token = authController.session?.accessToken;
    challengesApi.updateToken(token);
    recoveryApi.updateToken(token);
  });

  final initialToken = authController.session?.accessToken;
  challengesApi.updateToken(initialToken);
  recoveryApi.updateToken(initialToken);

  runApp(
    FitGuardApp(
      authController: authController,
      challengesController: challengesController,
      recoveryController: recoveryController,
    ),
  );

}

