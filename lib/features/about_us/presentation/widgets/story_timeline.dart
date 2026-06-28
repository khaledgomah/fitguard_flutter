import 'package:flutter/material.dart';

class StoryTimeline extends StatelessWidget {
  const StoryTimeline({super.key, required this.items});

  final List<TimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == items.length - 1;

        return _TimelineRow(item: item, showConnectorBelow: !isLast);
      }).toList(),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item, required this.showConnectorBelow});

  final TimelineItem item;
  final bool showConnectorBelow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final railColor = scheme.outlineVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                _TimelineDot(isActive: item.isActive),
                if (showConnectorBelow)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: 8),
                      color: railColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(
                    item.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  if (item.callout != null) ...[
                    const SizedBox(height: 14),
                    _CalloutBox(callout: item.callout!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final fillColor = isActive ? scheme.primary : scheme.surfaceContainerLowest;
    final borderColor = isActive ? scheme.primary : scheme.primary;
    final glow = isActive
        ? <BoxShadow>[
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.35),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ]
        : null;

    return Container(
      margin: const EdgeInsets.only(top: 6),
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: glow,
      ),
    );
  }
}

class TimelineItem {
  const TimelineItem({
    required this.title,
    required this.body,
    required this.isActive,
    this.callout,
  });

  final String title;
  final String body;
  final bool isActive;
  final TimelineCallout? callout;
}

class _CalloutBox extends StatelessWidget {
  const _CalloutBox({required this.callout});

  final TimelineCallout callout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final eyebrowStyle = theme.textTheme.labelLarge?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(callout.icon, color: scheme.secondaryContainer, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(callout.eyebrow.toUpperCase(), style: eyebrowStyle),
                const SizedBox(height: 6),
                Text(
                  callout.line,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineCallout {
  const TimelineCallout({
    required this.icon,
    required this.eyebrow,
    required this.line,
  });

  final IconData icon;
  final String eyebrow;
  final String line;
}
