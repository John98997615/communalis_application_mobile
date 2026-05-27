import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ChildProfileEmptyView extends StatelessWidget {
  const ChildProfileEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.black, width: 1.2),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.child_care_rounded,
                color: AppColors.primaryRed,
                size: 54,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Profil enfant indisponible',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Nous n’avons pas pu récupérer les informations de cet enfant pour le moment.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.darkGrey,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}