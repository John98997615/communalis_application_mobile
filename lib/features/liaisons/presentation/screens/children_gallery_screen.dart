import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:communalis_application_mobile/app/router/route_names.dart';
import 'package:communalis_application_mobile/core/widgets/app_button.dart';
import 'package:communalis_application_mobile/core/widgets/app_empty_view.dart';
import 'package:communalis_application_mobile/core/widgets/app_error_view.dart';
import 'package:communalis_application_mobile/core/widgets/app_loader.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(childGalleryProvider);

    ref.listen(childGalleryProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection de l’enfant'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return ref.read(childGalleryProvider.notifier).loadChildren(
                  search: _searchController.text,
                );
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Trombinoscope des enfants',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sélectionnez votre enfant. La demande sera envoyée à l’administrateur pour validation.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Rechercher un enfant',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(childGalleryProvider.notifier)
                                .loadChildren();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      onSubmitted: (value) {
                        ref.read(childGalleryProvider.notifier).loadChildren(
                              search: value,
                            );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading) {
                      return const AppLoader(
                        message: 'Chargement des enfants...',
                      );
                    }

                    if (state.errorMessage != null &&
                        state.children.isEmpty) {
                      return AppErrorView(
                        message: state.errorMessage!,
                        onRetry: () {
                          ref
                              .read(childGalleryProvider.notifier)
                              .loadChildren();
                        },
                      );
                    }

                    if (state.children.isEmpty) {
                      return const AppEmptyView(
                        title: 'Aucun enfant trouvé',
                        message:
                            'Aucun enfant n’est disponible pour le moment.',
                        icon: Icons.groups_outlined,
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: state.children.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index) {
                        final child = state.children[index];

                        return ChildGalleryCard(
                          child: child,
                          isSelected:
                              state.selectedChildIds.contains(child.id),
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
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                child: AppButton(
                  text: state.selectedChildIds.isEmpty
                      ? 'Sélectionnez un enfant'
                      : 'Envoyer la demande (${state.selectedChildIds.length})',
                  isLoading: state.isSubmitting,
                  onPressed: state.selectedChildIds.isEmpty
                      ? null
                      : _sendRequest,
                  icon: Icons.send_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}