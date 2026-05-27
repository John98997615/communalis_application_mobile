import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ChildProfileErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const ChildProfileErrorView({
    super.key,
    required this.onRetry,
  });

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
                Icons.wifi_off_rounded,
                color: AppColors.primaryRed,
                size: 54,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Impossible de charger le profil enfant',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Veuillez vérifier votre connexion puis réessayer.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.darkGrey,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Réessayer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}