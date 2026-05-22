import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notification_tile.dart';
import '../navigation/notification_navigation.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(notificationsProvider.notifier).loadNotifications();
      ref.read(notificationsProvider.notifier).startAutoRefresh();
    });
  }

  @override
  void dispose() {
    ref.read(notificationsProvider.notifier).stopAutoRefresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);

    ref.listen(notificationsProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }

      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.successMessage!)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (state.notifications.isNotEmpty)
            TextButton(
              onPressed: state.isUpdating
                  ? null
                  : () {
                      ref.read(notificationsProvider.notifier).markAllAsRead();
                    },
              child: const Text('Tout lire'),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading && state.notifications.isEmpty) {
            return const AppLoader(message: 'Chargement des notifications...');
          }

          if (state.errorMessage != null && state.notifications.isEmpty) {
            return AppErrorView(
              message: state.errorMessage!,
              onRetry: () {
                ref.read(notificationsProvider.notifier).loadNotifications();
              },
            );
          }

          if (state.notifications.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aucune notification pour le moment.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return ref
                  .read(notificationsProvider.notifier)
                  .refreshNotifications();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                final notification = state.notifications[index];

                return NotificationTile(
                  notification: notification,
                  onTap: () async {
                    await ref
                        .read(notificationsProvider.notifier)
                        .markAsRead(notification.id);

                    if (!context.mounted) return;

                    NotificationNavigation.open(context, notification);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
