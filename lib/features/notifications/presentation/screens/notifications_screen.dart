import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../data/models/app_notification.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
  }

  Future<void> _refresh() async {
    await context.read<NotificationCubit>().refreshNotifications();
    if (mounted) {
      await context.read<DashboardCubit>().fetchDashboardStats();
    }
  }

  Future<void> _markAllAsRead() async {
    await context.read<NotificationCubit>().markAllAsRead();
    if (mounted) {
      await context.read<DashboardCubit>().fetchDashboardStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final hasUnread =
                  state is NotificationLoaded && state.unreadCount > 0;

              return TextButton(
                onPressed: hasUnread ? _markAllAsRead : null,
                child: const Text('Mark all read'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<NotificationCubit>()
                          .fetchNotifications(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 140),
                    AppEmptyState(
                      icon: Icons.notifications_none,
                      title: 'No notifications yet',
                      description:
                          'Updates from injury logs, recovery protocols, and challenges will appear here.',
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return Dismissible(
                    key: ValueKey(notification.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                    onDismissed: (_) => context
                        .read<NotificationCubit>()
                        .deleteNotification(notification.id),
                    child: _NotificationTile(
                      notification: notification,
                      onTap: () async {
                        if (!notification.read) {
                          await context.read<NotificationCubit>().markAsRead(
                            notification.id,
                          );
                          if (context.mounted) {
                            await context
                                .read<DashboardCubit>()
                                .fetchDashboardStats();
                          }
                        }
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: state.notifications.length,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unread = notification.read == false;
    final icon = switch (notification.type) {
      'injury_reminder' => Icons.healing,
      'challenge_nudge' => Icons.emoji_events,
      'recovery_reminder' => Icons.health_and_safety,
      _ => Icons.notifications,
    };
    final label = switch (notification.type) {
      'injury_reminder' => 'Injury',
      'challenge_nudge' => 'Challenge',
      'recovery_reminder' => 'Recovery',
      _ => 'Update',
    };

    return Material(
      color: unread
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
          : theme.colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: unread
                  ? theme.colorScheme.primary.withValues(alpha: 0.35)
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat(
                            'MMM d, h:mm a',
                          ).format(notification.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: unread ? 1 : 0.75,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (unread) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
