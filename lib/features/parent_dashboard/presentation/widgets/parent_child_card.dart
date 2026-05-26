import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/parent_child_summary_entity.dart';

class ParentChildCard extends StatelessWidget {
  final ParentChildSummaryEntity child;
  final VoidCallback? onTap;

  const ParentChildCard({super.key, required this.child, this.onTap});

  String get _ageText {
    if (child.birthDate == null || child.birthDate!.trim().isEmpty) {
      return 'Âge indisponible';
    }

    final date = DateTime.tryParse(child.birthDate!);

    if (date == null) {
      return 'Âge indisponible';
    }

    final now = DateTime.now();

    var age = now.year - date.year;

    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }

    if (age <= 0) {
      return 'Âge indisponible';
    }

    return '$age ans';
  }

  String get _sexText {
    final sexe = child.sexe?.trim().toUpperCase();

    if (sexe == 'M' || sexe == 'GARCON' || sexe == 'GARÇON') {
      return 'Garçon';
    }

    if (sexe == 'F' || sexe == 'FILLE') {
      return 'Fille';
    }

    return 'Sexe non renseigné';
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
    final averageText = child.average == null
        ? '--'
        : child.average!.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
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
                            child.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.black,
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            (child.className != null &&
                                    child.className!.trim().isNotEmpty)
                                ? child.className!
                                : 'Classe non renseignée',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            child.matricule.trim().isEmpty
                                ? 'Matricule indisponible'
                                : 'Matricule : ${child.matricule}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.black,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                Row(
                  children: [
                    _InfoChip(text: _ageText, icon: Icons.cake_outlined),
                    const SizedBox(width: AppSpacing.sm),
                    _InfoChip(text: _sexText, icon: Icons.person_outline),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                Row(
                  children: [
                    Expanded(
                      child: _MetricBox(
                        title: 'Moyenne',
                        value: averageText,
                        color: _performanceColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _MetricBox(
                        title: 'Présences',
                        value: '${child.latestAttendance.length}',
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _MetricBox(
                        title: 'Messages',
                        value: '${child.latestComments.length}',
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                Align(
                  alignment: Alignment.centerLeft,
                  child: _PerformanceBadge(
                    label: _performanceLabel,
                    color: _performanceColor,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.event_available_outlined,
                        label: 'Présences',
                        onTap: () {
                          context.go(RouteNames.childProfilePath(child.id));
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.school_outlined,
                        label: 'Notes',
                        onTap: () {
                          context.go(RouteNames.childProfilePath(child.id));
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: 'Commentaires',
                        onTap: () {
                          context.go(
                            RouteNames.childChatPath(child.id, child.fullName),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      width: 68,
      height: 68,
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
      child: Icon(Icons.person_rounded, color: AppColors.black, size: 34),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;
  final IconData icon;

  const _InfoChip({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryYellow.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.black),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.black),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MetricBox({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.bodyBold.copyWith(color: color, fontSize: 17),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.black),
          ),
        ],
      ),
    );
  }
}

class _PerformanceBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PerformanceBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryRed,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.white, size: 20),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
