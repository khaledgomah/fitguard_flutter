import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/challenges_controller.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_header_card.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  const ChallengeDetailsScreen({
    super.key,
    required this.challengeId,
    required this.challengesController,
  });

  final String challengeId;
  final ChallengesController challengesController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: challengesController,
      builder: (context, _) {
        final challengeIndex = challengesController.challenges.indexWhere((c) => c.id == challengeId);
        if (challengeIndex == -1) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Challenge Details'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/challenges'),
              ),
            ),
            body: const Center(child: Text('Challenge not found')),
          );
        }

        final challenge = challengesController.challenges[challengeIndex];
        final progress = challenge.progressPercentage;

        return Scaffold(
          appBar: AppBar(
            title: Text(challenge.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/challenges'),
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
                      // Header stats card
                      AppHeaderCard(
                        title: challenge.title,
                        description: challenge.description,
                        progressLabel: 'Completion Progress',
                        progressValue: progress,
                        badges: [
                          AppBadge(
                            label: challenge.type.toUpperCase().replaceAll('_', ' '),
                            backgroundColor: scheme.primaryContainer.withValues(alpha: 0.3),
                            textColor: scheme.primary,
                          ),
                          AppBadge(
                            label: challenge.difficulty.toUpperCase(),
                            backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.3),
                            textColor: scheme.secondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        '30-Day Task Log',
                        style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList.separated(
                  itemCount: challenge.dailyTasks.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final task = challenge.dailyTasks[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        final active = challengesController.activeChallenge;
                        if (active != null && active.id == challenge.id) {
                          context.go('/challenges/active?day=${task.day}');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You can only track tasks for your active challenge.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      leading: CircleAvatar(
                        backgroundColor: task.isCompleted
                            ? scheme.primaryContainer.withValues(alpha: 0.2)
                            : scheme.surfaceContainer,
                        child: task.isCompleted
                            ? Icon(Icons.check, color: scheme.primary)
                            : Text('${task.day}', style: TextStyle(color: scheme.onSurface)),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? scheme.onSurfaceVariant : null,
                        ),
                      ),
                      subtitle: Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      trailing: Text(
                        '${task.durationMinutes} min',
                        style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    );
                  },
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
