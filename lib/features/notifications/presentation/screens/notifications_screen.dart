import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

import '../navigation/notification_navigation.dart';
import '../providers/notifications_provider.dart';

import '../widgets/notification_tile.dart';
import '../widgets/notifications_filter_tabs.dart';

import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends ConsumerState<NotificationsScreen> {
  int selectedFilter = 0;

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
      if (next.errorMessage != null &&
          next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
          ),
        );
      }
    });

    final allNotifications = state.notifications;

    final unreadNotifications = allNotifications
        .where((e) => !e.isRead)
        .toList();

    final readNotifications = allNotifications
        .where((e) => e.isRead)
        .toList();

    final filteredNotifications = switch (selectedFilter) {
      1 => unreadNotifications,
      2 => readNotifications,
      _ => allNotifications,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: AppTextStyles.titleLarge,
            ),
            Text(
              '${unreadNotifications.length} non lue(s)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          if (allNotifications.isNotEmpty)
            TextButton(
              onPressed: state.isUpdating
                  ? null
                  : () {
                      ref
                          .read(notificationsProvider.notifier)
                          .markAllAsRead();
                    },
              child: Text(
                'Tout lire',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),

      body: Builder(
        builder: (context) {
          if (state.isLoading &&
              state.notifications.isEmpty) {
            return const AppLoader(
              message: 'Chargement des notifications...',
            );
          }

          if (state.errorMessage != null &&
              state.notifications.isEmpty) {
            return AppErrorView(
              message: state.errorMessage!,
              onRetry: () {
                ref
                    .read(notificationsProvider.notifier)
                    .loadNotifications();
              },
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryRed,
            onRefresh: () {
              return ref
                  .read(notificationsProvider.notifier)
                  .refreshNotifications();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                NotificationsFilterTabs(
                  selectedIndex: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value;
                    });
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                if (filteredNotifications.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 72,
                          color: AppColors.darkGrey
                              .withValues(alpha: 0.40),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Aucune notification trouvée',
                          style: AppTextStyles.bodyBold,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Les nouvelles notifications apparaîtront ici.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),

                ...filteredNotifications.map(
                  (notification) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.md,
                    ),
                    child: NotificationTile(
                      notification: notification,
                      onTap: () async {
                        await ref
                            .read(
                              notificationsProvider.notifier,
                            )
                            .markAsRead(notification.id);

                        if (!context.mounted) return;

                        NotificationNavigation.open(
                          context,
                          notification,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}