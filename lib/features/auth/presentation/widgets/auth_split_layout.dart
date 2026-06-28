import 'package:flutter/material.dart';

class AuthSplitLayout extends StatelessWidget {
  const AuthSplitLayout({
    super.key,
    required this.child,
    this.showHeroPanel = true,
  });

  final Widget child;
  final bool showHeroPanel;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: isWide && showHeroPanel
            ? Row(
                children: [
                  const Expanded(flex: 9, child: _AuthHeroPanel()),
                  Expanded(flex: 11, child: _FormPane(child: child)),
                ],
              )
            : _FormPane(child: child),
      ),
    );
  }
}

class _FormPane extends StatelessWidget {
  const _FormPane({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuthHeroPanel extends StatelessWidget {
  const _AuthHeroPanel();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101915), Color(0xFF1F2F27), Color(0xFF006C49)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -80,
            top: 70,
            child: _PulseRing(color: Colors.white.withValues(alpha: 0.08)),
          ),
          Positioned(
            left: -70,
            bottom: -50,
            child: _PulseRing(
              color: scheme.primaryContainer.withValues(alpha: 0.22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BrandMark(onDark: true),
                const Spacer(),
                Text(
                  'Clinical Precision.\nElite Performance.',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Analyze recovery signals, protect athletes from avoidable injuries, and return stronger.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFE3EAE3),
                  ),
                ),
                const SizedBox(height: 34),
                const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _HeroPill(
                      icon: Icons.verified_user,
                      label: 'Trusted profile',
                    ),
                    _HeroPill(icon: Icons.speed, label: 'Fast telemetry'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthMobileBrand extends StatelessWidget {
  const AuthMobileBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    if (isWide) return const SizedBox.shrink();

    return const Padding(
      padding: EdgeInsets.only(bottom: 36),
      child: Center(child: _BrandMark()),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.monitor_heart,
          color: onDark ? const Color(0xFF4EDEA3) : scheme.primary,
          size: 32,
        ),
        const SizedBox(width: 10),
        Text(
          'FitGuard AI',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: onDark ? Colors.white : scheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFBBF7D0), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 34),
      ),
    );
  }
}
