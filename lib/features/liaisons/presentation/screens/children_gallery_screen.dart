import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_empty_view.dart';
import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../../../../../shared/widgets/communalis_bottom_nav.dart';
import '../providers/child_gallery_provider.dart';
import '../widgets/child_gallery_card.dart';

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

  Future<void> _sendRequest() async {
    await ref.read(childGalleryProvider.notifier).sendRequests();

    if (!mounted) return;

    final state = ref.read(childGalleryProvider);

    if (state.successMessage != null) {
      context.go(RouteNames.parentWaitingValidation);
    }
  }

  void _onSearchChanged(String value) {
    ref.read(childGalleryProvider.notifier).loadChildren(
          search: value.trim(),
        );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.childrenGallery);
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
          _RequestBar(
            selectedCount: state.selectedChildIds.length,
            isLoading: state.isSubmitting,
            onPressed: state.selectedChildIds.isEmpty ? null : _sendRequest,
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
          onRefresh: () {
            return ref.read(childGalleryProvider.notifier).loadChildren(
                  search: _searchController.text.trim(),
                );
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
            children: [
              _Header(
                onBack: () => context.go(RouteNames.homeChoice),
              ),

              const SizedBox(height: 18),

              const _WelcomeCard(),

              const SizedBox(height: 18),

              _SearchBox(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onClear: () {
                  _searchController.clear();
                  ref.read(childGalleryProvider.notifier).loadChildren();
                },
              ),

              const SizedBox(height: 18),

              Builder(
                builder: (context) {
                  if (state.isLoading && state.children.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: AppLoader(
                        message: 'Chargement du trombinoscope...',
                      ),
                    );
                  }

                  if (state.errorMessage != null && state.children.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 36),
                      child: AppErrorView(
                        message: state.errorMessage!,
                        onRetry: () {
                          ref.read(childGalleryProvider.notifier).loadChildren();
                        },
                      ),
                    );
                  }

                  if (state.children.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 36),
                      child: AppEmptyView(
                        title: 'Aucun enfant trouvé',
                        message:
                            'Essayez une autre recherche ou revenez plus tard.',
                        icon: Icons.groups_outlined,
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.children.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
              ),
            ),
            const Expanded(
              child: Column(
                children: [
                  Text(
                    'Trombinoscope',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Sélectionnez vos enfants',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          height: 1.4,
          color: AppColors.black,
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.black,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.groups_2_outlined,
            color: AppColors.primaryYellow,
            size: 58,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.body.copyWith(
                  color: AppColors.black,
                  height: 1.26,
                ),
                children: [
                  TextSpan(
                    text: 'Bienvenue dans le trombinoscope !\n\n',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.black,
                      fontSize: 19,
                    ),
                  ),
                  const TextSpan(
                    text:
                        'Sélectionnez votre ou vos enfant(s). Une demande sera envoyée à l’administrateur pour validation.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBox({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Rechercher par nom ou matricule...',
        filled: true,
        fillColor: AppColors.primaryYellow.withValues(alpha: 0.20),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.black,
        ),
        suffixIcon: IconButton(
          onPressed: onClear,
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.black,
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primaryRed,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _RequestBar extends StatelessWidget {
  final int selectedCount;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _RequestBar({
    required this.selectedCount,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedCount > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          top: BorderSide(color: AppColors.lightGrey),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Icon(
                  hasSelection
                      ? Icons.send_rounded
                      : Icons.touch_app_outlined,
                ),
          label: Text(
            hasSelection
                ? 'Envoyer la demande ($selectedCount)'
                : 'Sélectionnez un enfant',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
                hasSelection ? AppColors.primaryRed : AppColors.lightGrey,
            foregroundColor:
                hasSelection ? AppColors.white : AppColors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ),
      ),
    );
  }
}