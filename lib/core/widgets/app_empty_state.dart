import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 72,
              color: iconColor ?? scheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
