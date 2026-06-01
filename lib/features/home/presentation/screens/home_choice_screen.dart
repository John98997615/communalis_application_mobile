import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:communalis_application_mobile/app/router/route_names.dart';
import 'package:communalis_application_mobile/app/theme/app_colors.dart';
import 'package:communalis_application_mobile/app/theme/app_radius.dart';
import 'package:communalis_application_mobile/app/theme/app_spacing.dart';
import 'package:communalis_application_mobile/app/theme/app_text_styles.dart';
import 'package:communalis_application_mobile/features/liaisons/presentation/providers/child_gallery_provider.dart';
import 'package:communalis_application_mobile/shared/enums/liaison_status.dart';
class HomeChoiceScreen extends ConsumerStatefulWidget {
  const HomeChoiceScreen({super.key});

  @override
  ConsumerState<HomeChoiceScreen> createState() => _HomeChoiceScreenState();
}

class _HomeChoiceScreenState extends ConsumerState<HomeChoiceScreen> {
  bool _isCheckingParentSpace = false;

  Future<void> _openParentSpace() async {
    setState(() => _isCheckingParentSpace = true);

    try {
      final status = await ref.read(getMyLiaisonStatusUsecaseProvider)();

      if (!mounted) return;

      switch (status) {
        case LiaisonStatus.approved:
          context.go(RouteNames.parentDashboard);
          break;

        case LiaisonStatus.pending:
          context.go(RouteNames.parentWaitingValidation);
          break;

        case LiaisonStatus.none:
        case LiaisonStatus.rejected:
        case LiaisonStatus.unknown:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Veuillez d’abord sélectionner votre enfant dans le trombinoscope.',
              ),
              backgroundColor: AppColors.primaryRed,
            ),
          );
          context.go(RouteNames.childrenGallery);
          break;
      }
    } catch (_) {
      if (!mounted) return;
      context.go(RouteNames.childrenGallery);
    } finally {
      if (mounted) {
        setState(() => _isCheckingParentSpace = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 18, 28, 28),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => context.go(RouteNames.login),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.black,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'Bienvenue sur communalis',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.primaryRed,
                fontStyle: FontStyle.italic,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Veuillez choisir votre espace pour continuer',
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 32),

            _ChoiceCard(
              icon: Icons.groups_2_outlined,
              iconColor: AppColors.primaryYellow,
              title: 'Trombinoscope',
              description:
                  'Parcourez la liste complète des élèves de l’école et sélectionnez vos enfants pour demander une association.',
              buttonText: 'Accéder au Trombinoscope',
              buttonColor: AppColors.primaryYellow,
              buttonTextColor: AppColors.black,
              isLoading: false,
              onTap: () => context.go(RouteNames.childrenGallery),
            ),

            const SizedBox(height: 28),

            _ChoiceCard(
              icon: Icons.person_outline_rounded,
              iconColor: AppColors.primaryRed,
              title: 'Espace parent',
              description:
                  'Accédez à votre tableau de bord pour suivre la scolarité de vos enfants, consulter les notes et présences.',
              buttonText: 'Accéder à l’Espace Parent',
              buttonColor: AppColors.primaryRed,
              buttonTextColor: AppColors.white,
              isLoading: _isCheckingParentSpace,
              onTap: _openParentSpace,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final bool isLoading;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.black,
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 54,
            color: iconColor,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleSmall.copyWith(
              fontSize: 23,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.black,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : onTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  side: const BorderSide(
                    color: AppColors.black,
                    width: 1.2,
                  ),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      buttonText,
                      style: AppTextStyles.bodyBold.copyWith(
                        color: buttonTextColor,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}