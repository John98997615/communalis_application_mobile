import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import '../../../../../app/router/route_names.dart';

import '../../../../../core/widgets/app_empty_view.dart';
import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../providers/parent_dashboard_provider.dart';
import '../widgets/latest_attendance_section.dart';
import '../widgets/latest_grades_section.dart';
import '../widgets/parent_child_card.dart';
import '../widgets/parent_quick_actions.dart';

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

    Future.microtask(() {
      ref.read(parentDashboardProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parentDashboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Espace Parent')),
      body: RefreshIndicator(
        onRefresh: () {
          return ref.read(parentDashboardProvider.notifier).loadDashboard();
        },
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.dashboard == null) {
              return const AppLoader(
                message: 'Chargement de votre espace parent...',
              );
            }

            if (state.errorMessage != null && state.dashboard == null) {
              return AppErrorView(
                message: state.errorMessage!,
                onRetry: () {
                  ref.read(parentDashboardProvider.notifier).loadDashboard();
                },
              );
            }

            final dashboard = state.dashboard;

            if (dashboard == null || dashboard.children.isEmpty) {
              return const AppEmptyView(
                title: 'Aucun enfant associé',
                message:
                    'Votre accès sera disponible après validation de l’administrateur.',
                icon: Icons.family_restroom_outlined,
              );
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Bonjour 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Voici le suivi scolaire de votre enfant.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 18),
                const ParentQuickActions(),
                const SizedBox(height: 18),
                ...dashboard.children.map((child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ParentChildCard(
                        child: child,
                        onTap: () {
                          context.go(RouteNames.childProfilePath(child.id));
                        },
                      ),
                      LatestGradesSection(child: child),
                      const SizedBox(height: 14),
                      LatestAttendanceSection(child: child),
                      const SizedBox(height: 22),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
