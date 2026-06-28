import 'package:fitguard/features/about_us/presentation/widgets/about_us_hero_section.dart';
import 'package:fitguard/features/about_us/presentation/widgets/product_story_section.dart';
import 'package:fitguard/features/about_us/presentation/widgets/story_timeline.dart';
import 'package:fitguard/features/about_us/presentation/widgets/why_fit_guard_card.dart';
import 'package:fitguard/features/about_us/presentation/widgets/why_fit_guard_section.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/status_chip.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                AboutUsHeroSection(
                  headline: 'Clinical Precision in Motion.',
                  body:
                      'We bridge the gap between high-performance sports technology and rigorous medical science. FitGuard leverages predictive AI to transform biomechanical data into actionable injury prevention strategies.',
                  chip: StatusChip(
                    label: 'Live System',
                    tone: StatusTone.success,
                  ),
                  imageAsset: 'assets/images/hero_section_image.png',
                ),
                SizedBox(height: 24),
                WhyFitGuardSection(
                  title: 'The Intersection of Tech & Healthcare',
                  subtitle:
                      "We don't just track data; we interpret it withclinical rigor. Our platform is built for eliteorganizations that demand more than justgeneric fitness metrics.",
                  cards: [
                    WhyFitGuardCard(
                      variant: WhyFitGuardCardVariant.bordered,
                      icon: Icons.smart_toy,
                      title: 'Predictive AI Engine',
                      body:
                          'Our proprietary models analyze micro-deviations in biomechanical load to flag injury risks before physical symptoms manifest.',
                    ),
                    WhyFitGuardCard(
                      variant: WhyFitGuardCardVariant.solid,
                      icon: Icons.healing,
                      title: 'Clinical Validation',
                      body:
                          'Developed alongside leading orthopedic surgeons and sports physiotherapists to ensure diagnostic-grade accuracy.',
                    ),
                    WhyFitGuardCard(
                      variant: WhyFitGuardCardVariant.borderedAccent,
                      icon: Icons.refresh,
                      title: 'Dynamic Recovery',
                      body:
                          'Protocol adjustments made in real-time based on sleep architecture and HRV recovery scores.',
                    ),
                    WhyFitGuardCard(
                      variant: WhyFitGuardCardVariant.imageOverlay,
                      icon: Icons.sync,
                      title: 'Ecosystem Integration',
                      body:
                          'Seamlessly syncs with Whoop, Oura, Garmin, and proprietary team force-plate data to create a unified athlete profile.',
                      imageAsset:
                          'assets/images/ecosystem_integration_image.png',
                    ),
                  ],
                ),
                SizedBox(height: 24),
                ProductStorySection(
                  title: 'The Evolution of Prevention',
                  subtitle:
                      'How we moved from reactive treatment to proactive optimization.',
                  items: [
                    TimelineItem(
                      title: 'The Data Explosion',
                      body:
                          'Teams were drowning in biometric data but lacking context. Wearables tracked everything, but isolated metrics failed to provide a cohesive picture of athlete readiness.',
                      isActive: false,
                    ),
                    TimelineItem(
                      title: 'Introducing the AI Layer',
                      body:
                          'We built an intelligent translation layer. By feeding historical injury data and real-time biomechanics into our models, FitGuard began recognizing the invisible patterns that precede soft-tissue injuries.',
                      isActive: false,
                      callout: TimelineCallout(
                        icon: Icons.smart_toy,
                        eyebrow: 'INSIGHT GENERATION',
                        line:
                            'Processing 1.2M data points per athleteper session to calculate acute-to-chronic workload ratios.',
                      ),
                    ),
                    TimelineItem(
                      title: 'The Standard of Care',
                      body:
                          'Today, FitGuard serves as the central nervous system for top-tier athletic organizations, bridging the gap between the weight room, the practice field, and the medical staff.',
                      isActive: true,
                    ),
                  ],
                ),
                SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
