import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/challenge_cubit.dart';
import '../cubit/challenge_state.dart';
import '../../data/models/challenge_model.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Challenge'),
      ),
      body: BlocBuilder<ChallengeCubit, ChallengeState>(
        builder: (context, state) {
          if (state is ChallengeLoading || state is ChallengeGenerating) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChallengeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ChallengeCubit>().fetchActiveChallenge(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NoActiveChallenge) {
            return const _EmptyChallengeView();
          }

          if (state is ActiveChallengeLoaded) {
            return _ActiveChallengeView(challenge: state.challenge);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EmptyChallengeView extends StatefulWidget {
  const _EmptyChallengeView();

  @override
  State<_EmptyChallengeView> createState() => _EmptyChallengeViewState();
}

class _EmptyChallengeViewState extends State<_EmptyChallengeView> {
  String _selectedDifficulty = 'intermediate';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Start a 30-Day Challenge',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Let our AI generate a personalized 30-day challenge for you based on your current biomechanics and fitness level.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.outline),
          ),
          const SizedBox(height: 48),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'beginner', label: Text('Beginner')),
              ButtonSegment(value: 'intermediate', label: Text('Intermediate')),
              ButtonSegment(value: 'advanced', label: Text('Advanced')),
            ],
            selected: {_selectedDifficulty},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedDifficulty = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 48),
          FilledButton(
            onPressed: () {
              context.read<ChallengeCubit>().generateChallenge(_selectedDifficulty);
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Generate Challenge', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _ActiveChallengeView extends StatelessWidget {
  const _ActiveChallengeView({required this.challenge});
  final ChallengeModel challenge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calculate progress
    final completedDays = challenge.generatedPlan.where((day) => day.completed).length;
    final progress = completedDays / challenge.generatedPlan.length;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '30-Day ${challenge.sport.toUpperCase()} Challenge',
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Difficulty: ${challenge.difficulty.toUpperCase()}',
                  style: theme.textTheme.labelMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
                    Text('${(progress * 100).toInt()}%', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final day = challenge.generatedPlan[index];
                return _DayCard(day: day, challengeId: challenge.id);
              },
              childCount: challenge.generatedPlan.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextButton(
              onPressed: () {
                _showAbandonDialog(context);
              },
              child: const Text('Abandon Challenge', style: TextStyle(color: Colors.red)),
            ),
          ),
        )
      ],
    );
  }

  void _showAbandonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Abandon Challenge?'),
        content: const Text('Are you sure you want to abandon this challenge? All progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              context.read<ChallengeCubit>().abandonChallenge(challenge.id);
            },
            child: const Text('Abandon', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day, required this.challengeId});
  final ChallengeDay day;
  final String challengeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRestDay = day.exercises.isEmpty && (day.task == null || day.task!.toLowerCase().contains('rest'));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: day.completed ? theme.colorScheme.primaryContainer.withOpacity(0.5) : theme.colorScheme.surface,
      elevation: day.completed ? 0 : 2,
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: day.completed ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: day.completed
                ? const Icon(Icons.check, color: Colors.white)
                : Text('${day.day}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        title: Text(
          isRestDay ? 'Rest Day' : (day.task ?? 'Day ${day.day} Workout'),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            decoration: day.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: isRestDay ? null : Text('${day.exercises.length} exercises'),
        children: [
          if (!isRestDay && day.exercises.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...day.exercises.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 8, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(child: Text('${e.name} - ${e.sets}x${e.reps ?? e.duration ?? ""} ')),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  if (!day.completed)
                    FilledButton(
                      onPressed: () {
                        context.read<ChallengeCubit>().completeDay(challengeId, day.day);
                      },
                      child: const Text('Mark Day Complete'),
                    ),
                ],
              ),
            ),
          if (isRestDay && !day.completed)
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                onPressed: () {
                  context.read<ChallengeCubit>().completeDay(challengeId, day.day);
                },
                child: const Text('Mark Rest Day Complete'),
              ),
            ),
        ],
      ),
    );
  }
}
