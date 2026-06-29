import 'package:fitguard/features/about_us/presentation/widgets/why_fit_guard_card.dart';
import 'package:flutter/material.dart';

enum WhyFitGuardCardVariant { bordered, solid, borderedAccent, imageOverlay }

class WhyFitGuardSection extends StatelessWidget {
  const WhyFitGuardSection({super.key, 
    required this.title,
    required this.subtitle,
    required this.cards,
  });

  final String title;
  final String subtitle;
  final List<WhyFitGuardCard> cards;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        border: const Border(
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: theme.textTheme.displayMedium, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  for (final card in cards) ...[
                    card,
                    const SizedBox(height: 24),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}