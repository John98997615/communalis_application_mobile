import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ParentQuickActions extends StatelessWidget {
  const ParentQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.black,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickAction(
              icon: Icons.notifications_none_rounded,
              label: 'Notifications',
              color: AppColors.primaryRed,
              onTap: () => context.go(RouteNames.notifications),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _QuickAction(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Messages',
              color: AppColors.black,
              onTap: () => context.go(RouteNames.messaging),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _QuickAction(
              icon: Icons.groups_2_outlined,
              label: 'Trombinoscope',
              color: AppColors.primaryRed,
              onTap: () => context.go(RouteNames.childrenGallery),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _QuickAction(
              icon: Icons.person_outline_rounded,
              label: 'Profil',
              color: AppColors.black,
              onTap: () => context.go(RouteNames.profile),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: widget.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.md,
            ),
            child: Column(
              children: [
                Icon(
                  widget.icon,
                  size: 25,
                  color: widget.color,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 10.5,
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