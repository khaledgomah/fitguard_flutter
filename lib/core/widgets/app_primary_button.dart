import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.onPressed,
  });

  final String label;
  final AppButtonVariant variant;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton(
          onPressed: onPressed ?? () {},
          child: Text(label),
        );
      case AppButtonVariant.secondary:
        return ElevatedButton(
          onPressed: onPressed ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.secondaryContainer,
            foregroundColor: scheme.onSecondaryContainer,
          ),
          child: Text(label),
        );
      case AppButtonVariant.ghost:
        return OutlinedButton(
          onPressed: onPressed ?? () {},
          child: Text(label),
        );
    }
  }
}
