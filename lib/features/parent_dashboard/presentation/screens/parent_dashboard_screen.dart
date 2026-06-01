import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/parent_dashboard_header.dart';
import '../widgets/pending_association_card.dart';
import '../widgets/dashboard_skeleton.dart';
import '../widgets/dashboard_empty_view.dart';
import '../widgets/dashboard_error_view.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../../../../shared/widgets/communalis_bottom_nav.dart';
import '../../../../../features/liaisons/presentation/providers/child_gallery_provider.dart';
import '../../../../../shared/enums/liaison_status.dart';
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

    Future.microtask(_secureLoadDashboard);
  }

  Future<void> _secureLoadDashboard() async {
    final status = await ref.read(getMyLiaisonStatusUsecaseProvider)();

    if (!mounted) return;

    switch (status) {
      case LiaisonStatus.approved:
        await ref.read(parentDashboardProvider.notifier).loadDashboard();
        await ref.read(notificationsProvider.notifier).loadNotifications();
        ref.read(notificationsProvider.notifier).startAutoRefresh();
        return;

      case LiaisonStatus.pending:
        context.go(RouteNames.parentWaitingValidation);
        return;

      case LiaisonStatus.none:
      case LiaisonStatus.rejected:
      case LiaisonStatus.unknown:
        context.go(RouteNames.childrenGallery);
        return;
    }
  }

  @override
  void dispose() {
    ref.read(notificationsProvider.notifier).stopAutoRefresh();
    super.dispose();
  }

  Future<void> _refreshDashboard() async {
    final status = await ref.read(getMyLiaisonStatusUsecaseProvider)();

    if (!mounted) return;

    if (status != LiaisonStatus.approved) {
      context.go(
        status == LiaisonStatus.pending
            ? RouteNames.parentWaitingValidation
            : RouteNames.childrenGallery,
      );
      return;
    }

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
                return const DashboardSkeleton();
              }

              if (dashboardState.errorMessage != null &&
                  dashboardState.dashboard == null) {
                return DashboardErrorView(onRetry: _refreshDashboard);
              }

              final dashboard = dashboardState.dashboard;

              if (dashboard == null || dashboard.children.isEmpty) {
                return DashboardEmptyView(
                  onOpenGallery: () {
                    context.go(RouteNames.childrenGallery);
                  },
                );
              }

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                children: [
                  ParentDashboardHeader(
                    parentName: dashboard.parentName,
                    onBack: () {
                      context.go(RouteNames.homeChoice);
                    },
                    onProfileTap: () {
                      context.go(RouteNames.profile);
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  if (dashboard.pendingAssociationCount > 0) ...[
                    PendingAssociationCard(
                      pendingCount: dashboard.pendingAssociationCount,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Mes enfants',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.primaryRed.withValues(alpha: 0.20),
                          ),
                        ),
                        child: Text(
                          dashboard.children.length <= 1
                              ? '1 enfant'
                              : '${dashboard.children.length} enfants',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  Text(
                    'Sélectionnez un enfant pour consulter son suivi scolaire.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  ...dashboard.children.map(
                    (child) => ParentChildCard(
                      child: child,
                      onTap: () {
                        context.go(RouteNames.childProfilePath(child.id));
                      },
                      onAttendanceTap: () {
                        context.go(RouteNames.studentAttendancePath(child.id));
                      },
                      onGradesTap: () {
                        context.go(RouteNames.studentGradesPath(child.id));
                      },
                      onCommentsTap: () {
                        context.go(
                          RouteNames.childChatPath(child.id, child.fullName),
                        );
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
