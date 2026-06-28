import 'package:fitguard/features/about_us/presentation/widgets/story_timeline.dart';
import 'package:flutter/material.dart';

class ProductStorySection extends StatelessWidget {
  const ProductStorySection({super.key, 
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String title;
  final String subtitle;
  final List<TimelineItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.displayMedium),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        StoryTimeline(items: items),
      ],
    );
  }
}