import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
// import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/communalis_bottom_nav.dart';

class HomeChoiceScreen extends StatelessWidget {
  const HomeChoiceScreen({super.key});

  void _onBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.homeChoice);
        break;
      case 1:
        context.go(RouteNames.messaging);
        break;
      case 2:
        context.go(RouteNames.notifications);
        break;
      case 3:
        context.go(RouteNames.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      bottomNavigationBar: CommunalisBottomNav(
        currentIndex: 0,
        onTap: (index) => _onBottomNavTap(context, index),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 18, 28, 28),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => context.go(RouteNames.roleRedirect),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.black,
                ),
              ),
            ),

            const SizedBox(height: 10),

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
              onTap: () => context.go(RouteNames.parentDashboard),
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
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
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
      child: Column(
        children: [
          Icon(
            icon,
            size: 52,
            color: iconColor,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleSmall.copyWith(
              fontSize: 22,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.black,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onTap,
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
              child: Text(
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