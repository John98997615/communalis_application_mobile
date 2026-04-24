import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  factory StatusBadge.success(String text) {
    return StatusBadge(
      text: text,
      backgroundColor: AppColors.success.withValues(alpha: 0.12),
      textColor: AppColors.success,
      icon: Icons.check_circle_outline,
    );
  }

  factory StatusBadge.warning(String text) {
    return StatusBadge(
      text: text,
      backgroundColor: AppColors.warning.withValues(alpha: 0.12),
      textColor: AppColors.warning,
      icon: Icons.warning_amber_outlined,
    );
  }

  factory StatusBadge.error(String text) {
    return StatusBadge(
      text: text,
      backgroundColor: AppColors.error.withValues(alpha: 0.12),
      textColor: AppColors.error,
      icon: Icons.cancel_outlined,
    );
  }

  factory StatusBadge.info(String text) {
    return StatusBadge(
      text: text,
      backgroundColor: AppColors.info.withValues(alpha: 0.12),
      textColor: AppColors.info,
      icon: Icons.info_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}