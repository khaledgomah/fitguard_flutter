import 'package:fitguard/features/about_us/presentation/widgets/about_us_image_card.dart';
import 'package:fitguard/features/about_us/presentation/widgets/why_fit_guard_section.dart';
import 'package:flutter/material.dart';

class WhyFitGuardCard extends StatelessWidget {
  const WhyFitGuardCard({super.key, 
    required this.variant,
    required this.icon,
    required this.title,
    required this.body,
    this.imageAsset,
  });

  final WhyFitGuardCardVariant variant;
  final IconData icon;
  final String title;
  final String body;
  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final iconColor = switch (variant) {
      WhyFitGuardCardVariant.solid => scheme.onPrimary,
      WhyFitGuardCardVariant.borderedAccent => scheme.secondaryContainer,
      WhyFitGuardCardVariant.imageOverlay => scheme.tertiary,
      WhyFitGuardCardVariant.bordered => scheme.primary,
    };

    final cardTextColor = switch (variant) {
      WhyFitGuardCardVariant.solid => scheme.onPrimary,
      WhyFitGuardCardVariant.imageOverlay => scheme.onSurface,
      WhyFitGuardCardVariant.borderedAccent => scheme.onSurface,
      WhyFitGuardCardVariant.bordered => scheme.onSurface,
    };

    final backgroundColor = switch (variant) {
      WhyFitGuardCardVariant.solid => scheme.primary,
      WhyFitGuardCardVariant.imageOverlay => scheme.surfaceContainerLowest,
      WhyFitGuardCardVariant.borderedAccent => scheme.surfaceContainerLowest,
      WhyFitGuardCardVariant.bordered => scheme.surfaceContainerLowest,
    };

    final borderSide = switch (variant) {
      WhyFitGuardCardVariant.bordered => BorderSide(color: scheme.outlineVariant),
      WhyFitGuardCardVariant.borderedAccent => BorderSide(color: scheme.outlineVariant),
      WhyFitGuardCardVariant.imageOverlay => BorderSide(color: scheme.outlineVariant),
      WhyFitGuardCardVariant.solid => const BorderSide(color: Colors.transparent),
    };

    const radius = 8.0;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.fromBorderSide(borderSide),
      ),
      child: Stack(
        children: [
          if (variant ==WhyFitGuardCardVariant.imageOverlay && imageAsset != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: AboutUsImageCard(
                imageAsset: imageAsset!,
                borderRadius : 16,
                height: 300,
              ),
            ),
          if (variant == WhyFitGuardCardVariant.imageOverlay)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      scheme.surfaceContainerLowest.withValues(alpha: 0.95),
                      scheme.surfaceContainerLowest.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 40),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(color: cardTextColor),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    body,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cardTextColor == scheme.onPrimary
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                    ),
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
