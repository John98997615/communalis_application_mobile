import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
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
        return Icons.chat_bubble_outline;
      case 'LIAISON_APPROUVEE':
        return Icons.verified_user_outlined;
      case 'LIAISON_REFUSEE':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.isRead
          ? null
          : AppColors.primaryRed.withValues(alpha: 0.06),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryRed.withValues(alpha: 0.10),
          child: Icon(_icon, color: AppColors.primaryRed),
        ),
        title: Text(
          notification.readableType,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(notification.content),
        trailing: notification.isRead
            ? null
            : const Icon(Icons.circle, size: 10, color: AppColors.primaryRed),
      ),
    );
  }
}
