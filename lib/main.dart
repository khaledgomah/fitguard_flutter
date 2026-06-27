import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_primary_button.dart';
import 'core/widgets/app_section_header.dart';
import 'core/widgets/app_stat_card.dart';
import 'core/widgets/app_surface_card.dart';
import 'core/widgets/status_chip.dart';

void main() {
  runApp(const FitGuardApp());
}

class FitGuardApp extends StatelessWidget {
  const FitGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitGuard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const FitGuardHomePage(),
    );
  }
}

class FitGuardHomePage extends StatelessWidget {
  const FitGuardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const _HeroBanner(),
                    const SizedBox(height: 24),
                    const AppSectionHeader(
                      title: 'Design System',
                      subtitle:
                          'Flutter tokens now mirror the web palette, spacing, and card language.',
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isCompact = constraints.maxWidth < 900;
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: isCompact
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth - 32) / 3,
                              child: const AppStatCard(
                                label: 'Activity Score',
                                value: '87%',
                                helper: '7-day completion rate',
                                accentColor: Color(0xFF10B981),
                              ),
                            ),
                            SizedBox(
                              width: isCompact
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth - 32) / 3,
                              child: const AppStatCard(
                                label: 'Recovery',
                                value: 'In Progress',
                                helper: 'Phase 3 of 5',
                                accentColor: Color(0xFF006C49),
                              ),
                            ),
                            SizedBox(
                              width: isCompact
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth - 32) / 3,
                              child: const AppStatCard(
                                label: 'Alerts',
                                value: '2 Open',
                                helper: 'Needs follow-up today',
                                accentColor: Color(0xFFBA1A1A),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: 360,
                          child: AppSurfaceCard(
                            title: 'Primary Actions',
                            child: _ActionColumn(),
                          ),
                        ),
                        SizedBox(
                          width: 360,
                          child: AppSurfaceCard(
                            title: 'Surface States',
                            child: _StateColumn(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF4FBF4), Color(0xFFE8F0E9)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusChip(label: 'Live System', tone: StatusTone.success),
          const SizedBox(height: 18),
          Text('FitGuard', style: theme.textTheme.displaySmall),
          const SizedBox(height: 8),
          Text(
            'A calmer health and performance shell built around the same clean surface language as the web app.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppPrimaryButton(label: 'Generate Report'),
              AppPrimaryButton(
                label: 'Log Injury',
                variant: AppButtonVariant.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionColumn extends StatelessWidget {
  const _ActionColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusChip(label: 'Primary', tone: StatusTone.info),
        SizedBox(height: 12),
        Text(
          'Use cards with soft borders, restrained elevation, and compact spacing.',
        ),
        SizedBox(height: 12),
        AppPrimaryButton(label: 'Open Dashboard'),
      ],
    );
  }
}

class _StateColumn extends StatelessWidget {
  const _StateColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusChip(label: 'Warning', tone: StatusTone.warning),
        SizedBox(height: 12),
        Text(
          'Prefer surface containers over flat fills for lists, panels, and summary blocks.',
        ),
        SizedBox(height: 12),
        AppPrimaryButton(
          label: 'Review Alerts',
          variant: AppButtonVariant.ghost,
        ),
      ],
    );
  }
}
