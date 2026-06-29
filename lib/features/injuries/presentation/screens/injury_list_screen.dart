import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/injury_cubit.dart';
import '../cubit/injury_state.dart';
import '../widgets/log_injury_bottom_sheet.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/status_chip.dart';

class InjuryListScreen extends StatefulWidget {
  const InjuryListScreen({super.key});

  @override
  State<InjuryListScreen> createState() => _InjuryListScreenState();
}

class _InjuryListScreenState extends State<InjuryListScreen> {
  String? _severityFilter;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<InjuryCubit>().getInjuries(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Injury Log'),
      ),
      body: Column(
        children: [
          _buildFilterBar(theme, scheme),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cubit = context.read<InjuryCubit>();
          final created = await LogInjuryBottomSheet.show(context);
          if (created == true && mounted) {
            cubit.getInjuries();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Log Injury'),
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'All',
              selected: _severityFilter == null && _statusFilter == null,
              onSelected: (_) {
                setState(() {
                  _severityFilter = null;
                  _statusFilter = null;
                });
                context.read<InjuryCubit>().getInjuries();
              },
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Mild',
              selected: _severityFilter == 'mild',
              onSelected: (_) {
                setState(() {
                  _severityFilter = 'mild';
                  _statusFilter = null;
                });
                context.read<InjuryCubit>().getInjuries(severity: 'mild');
              },
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Moderate',
              selected: _severityFilter == 'moderate',
              onSelected: (_) {
                setState(() {
                  _severityFilter = 'moderate';
                  _statusFilter = null;
                });
                context.read<InjuryCubit>().getInjuries(severity: 'moderate');
              },
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Severe',
              selected: _severityFilter == 'severe',
              onSelected: (_) {
                setState(() {
                  _severityFilter = 'severe';
                  _statusFilter = null;
                });
                context.read<InjuryCubit>().getInjuries(severity: 'severe');
              },
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Active',
              selected: _statusFilter == 'active',
              onSelected: (_) {
                setState(() {
                  _statusFilter = 'active';
                  _severityFilter = null;
                });
                context
                    .read<InjuryCubit>()
                    .getInjuries(recoveryStatus: 'active');
              },
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Recovered',
              selected: _statusFilter == 'recovered',
              onSelected: (_) {
                setState(() {
                  _statusFilter = 'recovered';
                  _severityFilter = null;
                });
                context
                    .read<InjuryCubit>()
                    .getInjuries(recoveryStatus: 'recovered');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<InjuryCubit, InjuryState>(
      builder: (context, state) {
        if (state is InjuryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is InjuryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<InjuryCubit>().getInjuries(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is InjuriesLoaded) {
          if (state.injuries.isEmpty) {
            return AppEmptyState(
              icon: Icons.healing,
              title: 'No Injuries Logged',
              description:
                  'You haven\'t logged any injuries yet. Tap the button below to record your first injury.',
              actionLabel: 'Log Injury',
              onActionPressed: () async {
                final cubit = context.read<InjuryCubit>();
                final created = await LogInjuryBottomSheet.show(context);
                if (created == true && mounted) {
                  cubit.getInjuries();
                }
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<InjuryCubit>().getInjuries(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.injuries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final injury = state.injuries[index];
                return _InjuryCard(injury: injury);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: scheme.surfaceContainer,
      selectedColor: scheme.primaryContainer,
      checkmarkColor: scheme.onPrimaryContainer,
      side: BorderSide(
        color: selected ? Colors.transparent : scheme.outlineVariant,
      ),
    );
  }
}

class _InjuryCard extends StatelessWidget {
  final dynamic injury;

  const _InjuryCard({required this.injury});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: () async {
          final cubit = context.read<InjuryCubit>();
          await context.push('/dashboard/injuries/${injury.id}');
          cubit.getInjuries();
        },
        borderRadius: BorderRadius.circular(20),
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
                      '${injury.muscleGroup} - ${injury.injuryType}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(
                    label: injury.severity.toUpperCase(),
                    tone: _severityTone(injury.severity),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(injury.dateOccurred),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
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
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
