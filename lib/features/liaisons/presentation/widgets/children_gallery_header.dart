import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ChildrenGalleryHeader extends StatelessWidget {
  final VoidCallback onBack;

  const ChildrenGalleryHeader({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Trombinoscope',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.black,
                      fontSize: 27,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sélectionnez vos enfants',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        Container(
          height: 1.3,
          color: AppColors.black,
        ),

        const SizedBox(height: AppSpacing.xl),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
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
              const Icon(
                Icons.groups_2_outlined,
                color: AppColors.primaryYellow,
                size: 58,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                      height: 1.28,
                    ),
                    children: [
                      TextSpan(
                        text: 'Bienvenue dans le trombinoscope !\n\n',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.black,
                          fontSize: 19,
                        ),
                      ),
                      const TextSpan(
                        text:
                            'Sélectionnez votre ou vos enfant(s). Une demande sera envoyée à l’administrateur pour validation.',
                      ),
                    ],
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