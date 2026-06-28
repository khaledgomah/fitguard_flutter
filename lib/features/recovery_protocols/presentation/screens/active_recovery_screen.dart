import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/recovery_phase.dart';
import '../../domain/entities/recovery_protocol.dart';
import '../controllers/recovery_controller.dart';
import '../../../../core/widgets/app_empty_state.dart';

class ActiveRecoveryScreen extends StatefulWidget {
  const ActiveRecoveryScreen({super.key, required this.recoveryController});

  final RecoveryController recoveryController;

  @override
  State<ActiveRecoveryScreen> createState() => _ActiveRecoveryScreenState();
}

class _ActiveRecoveryScreenState extends State<ActiveRecoveryScreen> {
  // Store ticked exercises locally to calculate progress percentage dynamically
  final Map<String, Set<String>> _completedExercises = {};
  bool _showSuccessAlert = false;
  String _successMessage = '';

  void _initializeCompletedExercises(RecoveryProtocol protocol) {
    for (final phase in protocol.phases) {
      if (!_completedExercises.containsKey(phase.id)) {
        final total = phase.exercises.length;
        final completedCount = ((phase.progressPercentage / 100.0) * total).round();
        final Set<String> completedSet = {};
        for (int i = 0; i < completedCount && i < total; i++) {
          completedSet.add(phase.exercises[i]);
        }
        _completedExercises[phase.id] = completedSet;
      }
    }
  }

  void _onExerciseToggled(RecoveryProtocol protocol, RecoveryPhase phase, String exercise, bool completed) {
    setState(() {
      final phaseExercises = _completedExercises.putIfAbsent(phase.id, () => <String>{});
      if (completed) {
        phaseExercises.add(exercise);
      } else {
        phaseExercises.remove(exercise);
      }

      // Calculate new percentage
      final total = phase.exercises.length;
      if (total > 0) {
        final progress = (phaseExercises.length / total) * 100.0;
        widget.recoveryController.updatePhaseProgress(
          protocolId: protocol.id,
          phaseId: phase.id,
          progressPercentage: progress,
        );
      }
    });
  }

  Future<void> _completePhase(RecoveryProtocol protocol, RecoveryPhase phase) async {
    await widget.recoveryController.completePhase(
      protocolId: protocol.id,
      phaseId: phase.id,
    );

    setState(() {
      _successMessage = 'Phase ${phase.phaseNumber} Completed Successfully!';
      _showSuccessAlert = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSuccessAlert = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: widget.recoveryController,
      builder: (context, _) {
        final active = widget.recoveryController.activeProtocol;

        if (active == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Active Recovery')),
            body: AppEmptyState(
              icon: Icons.healing,
              title: 'No Active Recovery Protocol',
              description: 'Please browse available recovery protocols and start one to begin tracking.',
              actionLabel: 'Browse Protocols',
              onActionPressed: () => context.go('/recovery'),
            ),
          );
        }

        _initializeCompletedExercises(active);

        final overallProgress = active.overallProgress;

        return Scaffold(
          appBar: AppBar(
            title: Text(active.injuryName),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/recovery'),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall progress header card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overall Rehabilitation Progress',
                              style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: overallProgress,
                                      minHeight: 12,
                                      backgroundColor: scheme.surfaceContainer,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  '${(overallProgress * 100).toInt()}%',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    color: scheme.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Severity: ${active.severity.toUpperCase()} • Type: ${active.injuryType}',
                              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Recovery Phases',
                      style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 14),

                    // List of recovery phases
                    ...active.phases.map((phase) => _buildPhaseCard(active, phase, scheme, theme)),

                    const SizedBox(height: 40),
                  ],
                ),
              ),

              if (_showSuccessAlert)
                Container(
                  color: scheme.shadow.withValues(alpha: 0.6),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stars, size: 90, color: scheme.primary),
                      const SizedBox(height: 20),
                      Text(
                        _successMessage,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium?.copyWith(color: scheme.onPrimary, fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Next phase is now unlocked.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onPrimary.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhaseCard(
    RecoveryProtocol protocol,
    RecoveryPhase phase,
    ColorScheme scheme,
    ThemeData theme,
  ) {
    final isActive = phase.status == 'active';
    final isCompleted = phase.status == 'completed';
    final isLocked = phase.status == 'locked';

    Color cardColor = scheme.surfaceContainerLowest;
    double opacity = 1.0;
    Border? border;

    if (isLocked) {
      cardColor = scheme.surfaceContainer.withValues( alpha: 0.4);
      opacity = 0.5;
    } else if (isActive) {
      border = Border.all(color: scheme.primary, width: 2);
    }

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: border ?? Border.all(color: scheme.outlineVariant),
        ),
        child: ExpansionTile(
          initiallyExpanded: isActive,
          enabled: !isLocked,
          leading: CircleAvatar(
            backgroundColor: isCompleted
                ? scheme.primaryContainer.withValues(alpha: 0.2)
                : (isActive ? scheme.primary : scheme.outlineVariant),
            child: isCompleted
                ? Icon(Icons.check, color: scheme.primary)
                : Text('${phase.phaseNumber}', style: theme.textTheme.titleMedium?.copyWith(color: isActive ? scheme.onPrimary : scheme.onSurface)),
          ),
          title: Text(
            phase.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 18,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? scheme.onSurfaceVariant : null,
            ),
          ),
          subtitle: Text(
            '${phase.progressPercentage.toInt()}% completed',
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phase.description,
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Exercises & Milestones:',
                    style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),

                  // Exercises checkboxes
                  ...phase.exercises.map((exercise) {
                    final isChecked = isCompleted ||
                        (_completedExercises[phase.id]?.contains(exercise) ?? false) ||
                        (phase.progressPercentage >= 100.0);

                    return CheckboxListTile(
                      value: isChecked,
                      enabled: isActive,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        exercise,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked ? scheme.onSurfaceVariant : null,
                        ),
                      ),
                      onChanged: isActive
                          ? (value) => _onExerciseToggled(protocol, phase, exercise, value ?? false)
                          : null,
                    );
                  }),

                  const SizedBox(height: 18),

                  if (isActive)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: phase.progressPercentage >= 100.0
                            ? () => _completePhase(protocol, phase)
                            : null,
                        child: const Text('Complete Phase'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
