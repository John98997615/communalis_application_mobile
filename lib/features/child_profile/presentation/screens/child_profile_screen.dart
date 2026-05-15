import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../core/widgets/app_button.dart';

import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../providers/child_profile_provider.dart';
import '../widgets/child_attendance_section.dart';
import '../widgets/child_comments_preview.dart';
import '../widgets/child_notes_section.dart';
import '../widgets/child_overview_card.dart';
import '../widgets/child_personal_info_section.dart';
import '../widgets/child_progress_section.dart';

class ChildProfileScreen extends ConsumerStatefulWidget {
  final int childId;

  const ChildProfileScreen({super.key, required this.childId});

  @override
  ConsumerState<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends ConsumerState<ChildProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(childProfileProvider.notifier)
          .loadChildProfile(childId: widget.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(childProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil enfant')),
      body: RefreshIndicator(
        onRefresh: () {
          return ref
              .read(childProfileProvider.notifier)
              .loadChildProfile(childId: widget.childId);
        },
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.childProfile == null) {
              return const AppLoader(message: 'Chargement du profil enfant...');
            }

            if (state.errorMessage != null && state.childProfile == null) {
              return AppErrorView(
                message: state.errorMessage!,
                onRetry: () {
                  ref
                      .read(childProfileProvider.notifier)
                      .loadChildProfile(childId: widget.childId);
                },
              );
            }

            final child = state.childProfile;

            if (child == null) {
              return const AppLoader();
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                ChildOverviewCard(child: child),
                const SizedBox(height: 14),
                ChildProgressSection(child: child),
                const SizedBox(height: 14),
                ChildPersonalInfoSection(child: child),
                const SizedBox(height: 14),
                ChildNotesSection(grades: child.grades),
                const SizedBox(height: 14),
                ChildAttendanceSection(
                  stats: child.stats,
                  attendance: child.attendance,
                ),
                const SizedBox(height: 14),
                ChildCommentsPreview(comments: child.comments),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Ouvrir les commentaires',
                  icon: Icons.chat_bubble_outline,
                  onPressed: () {
                    context.go(
                      RouteNames.childChatPath(child.id, child.fullName),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
