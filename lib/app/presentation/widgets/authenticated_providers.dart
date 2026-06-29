import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/dashboard/data/repositories/dashboard_repository.dart';
import '../../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../features/notifications/data/repositories/notification_repository.dart';
import '../../../features/notifications/presentation/cubit/notification_cubit.dart';
import '../../../features/recovery_protocols/data/repositories/recovery_repository.dart';
import '../../../features/recovery_protocols/presentation/cubit/recovery_cubit.dart';
import '../../../features/reports/presentation/cubit/reports_cubit.dart';
import '../../../features/challenges/data/repositories/challenge_repository.dart';
import '../../../features/challenges/presentation/cubit/challenge_cubit.dart';

class AuthenticatedProviders extends StatefulWidget {
  final Widget child;
  final AuthController authController;

  const AuthenticatedProviders({
    super.key,
    required this.child,
    required this.authController,
  });

  @override
  State<AuthenticatedProviders> createState() => _AuthenticatedProvidersState();
}

class _AuthenticatedProvidersState extends State<AuthenticatedProviders> {
  late final Dio _dio;
  late final DashboardCubit _dashboardCubit;
  late final RecoveryCubit _recoveryCubit;
  late final ReportsCubit _reportsCubit;
  late final ChallengeCubit _challengeCubit;
  late final NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();

    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:5000',
        headers: {
          'Authorization':
              'Bearer ${widget.authController.session?.accessToken ?? ''}',
        },
      ),
    );

    final dashboardRepository = DashboardRepository(dio: _dio);

    _dashboardCubit = DashboardCubit(dashboardRepository: dashboardRepository)
      ..fetchDashboardStats();
    _recoveryCubit = RecoveryCubit(repository: RecoveryRepository(dio: _dio))
      ..fetchActiveProtocol();
    _reportsCubit = ReportsCubit(repository: dashboardRepository)
      ..fetchReports();
    _challengeCubit = ChallengeCubit(repository: ChallengeRepository(dio: _dio))
      ..fetchActiveChallenge();
    _notificationCubit = NotificationCubit(
      repository: NotificationRepository(dio: _dio),
    );
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    _recoveryCubit.close();
    _reportsCubit.close();
    _challengeCubit.close();
    _notificationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardCubit>.value(value: _dashboardCubit),
        BlocProvider<RecoveryCubit>.value(value: _recoveryCubit),
        BlocProvider<ReportsCubit>.value(value: _reportsCubit),
        BlocProvider<ChallengeCubit>.value(value: _challengeCubit),
        BlocProvider<NotificationCubit>.value(value: _notificationCubit),
      ],
      child: widget.child,
    );
  }
}
