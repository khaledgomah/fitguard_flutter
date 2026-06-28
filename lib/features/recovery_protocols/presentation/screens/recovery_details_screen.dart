import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/recovery_controller.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_header_card.dart';

class RecoveryDetailsScreen extends StatelessWidget {
  const RecoveryDetailsScreen({
    super.key,
    required this.protocolId,
    required this.recoveryController,
  });

  final String protocolId;
  final RecoveryController recoveryController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: recoveryController,
      builder: (context, _) {
        final protocolIndex = recoveryController.protocols.indexWhere((p) => p.id == protocolId);
        if (protocolIndex == -1) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Recovery Details'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/recovery'),
              ),
            ),
            body: const Center(child: Text('Recovery Protocol not found')),
          );
        }

        final protocol = recoveryController.protocols[protocolIndex];
        final progress = protocol.overallProgress;

        return Scaffold(
          appBar: AppBar(
            title: Text(protocol.injuryName),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/recovery'),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overall progress header card
                      AppHeaderCard(
                        title: protocol.injuryName,
                        progressLabel: 'Rehabilitation Status',
                        progressValue: progress,
                        badges: [
                          AppBadge(
                            label: protocol.injuryType.toUpperCase(),
                            backgroundColor: scheme.primaryContainer.withValues(alpha: 0.3),
                            textColor: scheme.primary,
                          ),
                          AppBadge(
                            label: protocol.severity.toUpperCase(),
                            backgroundColor: scheme.errorContainer.withValues(alpha: 0.4),
                            textColor: scheme.error,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Phases Breakdown',
                        style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final phase = protocol.phases[index];
                      final isCompleted = phase.status == 'completed';
                      final isActive = phase.status == 'active';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Phase ${phase.phaseNumber}: ${phase.name}',
                                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                                    ),
                                  ),
                                  if (isCompleted)
                                    Icon(Icons.check_circle, color: scheme.primary)
                                  else if (isActive)
                                    Icon(Icons.play_circle_outline, color: scheme.primary)
                                  else
                                    Icon(Icons.lock_outline, color: scheme.outline),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                phase.description,
                                style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                isCompleted ? 'Completed Exercises:' : 'Exercises & Targets:',
                                style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 6),
                              ...phase.exercises.map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isCompleted
                                              ? Icons.check_circle
                                              : (isActive ? Icons.radio_button_unchecked : Icons.lock_outline),
                                          color: isCompleted
                                              ? scheme.primary
                                              : (isActive ? scheme.primary : scheme.outline),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            e,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                                              color: isCompleted ? scheme.onSurfaceVariant : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: protocol.phases.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          ),
        );
      },
    );
  }
}
