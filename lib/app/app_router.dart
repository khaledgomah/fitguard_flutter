import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_placeholder_screen.dart';
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

      if (location == AppRoutes.dashboard) {
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
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) =>
            DashboardPlaceholderScreen(authController: authController),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(state.error?.message ?? 'Screen not found')),
    ),
  );
}
