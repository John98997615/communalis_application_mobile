import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../providers/child_profile_provider.dart';
import '../widgets/child_attendance_section.dart';
import '../widgets/child_comments_preview.dart';
import '../widgets/child_notes_section.dart';
import '../widgets/child_overview_card.dart';
import '../widgets/child_personal_info_section.dart';
import '../widgets/child_profile_empty_view.dart';
import '../widgets/child_profile_error_view.dart';
import '../widgets/child_profile_skeleton.dart';
import '../widgets/child_progress_section.dart';

class ChildProfileScreen extends ConsumerStatefulWidget {
  final int childId;

  const ChildProfileScreen({
    super.key,
    required this.childId,
  });

  @override
  ConsumerState<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends ConsumerState<ChildProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(_loadProfile);
  }

  Future<void> _loadProfile() {
    return ref.read(childProfileProvider.notifier).loadChildProfile(
          childId: widget.childId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(childProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      appBar: AppBar(
        title: const Text('Profil enfant'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryRed,
          onRefresh: _loadProfile,
          child: Builder(
            builder: (context) {
              if (state.isLoading && state.childProfile == null) {
                return const ChildProfileSkeleton();
              }

              if (state.errorMessage != null && state.childProfile == null) {
                return ChildProfileErrorView(
                  onRetry: _loadProfile,
                );
              }

              final child = state.childProfile;

              if (child == null) {
                return const ChildProfileEmptyView();
              }

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  ChildOverviewCard(child: child),

                  const SizedBox(height: AppSpacing.lg),

                  ChildProgressSection(child: child),

                  const SizedBox(height: AppSpacing.lg),

                  ChildPersonalInfoSection(child: child),

                  const SizedBox(height: AppSpacing.lg),

                  ChildNotesSection(grades: child.grades),

                  const SizedBox(height: AppSpacing.lg),

                  ChildAttendanceSection(attendance: child.attendance),

                  const SizedBox(height: AppSpacing.lg),

                  ChildCommentsPreview(
                    childId: child.id,
                    childName: child.fullName,
                    comments: child.comments,
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}