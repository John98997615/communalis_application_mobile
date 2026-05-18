import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

class NotificationBadgeButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const NotificationBadgeButton({
    super.key,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = unreadCount > 99 ? '99+' : unreadCount.toString();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: onTap,
          icon: const Icon(Icons.notifications_outlined),
        ),
        if (unreadCount > 0)
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  displayCount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}