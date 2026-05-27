import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildCommentsPreview extends StatelessWidget {
  final int childId;
  final String childName;
  final List<ChildCommentEntity> comments;

  const ChildCommentsPreview({
    super.key,
    required this.childId,
    required this.childName,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    final latestComments = comments.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.black,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.primaryRed,
                size: 26,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Commentaires',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            'Consultez les échanges récents concernant votre enfant.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.darkGrey,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          if (latestComments.isEmpty)
            const _EmptyComments()
          else
            ...latestComments.map(
              (comment) => _CommentBubblePreview(comment: comment),
            ),

          const SizedBox(height: AppSpacing.lg),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                context.go(
                  RouteNames.childChatPath(
                    childId,
                    childName,
                  ),
                );
              },
              icon: const Icon(Icons.forum_outlined),
              label: const Text(
                'Ouvrir la discussion',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  side: const BorderSide(
                    color: AppColors.black,
                    width: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentBubblePreview extends StatelessWidget {
  final ChildCommentEntity comment;

  const _CommentBubblePreview({
    required this.comment,
  });

  bool get _isParent {
    return comment.authorRole?.toUpperCase() == 'PARENT';
  }

  String get _authorLabel {
    if (_isParent) return 'Vous';

    if (comment.authorRole?.toUpperCase() == 'ADMIN') {
      return 'Administration';
    }

    return 'Équipe Communalis';
  }

  String get _dateText {
    final raw = comment.date?.trim();

    if (raw == null || raw.isEmpty) {
      return 'Date indisponible';
    }

    final parsed = DateTime.tryParse(raw);

    if (parsed == null) {
      return raw;
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final year = parsed.year.toString();

    final hasTime = parsed.hour != 0 || parsed.minute != 0;

    if (!hasTime) {
      return '$day/$month/$year';
    }

    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');

    return '$day/$month/$year à $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = _isParent
        ? AppColors.primaryRed.withValues(alpha: 0.08)
        : AppColors.primaryYellow.withValues(alpha: 0.30);

    final borderColor = _isParent
        ? AppColors.primaryRed.withValues(alpha: 0.35)
        : AppColors.black.withValues(alpha: 0.35);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  _isParent ? AppColors.primaryRed : AppColors.black,
              child: Icon(
                _isParent
                    ? Icons.person_outline_rounded
                    : Icons.admin_panel_settings_outlined,
                color: AppColors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _authorLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    comment.message.trim().isEmpty
                        ? 'Message indisponible'
                        : comment.message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _dateText,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyComments extends StatelessWidget {
  const _EmptyComments();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primaryYellow.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.black,
          width: 1.1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.forum_outlined,
            color: AppColors.primaryRed,
            size: 38,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aucun commentaire pour le moment',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Les échanges avec l’administration apparaîtront ici.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.darkGrey,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}