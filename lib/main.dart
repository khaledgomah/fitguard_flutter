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

  runApp(
    FitGuardApp(authController: AuthController(authRepository: authRepository)),
  );

}
