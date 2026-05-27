import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ProfileActionList extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onSecurity;
  final VoidCallback onLogout;

  const ProfileActionList({
    super.key,
    required this.onEdit,
    required this.onSecurity,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionTile(
          icon: Icons.edit_outlined,
          title: 'Modifier mon profil',
          onTap: onEdit,
        ),
        _ActionTile(
          icon: Icons.lock_outline,
          title: 'Sécurité du compte',
          onTap: onSecurity,
        ),
        _ActionTile(
          icon: Icons.logout_rounded,
          title: 'Se déconnecter',
          danger: true,
          onTap: onLogout,
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool danger;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.primaryRed : AppColors.black;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.black, width: 1.1),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: AppTextStyles.bodyBold.copyWith(color: color),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}