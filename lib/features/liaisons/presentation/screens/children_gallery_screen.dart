import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/app_empty_view.dart';
import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../../../../../shared/widgets/communalis_bottom_nav.dart';
import '../providers/child_gallery_provider.dart';
import '../widgets/child_gallery_card.dart';
import '../widgets/children_gallery_header.dart';
import '../widgets/children_search_bar.dart';
import '../widgets/selected_children_footer.dart';

class ChildrenGalleryScreen extends ConsumerStatefulWidget {
  const ChildrenGalleryScreen({super.key});

  @override
  ConsumerState<ChildrenGalleryScreen> createState() =>
      _ChildrenGalleryScreenState();
}

class _ChildrenGalleryScreenState extends ConsumerState<ChildrenGalleryScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(childGalleryProvider.notifier).loadChildren();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    return ref.read(childGalleryProvider.notifier).loadChildren(
          search: _searchController.text.trim(),
        );
  }

  Future<void> _submitRequest() async {
    await ref.read(childGalleryProvider.notifier).sendRequests();

    if (!mounted) return;

    final state = ref.read(childGalleryProvider);

    if (state.successMessage != null) {
      context.go(RouteNames.parentWaitingValidation);
    }
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.homeChoice);
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
    final state = ref.watch(childGalleryProvider);

    ref.listen(childGalleryProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.primaryRed,
          ),
        );
      }

      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectedChildrenFooter(
            selectedCount: state.selectedChildIds.length,
            isLoading: state.isSubmitting,
            onSubmit: state.selectedChildIds.isEmpty ? null : _submitRequest,
          ),
          CommunalisBottomNav(
            currentIndex: 0,
            onTap: _onBottomNavTap,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryRed,
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              ChildrenGalleryHeader(
                onBack: () => context.go(RouteNames.homeChoice),
              ),

              const SizedBox(height: AppSpacing.lg),

              ChildrenSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(childGalleryProvider.notifier).loadChildren(
                        search: value.trim(),
                      );
                },
                onClear: () {
                  _searchController.clear();
                  ref.read(childGalleryProvider.notifier).loadChildren();
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              if (state.isLoading && state.children.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: AppLoader(
                    message: 'Chargement du trombinoscope...',
                  ),
                )
              else if (state.errorMessage != null && state.children.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: AppErrorView(
                    message: state.errorMessage!,
                    onRetry: _refresh,
                  ),
                )
              else if (state.children.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: AppEmptyView(
                    title: 'Aucun enfant trouvé',
                    message:
                        'Essayez une autre recherche ou revenez plus tard.',
                    icon: Icons.groups_2_outlined,
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.children.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.15,
                  ),
                  itemBuilder: (context, index) {
                    final child = state.children[index];

                    return ChildGalleryCard(
                      child: child,
                      isSelected: state.selectedChildIds.contains(child.id),
                      onTap: () {
                        ref
                            .read(childGalleryProvider.notifier)
                            .toggleChildSelection(child.id);
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}