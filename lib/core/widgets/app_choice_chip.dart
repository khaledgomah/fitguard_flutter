import 'package:flutter/material.dart';

class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: scheme.primaryContainer.withValues(alpha: 0.3),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: selected ? scheme.primary : scheme.onSurface,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
