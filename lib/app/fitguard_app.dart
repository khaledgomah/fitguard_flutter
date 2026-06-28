import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/challenges/presentation/controllers/challenges_controller.dart';
import '../features/recovery_protocols/presentation/controllers/recovery_controller.dart';
import 'app_router.dart';

class FitGuardApp extends StatefulWidget {
  const FitGuardApp({
    super.key,
    required this.authController,
    required this.challengesController,
    required this.recoveryController,
  });

  final AuthController authController;
  final ChallengesController challengesController;
  final RecoveryController recoveryController;

  @override
  State<FitGuardApp> createState() => _FitGuardAppState();
}

class _FitGuardAppState extends State<FitGuardApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(
      widget.authController,
      widget.challengesController,
      widget.recoveryController,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitGuard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}

