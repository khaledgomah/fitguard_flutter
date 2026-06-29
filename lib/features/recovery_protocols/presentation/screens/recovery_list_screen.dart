import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/recovery_controller.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_empty_state.dart';

class RecoveryListScreen extends StatefulWidget {
  const RecoveryListScreen({super.key, required this.recoveryController});

  final RecoveryController recoveryController;

  @override
  State<RecoveryListScreen> createState() => _RecoveryListScreenState();
}

class _RecoveryListScreenState extends State<RecoveryListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _injuryNameController = TextEditingController();
  String _selectedType = 'Knee';
  String _selectedSeverity = 'moderate';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.recoveryController.loadProtocols();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _injuryNameController.dispose();
    super.dispose();
  }

  void _showGenerateProtocolDialog() {
    _injuryNameController.text = '';
    _selectedType = 'Knee';
    _selectedSeverity = 'moderate';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              final theme = Theme.of(context);
              final scheme = theme.colorScheme;

              return Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: scheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Generate Recovery Protocol',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our AI will build a personalized rehabilitation program with multiple phases based on your injury details.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _injuryNameController,
                        decoration: const InputDecoration(
                          labelText: 'Injury Name',
                          hintText: 'e.g. Rotator Cuff Strain, ACL Tear',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Injury Body Area',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Knee', child: Text('Knee')),
                          DropdownMenuItem(
                            value: 'Shoulder',
                            child: Text('Shoulder'),
                          ),
                          DropdownMenuItem(
                            value: 'Back',
                            child: Text('Back / Spine'),
                          ),
                          DropdownMenuItem(
                            value: 'Ankle',
                            child: Text('Ankle'),
                          ),
                          DropdownMenuItem(value: 'Hip', child: Text('Hip')),
                          DropdownMenuItem(
                            value: 'Thigh',
                            child: Text('Thigh / Hamstring'),
                          ),
                          DropdownMenuItem(
                            value: 'Elbow / Wrist',
                            child: Text('Elbow / Wrist'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => _selectedType = val);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Severity Level',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          AppChoiceChip(
                            label: 'Mild (Grade 1)',
                            selected: _selectedSeverity == 'mild',
                            onSelected: (val) => setModalState(() => _selectedSeverity = 'mild'),
                          ),
                          AppChoiceChip(
                            label: 'Moderate (Grade 2)',
                            selected: _selectedSeverity == 'moderate',
                            onSelected: (val) => setModalState(() => _selectedSeverity = 'moderate'),
                          ),
                          AppChoiceChip(
                            label: 'Severe (Grade 3)',
                            selected: _selectedSeverity == 'severe',
                            onSelected: (val) => setModalState(() => _selectedSeverity = 'severe'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final name = _injuryNameController.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter the injury name'),
                                ),
                              );
                              return;
                            }
                            final router = GoRouter.of(context);
                            Navigator.pop(context);
                            await widget.recoveryController
                                .generateRecoveryProtocol(
                                  injuryName: name,
                                  injuryType: _selectedType,
                                  severity: _selectedSeverity,
                                );
                            router.go('/recovery/active');
                          },
                          child: const Text('Generate Protocol'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: widget.recoveryController,
      builder: (context, _) {
        final active = widget.recoveryController.activeProtocol;
        final all = widget.recoveryController.protocols;
        final history =
            all
                .where((p) => p.status == 'completed' || p.id != active?.id)
                .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Recovery Protocols'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [Tab(text: 'Active Rehab'), Tab(text: 'History')],
            ),
          ),
          body:
              widget.recoveryController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildActiveTab(active, scheme, theme),
                      _buildHistoryTab(history, scheme, theme),
                    ],
                  ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showGenerateProtocolDialog,
            icon: const Icon(Icons.medical_services_outlined),
            label: const Text('New Protocol'),
          ),
        );
      },
    );
  }

  Widget _buildActiveTab(dynamic active, ColorScheme scheme, ThemeData theme) {
    if (active == null) {
      return AppEmptyState(
        icon: Icons.healing,
        title: 'No Active Recovery Protocol',
        description: 'Dealing with an injury or muscle strain? Generate an AI-guided multi-phase rehabilitation protocol.',
        actionLabel: 'Generate AI Protocol',
        onActionPressed: _showGenerateProtocolDialog,
      );
    }

    final progress = active.overallProgress;
    final currentPhase = active.phases[active.currentPhaseIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      active.injuryType.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      active.severity.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                active.injuryName,
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Current Status:',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentPhase.name,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                currentPhase.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Overall Recovery Progress',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 16,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: scheme.surfaceContainer,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/recovery/active'),
                  child: const Text('Open Active Protocol'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTab(
    List<dynamic> history,
    ColorScheme scheme,
    ThemeData theme,
  ) {
    if (history.isEmpty) {
      return AppEmptyState(
        icon: Icons.history,
        title: 'No History Yet',
        description: 'Completed recovery protocols will appear here.',
        iconColor: scheme.outline.withValues(alpha: 0.6),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = history[index];
        final progress = item.overallProgress;

        return Card(
          child: InkWell(
            onTap: () => context.go('/recovery/details/${item.id}'),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.injuryName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      if (item.status == 'completed')
                        Icon(Icons.verified, color: scheme.primary)
                      else
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        item.injuryType,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: scheme.outlineVariant)),
                      const SizedBox(width: 8),
                      Text(
                        '${item.phases.length} Phases',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
