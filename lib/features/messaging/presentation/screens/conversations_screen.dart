import 'package:communalis_application_mobile/features/parent_dashboard/presentation/providers/parent_dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() =>
      _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      ref.read(parentDashboardProvider.notifier).loadDashboard();
    });
  }

  Future<void> _refresh() {
    return ref.read(parentDashboardProvider.notifier).loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parentDashboardProvider);
    final dashboard = state.dashboard;

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryYellow,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.parentDashboard);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
              ),
            ),
            const Text(
              'Messages',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryRed,
          onRefresh: _refresh,
          child: Builder(
            builder: (context) {
              if (state.isLoading && dashboard == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryRed,
                  ),
                );
              }

              if (dashboard == null || dashboard.children.isEmpty) {
                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    const SizedBox(height: 80),
                    _EmptyMessagesCard(
                      title: 'Aucune conversation disponible',
                      message:
                          'Vos discussions avec l’administration apparaîtront ici dès qu’un enfant sera associé à votre compte.',
                    ),
                  ],
                );
              }

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  Text(
                    'Discussions',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.black,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Sélectionnez un enfant pour échanger avec l’administration.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  ...dashboard.children.map(
                    (child) => _ConversationTile(
                      childName: child.fullName,
                      className: child.className,
                      photoUrl: child.photoUrl,
                      messageCount: child.latestComments.length,
                      onTap: () {
                        context.go(
                          RouteNames.childChatPath(
                            child.id,
                            child.fullName,
                          ),
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

class _ConversationTile extends StatelessWidget {
  final String childName;
  final String? className;
  final String? photoUrl;
  final int messageCount;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.childName,
    required this.className,
    required this.photoUrl,
    required this.messageCount,
    required this.onTap,
  });

  String get _classLabel {
    final value = className?.trim();

    if (value == null || value.isEmpty || value.toUpperCase() == 'NC') {
      return 'Classe non renseignée';
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.black, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                _Avatar(photoUrl: photoUrl),
                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        childName.trim().isEmpty ? 'Enfant' : childName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _classLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        messageCount > 0
                            ? '$messageCount message(s) récent(s)'
                            : 'Aucun message récent',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;

  const _Avatar({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.black, width: 1.3),
      ),
      child: ClipOval(
        child: hasPhoto
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _AvatarFallback(),
              )
            : const _AvatarFallback(),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primaryYellow,
      child: Icon(
        Icons.person_rounded,
        color: AppColors.black,
        size: 32,
      ),
    );
  }
}

class _EmptyMessagesCard extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyMessagesCard({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black, width: 1.2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.primaryRed,
            size: 52,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.darkGrey,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}