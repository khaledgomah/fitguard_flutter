import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../injuries/presentation/widgets/log_injury_bottom_sheet.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../reports/presentation/cubit/reports_cubit.dart';
import '../cubit/recovery_cubit.dart';
import '../cubit/recovery_state.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key, required this.authController});
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return _RecoveryScreenView(authController: authController);
  }
}

class _RecoveryScreenView extends StatelessWidget {
  const _RecoveryScreenView({required this.authController});
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Recovery Protocol', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<RecoveryCubit, RecoveryState>(
        builder: (context, state) {
          if (state is RecoveryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is RecoveryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<RecoveryCubit>().fetchActiveProtocol(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is RecoveryLoaded) {
            final protocol = state.activeProtocol;
            if (protocol == null) {
              return Center(
                child: Text('No active recovery protocol found.', style: theme.textTheme.bodyLarge),
              );
            }

            final phases = protocol['phases'] as List<dynamic>? ?? [];
            final currentPhaseNumber = protocol['currentPhase'] as int? ?? 1;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _HeaderCard(protocol: protocol),
                const SizedBox(height: 24),
                Text('Phases', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...phases.map((p) => _PhaseCard(
                  phase: p, 
                  protocolId: protocol['_id']?.toString() ?? '',
                  isActive: p['phaseNumber'] == currentPhaseNumber,
                )),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await LogInjuryBottomSheet.show(context, authController);
          if (result == true && context.mounted) {
            context.read<DashboardCubit>().fetchDashboardStats();
            context.read<RecoveryCubit>().fetchActiveProtocol();
            context.read<ReportsCubit>().fetchReports();
          }
        },
        icon: const Icon(Icons.medical_services_outlined),
        label: const Text('Log Injury'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Map<String, dynamic> protocol;

  const _HeaderCard({required this.protocol});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Goal: ${protocol['goal'] ?? 'Recovery'}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  protocol['status']?.toUpperCase() ?? 'ACTIVE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Target: ${protocol['target'] ?? 'Full Mobility'}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  final dynamic phase;
  final String protocolId;
  final bool isActive;

  const _PhaseCard({required this.phase, required this.protocolId, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = phase['completed'] == true;
    final exercises = phase['exercises'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Material(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isActive,
          title: Text(
            'Phase ${phase['phaseNumber'] ?? 1}: ${phase['name'] ?? 'Recovery'}',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${phase['durationDays'] ?? 7} Days • ${isCompleted ? 'Completed' : 'Pending'}'),
          leading: Icon(
            isCompleted ? Icons.check_circle : (isActive ? Icons.play_circle_fill : Icons.lock_clock),
            color: isCompleted ? Colors.green : (isActive ? theme.colorScheme.primary : theme.colorScheme.outline),
          ),
          children: [
            if (exercises.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: exercises.map((ex) {
                    final exCompleted = ex['completed'] == true;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        ex['name']?.toString() ?? 'Exercise',
                        style: TextStyle(decoration: exCompleted ? TextDecoration.lineThrough : null),
                      ),
                      subtitle: Text('${ex['sets'] ?? 0} sets x ${ex['reps'] ?? 0} reps'),
                      trailing: IconButton(
                        icon: Icon(
                          exCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                          color: exCompleted ? theme.colorScheme.primary : theme.colorScheme.outline,
                        ),
                        onPressed: () {
                          if (isActive) {
                            context.read<RecoveryCubit>().toggleExercise(protocolId, phase['phaseNumber'], ex['_id']?.toString() ?? '');
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (isActive && !isCompleted)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<RecoveryCubit>().completePhase(protocolId, phase['phaseNumber']);
                    },
                    child: const Text('Complete Phase'),
                  ),
                ),
              )
          ],
        ),
      ),
      ),
    );
  }
}
