import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';

class CommunalisBottomNav extends StatelessWidget {
  final int currentIndex;
  final int notificationCount;
  final ValueChanged<int> onTap;

  const CommunalisBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.notificationCount = 0,
  });

  static const _items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Accueil',
    ),
    _NavItem(
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'Message',
    ),
    _NavItem(
      icon: Icons.notifications_none_rounded,
      activeIcon: Icons.notifications_rounded,
      label: 'Notification',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.primaryYellow,
          border: Border(
            top: BorderSide(
              color: AppColors.black,
              width: 1.2,
            ),
          ),
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isActive = currentIndex == index;

            return Expanded(
              child: _BottomNavButton(
                item: item,
                isActive: isActive,
                badgeCount: index == 2 ? notificationCount : 0,
                onTap: () => onTap(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final int badgeCount;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.item,
    required this.isActive,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  State<_BottomNavButton> createState() => _BottomNavButtonState();
}

class _BottomNavButtonState extends State<_BottomNavButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive ? AppColors.primaryRed : AppColors.black;

    return AnimatedScale(
      scale: _pressed ? 0.94 : 1,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? AppColors.white.withValues(alpha: 0.38)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Icon(
                        widget.isActive
                            ? widget.item.activeIcon
                            : widget.item.icon,
                        key: ValueKey(widget.isActive),
                        color: color,
                        size: 28,
                      ),
                    ),
                    if (widget.badgeCount > 0)
                      Positioned(
                        right: -8,
                        top: -7,
                        child: _NotificationBadge(
                          count: widget.badgeCount,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 11,
                    fontWeight:
                        widget.isActive ? FontWeight.w900 : FontWeight.w500,
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

class _NotificationBadge extends StatelessWidget {
  final int count;

  const _NotificationBadge({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: count > 0 ? 1 : 0,
      duration: const Duration(milliseconds: 180),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 18,
          minHeight: 18,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: AppColors.primaryYellow,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          count > 9 ? '9+' : count.toString(),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}