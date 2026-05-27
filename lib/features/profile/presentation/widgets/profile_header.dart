import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black, width: 1.2),
      ),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.black, width: 1.4),
              color: AppColors.primaryYellow,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 48,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Parent Communalis',
            style: AppTextStyles.titleSmall.copyWith(
              fontSize: 22,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Compte parent',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryRed,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}