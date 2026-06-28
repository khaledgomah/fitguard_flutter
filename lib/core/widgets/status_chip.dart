import 'package:flutter/material.dart';

enum StatusTone { success, info, warning, danger }

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.tone,
  });

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (background, foreground) = switch (tone) {
      StatusTone.success => (scheme.primaryContainer, scheme.onPrimaryContainer),
      StatusTone.info => (scheme.surfaceContainer, scheme.onSurface),
      StatusTone.warning => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
      StatusTone.danger => (scheme.errorContainer, scheme.onErrorContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: foreground,
            ),
      ),
    );
  }
}
