import 'package:flutter/material.dart';

class AppHeaderCard extends StatelessWidget {
  const AppHeaderCard({
    super.key,
    required this.title,
    this.description,
    required this.badges,
    required this.progressLabel,
    required this.progressValue,
  });

  final String title;
  final String? description;
  final List<Widget> badges;
  final String progressLabel;
  final double progressValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badges.isNotEmpty) ...[
              Row(
                children: [
                  for (int i = 0; i < badges.length; i++) ...[
                    badges[i],
                    if (i < badges.length - 1) const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 18),
            ],
            Text(
              title,
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
            ),
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progressLabel,
                  style: theme.textTheme.headlineSmall?.copyWith(fontSize: 16),
                ),
                Text(
                  '${(progressValue * 100).toInt()}% Done',
                  style: theme.textTheme.headlineSmall?.copyWith(fontSize: 16, color: scheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 10,
                backgroundColor: scheme.surfaceContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
