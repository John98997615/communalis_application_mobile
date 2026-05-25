import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../../../../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../../../../shared/widgets/communalis_bottom_nav.dart';
import '../providers/parent_dashboard_provider.dart';
import '../widgets/parent_child_card.dart';

class ParentDashboardScreen extends ConsumerStatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  ConsumerState<ParentDashboardScreen> createState() =>
      _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends ConsumerState<ParentDashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(parentDashboardProvider.notifier).loadDashboard();
      await ref.read(notificationsProvider.notifier).loadNotifications();
      ref.read(notificationsProvider.notifier).startAutoRefresh();
    });
  }

  @override
  void dispose() {
    ref.read(notificationsProvider.notifier).stopAutoRefresh();
    super.dispose();
  }

  Future<void> _refreshDashboard() async {
    await ref.read(parentDashboardProvider.notifier).loadDashboard();
    await ref.read(notificationsProvider.notifier).loadNotifications();
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.parentDashboard);
        break;
      case 1:
        context.go(RouteNames.messaging);
        break;
      case 2:
        context.go(RouteNames.notifications);
        break;
      case 3:
        context.go(RouteNames.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(parentDashboardProvider);
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      bottomNavigationBar: CommunalisBottomNav(
        currentIndex: 0,
        notificationCount: notificationsState.unreadCount,
        onTap: _onBottomNavTap,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryRed,
          onRefresh: _refreshDashboard,
          child: Builder(
            builder: (context) {
              if (dashboardState.isLoading &&
                  dashboardState.dashboard == null) {
                return const AppLoader(
                  message: 'Chargement de votre espace parent...',
                );
              }

              if (dashboardState.errorMessage != null &&
                  dashboardState.dashboard == null) {
                return AppErrorView(
                  message: dashboardState.errorMessage!,
                  onRetry: _refreshDashboard,
                );
              }

              final dashboard = dashboardState.dashboard;

              if (dashboard == null || dashboard.children.isEmpty) {
                return const _EmptyParentDashboard();
              }

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                children: [
                  _DashboardHeader(
                    unreadCount: notificationsState.unreadCount,
                    onNotificationsTap: () {
                      context.go(RouteNames.notifications);
                    },
                  ),

                  const SizedBox(height: 28),

                  _PendingAssociationCard(
                    pendingCount: 0,
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Text(
                        'Mes enfants',
                        style: AppTextStyles.titleSmall.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${dashboard.totalChildren}',
                        style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Sélectionnez un enfant pour consulter son suivi scolaire.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ...dashboard.children.map(
                    (child) => ParentChildCard(
                      child: child,
                      onTap: () {
                        context.go(RouteNames.childProfilePath(child.id));
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onNotificationsTap;

  const _DashboardHeader({
    required this.unreadCount,
    required this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.black,
          size: 26,
        ),
        const SizedBox(width: 12),
        const Icon(
          Icons.person_outline_rounded,
          color: AppColors.black,
          size: 30,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Espace parent\n',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 26,
                    color: AppColors.black,
                  ),
                ),
                TextSpan(
                  text: 'Bienvenue,',
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.primaryRed,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onNotificationsTap,
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.black,
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _PendingAssociationCard extends StatelessWidget {
  final int pendingCount;

  const _PendingAssociationCard({
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    if (pendingCount <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: AppColors.primaryRed,
            size: 34,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '$pendingCount demande d’association en attente\nL’administrateur validera prochainement.',
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.black,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyParentDashboard extends StatelessWidget {
  const _EmptyParentDashboard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
      children: [
        const _DashboardHeader(
          unreadCount: 0,
          onNotificationsTap: _noop,
        ),
        const SizedBox(height: 80),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.black),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.family_restroom_rounded,
                color: AppColors.primaryRed,
                size: 58,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun enfant associé',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Votre espace sera disponible après validation de l’administrateur.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static void _noop() {}
}