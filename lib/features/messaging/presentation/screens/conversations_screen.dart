import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      appBar: AppBar(
        backgroundColor: AppColors.primaryYellow,
        elevation: 0,
        title: const Text('Messages'),
      ),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: AppColors.black,
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.forum_outlined,
                    color: AppColors.primaryRed,
                    size: 54,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Messagerie',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.black,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Vos discussions avec l’administration apparaîtront ici. '
                    'Pour le moment, ouvrez la discussion depuis la fiche de l’enfant.',
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
        ),
      ),
    );
  }
}