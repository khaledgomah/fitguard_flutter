import 'package:flutter/material.dart';

import 'app/fitguard_app.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/services/auth_api.dart';
import 'features/auth/data/services/token_storage.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = SecureTokenStorage();
  final authRepository = AuthRepository(
    authApi: AuthApi(),
    tokenStorage: tokenStorage,
  );

  runApp(
    FitGuardApp(authController: AuthController(authRepository: authRepository)),
  );
}
