import 'package:fitguard/features/about_us/presentation/widgets/about_us_image_card.dart';
import 'package:flutter/material.dart';

class AboutUsHeroSection extends StatelessWidget {
  const AboutUsHeroSection({super.key, 
    required this.headline,
    required this.body,
    required this.chip,
    required this.imageAsset,
  });

  final String headline;
  final String body;
  final Widget chip;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final textStyleDisplay = theme.textTheme.displayLarge;
    final textStyleBody = theme.textTheme.bodyLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.centerLeft, child: chip),
        const SizedBox(height: 18),
        Text(headline, style: textStyleDisplay),
        const SizedBox(height: 10),
        Text(
          body,
          style: textStyleBody?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 18),
        AboutUsImageCard(
          borderRadius: 16,
          imageAsset: imageAsset,
          height: 300,
        ),
      ],
    );
  }
}