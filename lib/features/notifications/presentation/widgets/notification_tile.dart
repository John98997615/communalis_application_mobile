import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData get _icon {
    switch (notification.type.toUpperCase()) {
      case 'NOUVELLE_NOTE':
        return Icons.school_outlined;
      case 'PRESENCE_AJOUTEE':
        return Icons.event_available_outlined;
      case 'NOUVEAU_COMMENTAIRE':
        return Icons.chat_bubble_outline_rounded;
      case 'LIAISON_APPROUVEE':
        return Icons.verified_user_outlined;
      case 'LIAISON_REFUSEE':
        return Icons.cancel_outlined;
      case 'MODIFICATION_PROFIL_ENFANT':
        return Icons.manage_accounts_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color get _accentColor {
    switch (notification.type.toUpperCase()) {
      case 'LIAISON_APPROUVEE':
        return AppColors.success;
      case 'LIAISON_REFUSEE':
        return AppColors.primaryRed;
      case 'NOUVELLE_NOTE':
        return AppColors.warning;
      case 'PRESENCE_AJOUTEE':
        return AppColors.success;
      case 'NOUVEAU_COMMENTAIRE':
        return AppColors.primaryRed;
      default:
        return AppColors.primaryRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isUnread
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: isUnread ? AppColors.black : AppColors.black.withValues(alpha: 0.45),
              width: isUnread ? 1.25 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isUnread ? 0.06 : 0.03),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _accentColor,
                    width: 1.1,
                  ),
                ),
                child: Icon(
                  _icon,
                  color: _accentColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.readableType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyBold.copyWith(
                              color: AppColors.black,
                              fontSize: 15.5,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xs),

                    Text(
                      notification.content.trim().isEmpty
                          ? 'Notification indisponible.'
                          : notification.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.darkGrey,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      children: [
                        Icon(
                          isUnread
                              ? Icons.mark_email_unread_outlined
                              : Icons.done_all_rounded,
                          size: 15,
                          color: isUnread
                              ? AppColors.primaryRed
                              : AppColors.success,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          isUnread ? 'Non lue' : 'Lue',
                          style: AppTextStyles.caption.copyWith(
                            color: isUnread
                                ? AppColors.primaryRed
                                : AppColors.success,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}