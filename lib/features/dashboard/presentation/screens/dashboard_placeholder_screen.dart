import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class DashboardPlaceholderScreen extends StatefulWidget {
  const DashboardPlaceholderScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<DashboardPlaceholderScreen> createState() =>
      _DashboardPlaceholderScreenState();
}

class _DashboardPlaceholderScreenState
    extends State<DashboardPlaceholderScreen> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    await widget.authController.logout();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = widget.authController.user;
    final firstName = user?.name.trim().split(RegExp(r'\s+')).first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitGuard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: _isLoggingOut ? null : _logout,
              icon:
                  _isLoggingOut
                      ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome${firstName == null || firstName.isEmpty ? '' : ', $firstName'}',
                          style: theme.textTheme.displayMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Authentication is connected. Member 2 can replace this placeholder with the dashboard.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'AI Modules (Member 4 Features)',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 600;
                      final modules = [
                        _ModuleNavigationCard(
                          icon: Icons.psychology,
                          title: 'AI Challenges',
                          description:
                              'Personalized 30-day training challenges for mobility, strength, and injury prevention.',
                          buttonText: 'Open Challenges',
                          onTap: () => context.go(AppRoutes.challenges),
                          color: scheme.primary,
                        ),
                        _ModuleNavigationCard(
                          icon: Icons.healing,
                          title: 'Recovery Protocols',
                          description:
                              'AI-generated rehabilitation protocols to guide you safely back to sports.',
                          buttonText: 'Open Protocols',
                          onTap: () => context.go(AppRoutes.recovery),
                          color: scheme.secondary,
                        ),
                      ];

                      if (isCompact) {
                        return Column(
                          children: [
                            modules[0],
                            const SizedBox(height: 14),
                            modules[1],
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: modules[0]),
                          const SizedBox(width: 14),
                          Expanded(child: modules[1]),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'System Status',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 680;
                      final cards = [
                        _PlaceholderCard(
                          icon: Icons.person_outline,
                          title: 'Profile token ready',
                          body: user?.email ?? 'User session restored',
                        ),
                        const _PlaceholderCard(
                          icon: Icons.security,
                          title: 'JWT saved',
                          body:
                              'Access and refresh tokens are stored securely.',
                        ),
                        const _PlaceholderCard(
                          icon: Icons.route,
                          title: 'Navigation ready',
                          body:
                              'Login, register, auto-login, and logout are wired.',
                        ),
                      ];

                      if (isCompact) {
                        return Column(
                          children: [
                            for (final card in cards) ...[
                              card,
                              if (card != cards.last)
                                const SizedBox(height: 14),
                            ],
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final card in cards) ...[
                            Expanded(child: card),
                            if (card != cards.last) const SizedBox(width: 14),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleNavigationCard extends StatelessWidget {
  const _ModuleNavigationCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
