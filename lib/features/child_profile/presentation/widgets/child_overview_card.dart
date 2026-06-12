import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildOverviewCard extends StatelessWidget {
  final ChildProfileEntity child;

  const ChildOverviewCard({super.key, required this.child});

  String get _classLabel {
    final value = child.className?.trim();

    if (value == null || value.isEmpty || value.toUpperCase() == 'NC') {
      return 'Classe non renseignée';
    }

    return value;
  }

  String get _matriculeLabel {
    final value = child.matricule.trim();

    if (value.isEmpty) {
      return 'Matricule indisponible';
    }

    final cleanValue = value
        .replaceFirst(RegExp(r'^STD', caseSensitive: false), '')
        .trim();

    return 'N° #$cleanValue';
  }

  String get _ageText {
    final rawDate = child.birthDate?.trim();

    if (rawDate == null || rawDate.isEmpty) {
      return 'Âge indisponible';
    }

    final parsedDate = DateTime.tryParse(rawDate);

    if (parsedDate == null) {
      return 'Âge indisponible';
    }

    final now = DateTime.now();
    var age = now.year - parsedDate.year;

    if (now.month < parsedDate.month ||
        (now.month == parsedDate.month && now.day < parsedDate.day)) {
      age--;
    }

    return age <= 0 ? 'Âge indisponible' : '$age ans';
  }

  String get _performanceLabel {
    switch (child.performanceLevel.toUpperCase()) {
      case 'GOOD':
        return 'Très bon';
      case 'AVERAGE':
        return 'Moyen';
      case 'LOW':
        return 'À surveiller';
      default:
        return 'Non évalué';
    }
  }

  Color get _performanceColor {
    switch (child.performanceLevel.toUpperCase()) {
      case 'GOOD':
        return AppColors.success;
      case 'AVERAGE':
        return AppColors.warning;
      case 'LOW':
        return AppColors.primaryRed;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 420),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, childWidget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, AppSpacing.lg * (1 - value)),
            child: childWidget,
          ),
        );
      },
      child: Container(
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
            Row(
              children: [
                _ChildAvatar(photoUrl: child.photoUrl),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.fullName.isEmpty
                            ? 'Nom non renseigné'
                            : child.fullName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.black,
                          fontSize: 21,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _classLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _matriculeLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            Row(
              children: [
                Expanded(
                  child: _InfoPill(icon: Icons.cake_outlined, label: _ageText),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _PerformancePill(
                    label: _performanceLabel,
                    color: _performanceColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildAvatar extends StatelessWidget {
  final String? photoUrl;

  const _ChildAvatar({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return Container(
      width: 82,
      height: 82,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(color: AppColors.black, width: 1.4),
      ),
      child: ClipOval(
        child: hasPhoto
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const _AvatarFallback();
                },
              )
            : const _AvatarFallback(),
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
      child: Icon(Icons.person_rounded, color: AppColors.black, size: 38),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryYellow.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.black, width: 1.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.black, size: 16),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformancePill extends StatelessWidget {
  final String label;
  final Color color;

  const _PerformancePill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color, width: 1.1),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
