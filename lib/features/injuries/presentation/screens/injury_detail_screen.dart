import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/injury_log.dart';
import '../../domain/entities/update_injury_dto.dart';
import '../cubit/injury_cubit.dart';
import '../cubit/injury_state.dart';
import '../../../../core/widgets/status_chip.dart';

class InjuryDetailScreen extends StatefulWidget {
  final String injuryId;

  const InjuryDetailScreen({super.key, required this.injuryId});

  @override
  State<InjuryDetailScreen> createState() => _InjuryDetailScreenState();
}

class _InjuryDetailScreenState extends State<InjuryDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<InjuryCubit>().getInjuryById(widget.injuryId),
    );
  }

  StatusTone _severityTone(String severity) {
    return switch (severity) {
      'severe' => StatusTone.danger,
      'moderate' => StatusTone.warning,
      _ => StatusTone.info,
    };
  }

  StatusTone _statusTone(String status) {
    return switch (status) {
      'recovered' => StatusTone.success,
      'active' => StatusTone.warning,
      _ => StatusTone.info,
    };
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Injury'),
        content: const Text(
          'Are you sure you want to delete this injury log? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<InjuryCubit>().deleteInjury(widget.injuryId);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return BlocListener<InjuryCubit, InjuryState>(
      listener: (context, state) {
        if (state is InjurySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Injury updated successfully')),
          );
          context.read<InjuryCubit>().getInjuryById(widget.injuryId);
        } else if (state is InjuryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Injury Details'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditSheet(context, theme, scheme);
                } else if (value == 'delete') {
                  _showDeleteConfirmation();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: BlocBuilder<InjuryCubit, InjuryState>(
          builder: (context, state) {
            if (state is InjuryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is InjuryDetailLoaded) {
              return _buildDetailContent(state.injury, theme, scheme);
            }

            if (state is InjuryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<InjuryCubit>().getInjuryById(
                                widget.injuryId,
                              ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetailContent(
    InjuryLog injury,
    ThemeData theme,
    ColorScheme scheme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
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
                          '${injury.muscleGroup} ${injury.injuryType}',
                          style: theme.textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      StatusChip(
                        label: injury.severity.toUpperCase(),
                        tone: _severityTone(injury.severity),
                      ),
                      const SizedBox(width: 8),
                      StatusChip(
                        label: injury.recoveryStatus.toUpperCase(),
                        tone: _statusTone(injury.recoveryStatus),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    label: 'Muscle Group',
                    value: injury.muscleGroup,
                    icon: Icons.fitness_center,
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Injury Type',
                    value: injury.injuryType,
                    icon: Icons.local_hospital,
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Severity',
                    value: injury.severity,
                    icon: Icons.warning_amber,
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Date Occurred',
                    value:
                        '${injury.dateOccurred.year}-${injury.dateOccurred.month.toString().padLeft(2, '0')}-${injury.dateOccurred.day.toString().padLeft(2, '0')}',
                    icon: Icons.calendar_today,
                  ),
                  if (injury.notes != null && injury.notes!.isNotEmpty) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Notes',
                      value: injury.notes!,
                      icon: Icons.notes,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Timeline',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    label: 'Created',
                    value:
                        '${injury.createdAt.year}-${injury.createdAt.month.toString().padLeft(2, '0')}-${injury.createdAt.day.toString().padLeft(2, '0')}',
                    icon: Icons.add_circle_outline,
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Last Updated',
                    value:
                        '${injury.updatedAt.year}-${injury.updatedAt.month.toString().padLeft(2, '0')}-${injury.updatedAt.day.toString().padLeft(2, '0')}',
                    icon: Icons.update,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showDeleteConfirmation,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Injury'),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.error,
                side: BorderSide(color: scheme.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showEditSheet(
    BuildContext context,
    ThemeData theme,
    ColorScheme scheme,
  ) {
    final injury = (this.context.read<InjuryCubit>().state
            as InjuryDetailLoaded)
        .injury;

    String muscleGroup = injury.muscleGroup;
    String injuryType = injury.injuryType;
    String severity = injury.severity;
    String recoveryStatus = injury.recoveryStatus;

    final muscleGroups = [
      'Hamstring',
      'Knee',
      'Shoulder',
      'Ankle',
      'Lower Back',
      'Quadriceps',
      'Calf',
      'Groin',
    ];
    final injuryTypes = [
      'Strain',
      'Sprain',
      'Tear',
      'Contusion',
      'Fracture',
      'Tendonitis',
      'Dislocation',
    ];
    final severities = ['mild', 'moderate', 'severe'];
    final statuses = ['active', 'recovering', 'recovered'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Injury',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Muscle Group',
                  border: OutlineInputBorder(),
                ),
                initialValue: muscleGroup,
                items: muscleGroups
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (v) => setModalState(() => muscleGroup = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Injury Type',
                  border: OutlineInputBorder(),
                ),
                initialValue: injuryType,
                items: injuryTypes
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (v) => setModalState(() => injuryType = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Severity',
                  border: OutlineInputBorder(),
                ),
                initialValue: severity,
                items: severities
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (v) => setModalState(() => severity = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Recovery Status',
                  border: OutlineInputBorder(),
                ),
                initialValue: recoveryStatus,
                items: statuses
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (v) => setModalState(() => recoveryStatus = v!),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  this.context.read<InjuryCubit>().updateInjury(
                        widget.injuryId,
                        UpdateInjuryDto(
                          muscleGroup:
                              muscleGroup != injury.muscleGroup
                                  ? muscleGroup
                                  : null,
                          injuryType:
                              injuryType != injury.injuryType
                                  ? injuryType
                                  : null,
                          severity:
                              severity != injury.severity
                                  ? severity
                                  : null,
                          recoveryStatus:
                              recoveryStatus != injury.recoveryStatus
                                  ? recoveryStatus
                                  : null,
                        ),
                      );
                  Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: scheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
