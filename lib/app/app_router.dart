import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/biometrics/presentation/screens/biometrics_screen.dart';
import '../features/recovery_protocols/presentation/screens/recovery_screen.dart';
import '../features/reports/presentation/screens/reports_screen.dart';
import '../features/challenges/presentation/screens/challenge_screen.dart';
import 'presentation/screens/main_scaffold.dart';
import 'presentation/widgets/authenticated_providers.dart';
import 'app_routes.dart';

GoRouter createAppRouter(AuthController authController) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authController,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final authLocations = {
        AppRoutes.onboarding,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
      };

      if (authController.status == AuthStatus.initial ||
          authController.status == AuthStatus.checking) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      if (authController.isAuthenticated) {
        if (location == AppRoutes.splash || authLocations.contains(location)) {
          return AppRoutes.dashboard;
        }
        return null;
      }

      if (location == AppRoutes.splash) {
        return authController.hasSeenOnboarding
            ? AppRoutes.login
            : AppRoutes.onboarding;
      }

      if (!authLocations.contains(location) && location != AppRoutes.splash) {
        return AppRoutes.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) =>
            SplashScreen(authController: authController),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) =>
            OnboardingScreen(authController: authController),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            LoginScreen(authController: authController),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) =>
            RegisterScreen(authController: authController),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AuthenticatedProviders(
            authController: authController,
            child: MainScaffold(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) =>
                    DashboardScreen(authController: authController),
                routes: [
                  GoRoute(
                    path: 'challenge',
                    builder: (context, state) => const ChallengeScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/biometrics',
                builder: (context, state) => BiometricsScreen(authController: authController),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/recovery',
                builder: (context, state) => RecoveryScreen(authController: authController),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => ReportsScreen(authController: authController),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) =>
                    ProfileScreen(authController: authController),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) =>
            EditProfileScreen(authController: authController),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(state.error?.message ?? 'Screen not found')),
    ),
  );
}
