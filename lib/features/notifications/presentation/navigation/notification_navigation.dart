import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationNavigation {
  const NotificationNavigation._();

  static void open(
    BuildContext context,
    NotificationEntity notification,
  ) {
    final type = notification.type.toUpperCase();
    final childId = notification.childId;

    switch (type) {
      case 'NOUVEAU_COMMENTAIRE':
        if (childId != null && childId > 0) {
          context.go(
            RouteNames.childChatPath(
              childId,
              'Enfant',
            ),
          );
          return;
        }

        context.go(RouteNames.notifications);
        return;

      case 'NOUVELLE_NOTE':
      case 'PRESENCE_AJOUTEE':
      case 'MODIFICATION_PROFIL_ENFANT':
        if (childId != null && childId > 0) {
          context.go(RouteNames.childProfilePath(childId));
          return;
        }

        context.go(RouteNames.parentDashboard);
        return;

      case 'LIAISON_APPROUVEE':
        context.go(RouteNames.parentDashboard);
        return;

      default:
        if (childId != null && childId > 0) {
          context.go(RouteNames.childProfilePath(childId));
          return;
        }

        context.go(RouteNames.parentDashboard);
        return;
    }
  }
}