import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../widgets/profile_action_list.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité bientôt disponible.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      appBar: AppBar(
        backgroundColor: AppColors.primaryYellow,
        elevation: 0,
        title: const Text('Mon profil'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const ProfileHeader(),
            const SizedBox(height: AppSpacing.lg),
            const ProfileInfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'Email non renseigné',
            ),
            const ProfileInfoTile(
              icon: Icons.phone_outlined,
              label: 'Téléphone',
              value: 'Téléphone non renseigné',
            ),
            const SizedBox(height: AppSpacing.lg),
            ProfileActionList(
              onEdit: () => _showSoon(context),
              onSecurity: () => _showSoon(context),
              onLogout: () {
                context.go(RouteNames.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}