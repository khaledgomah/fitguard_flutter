import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/challenges_controller.dart';
import '../../../../core/widgets/app_choice_chip.dart';
import '../../../../core/widgets/app_empty_state.dart';

class ChallengeListScreen extends StatefulWidget {
  const ChallengeListScreen({super.key, required this.challengesController});

  final ChallengesController challengesController;

  @override
  State<ChallengeListScreen> createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _titleController = TextEditingController();
  String _selectedType = 'injury_prevention';
  String _selectedDifficulty = 'intermediate';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.challengesController.loadChallenges();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _showGenerateChallengeDialog() {
    _titleController.text = '';
    _selectedType = 'injury_prevention';
    _selectedDifficulty = 'intermediate';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final theme = Theme.of(context);
          final scheme = theme.colorScheme;

          return Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                    'Generate AI Challenge',
                    style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our AI will build a personalized 30-day program tailored to your fitness goals and recovery needs.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Challenge Name',
                      hintText: 'e.g. Core Stability Booster',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Challenge Type', style: theme.textTheme.headlineSmall?.copyWith(fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      AppChoiceChip(
                        label: 'Injury Prevention',
                        selected: _selectedType == 'injury_prevention',
                        onSelected: (val) => setModalState(() => _selectedType = 'injury_prevention'),
                      ),
                      AppChoiceChip(
                        label: 'Mobility',
                        selected: _selectedType == 'mobility',
                        onSelected: (val) => setModalState(() => _selectedType = 'mobility'),
                      ),
                      AppChoiceChip(
                        label: 'Strength',
                        selected: _selectedType == 'strength',
                        onSelected: (val) => setModalState(() => _selectedType = 'strength'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Difficulty Level', style: theme.textTheme.headlineSmall?.copyWith(fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      AppChoiceChip(
                        label: 'Beginner',
                        selected: _selectedDifficulty == 'beginner',
                        onSelected: (val) => setModalState(() => _selectedDifficulty = 'beginner'),
                      ),
                      AppChoiceChip(
                        label: 'Intermediate',
                        selected: _selectedDifficulty == 'intermediate',
                        onSelected: (val) => setModalState(() => _selectedDifficulty = 'intermediate'),
                      ),
                      AppChoiceChip(
                        label: 'Advanced',
                        selected: _selectedDifficulty == 'advanced',
                        onSelected: (val) => setModalState(() => _selectedDifficulty = 'advanced'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = _titleController.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a challenge name')),
                          );
                          return;
                        }
                        final router = GoRouter.of(context);
                        Navigator.pop(context);
                        await widget.challengesController.generateChallenge(
                          title: name,
                          type: _selectedType,
                          difficulty: _selectedDifficulty,
                        );
                        router.go('/challenges/active');
                      },
                      child: const Text('Generate Program'),
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
      listenable: widget.challengesController,
      builder: (context, _) {
        final active = widget.challengesController.activeChallenge;
        final all = widget.challengesController.challenges;
        final history = all.where((c) => c.isCompleted || c.id != active?.id).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Challenges'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Active Program'),
                Tab(text: 'History'),
              ],
            ),
          ),
          body: widget.challengesController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildActiveTab(active, scheme, theme),
                    _buildHistoryTab(history, scheme, theme),
                  ],
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showGenerateChallengeDialog,
            icon: const Icon(Icons.psychology),
            label: const Text('Generate Challenge'),
          ),
        );
      },
    );
  }

  Widget _buildActiveTab(dynamic active, ColorScheme scheme, ThemeData theme) {
    if (active == null) {
      return AppEmptyState(
        icon: Icons.bolt,
        title: 'No Active Program',
        description: 'Ready to push your limits? Generate a custom AI-guided 30-day recovery or performance challenge.',
        actionLabel: 'Generate with AI',
        onActionPressed: _showGenerateChallengeDialog,
      );
    }

    final progress = active.progressPercentage;

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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      active.type.toUpperCase().replaceAll('_', ' '),
                      style: theme.textTheme.labelLarge?.copyWith(color: scheme.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      active.difficulty.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(color: scheme.secondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(active.title, style: theme.textTheme.displayMedium?.copyWith(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                active.description,
                style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progress', style: theme.textTheme.headlineSmall?.copyWith(fontSize: 16)),
                  Text(
                    '${(progress * 100).toInt()}% Done',
                    style: theme.textTheme.headlineSmall?.copyWith(fontSize: 16, color: scheme.primary),
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
              const SizedBox(height: 12),
              Text(
                'Day ${active.currentDay} of ${active.durationDays}',
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/challenges/active'),
                  child: const Text('Continue Challenge'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTab(List<dynamic> history, ColorScheme scheme, ThemeData theme) {
    if (history.isEmpty) {
      return AppEmptyState(
        icon: Icons.history,
        title: 'No History Yet',
        description: 'Completed challenges will appear here.',
        iconColor: scheme.outline.withValues(alpha: 0.6),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = history[index];
        final progress = item.progressPercentage;

        return Card(
          child: InkWell(
            onTap: () => context.go('/challenges/details/${item.id}'),
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
                        item.title,
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                      ),
                      if (item.isCompleted)
                        Icon(Icons.check_circle, color: scheme.primary)
                      else
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: theme.textTheme.titleMedium?.copyWith(color: scheme.primary, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant, fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${item.durationDays} Days',
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(width: 14),
                      Icon(Icons.fitness_center, size: 14, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        item.difficulty,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
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
