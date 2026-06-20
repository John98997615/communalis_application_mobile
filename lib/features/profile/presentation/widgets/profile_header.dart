import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String roleLabel;
  final String? avatarUrl;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.roleLabel,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.black, width: 1.5),
              color: AppColors.primaryYellow,
            ),
            child: ClipOval(
              child: hasAvatar
                  ? Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const _AvatarFallback();
                      },
                    )
                  : const _AvatarFallback(),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            fullName,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleSmall.copyWith(
              fontSize: 22,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            roleLabel,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryRed,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primaryYellow,
      child: Icon(
        Icons.person_rounded,
        size: 48,
        color: AppColors.black,
      ),
    );
  }
}