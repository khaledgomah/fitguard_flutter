import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_primary_button.dart';
import 'core/widgets/app_section_header.dart';
import 'core/widgets/app_stat_card.dart';
import 'core/widgets/app_surface_card.dart';
import 'core/widgets/status_chip.dart';

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
