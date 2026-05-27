import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildProgressSection extends StatelessWidget {
  final ChildProfileEntity child;

  const ChildProgressSection({
    super.key,
    required this.child,
  });

  double get _average => child.average ?? 0;

  double get _attendanceRate {
    if (child.stats.totalAttendance <= 0) return 0;

    return (child.stats.presentCount / child.stats.totalAttendance) * 100;
  }

  Color get _averageColor {
    if (_average >= 14) return AppColors.success;
    if (_average >= 10) return AppColors.warning;

    return AppColors.primaryRed;
  }

  String get _averageLabel {
    if (_average >= 14) return 'Très bon niveau';
    if (_average >= 10) return 'En progression';

    return 'À accompagner';
  }

  String get _appreciation {
    final latestRemark = child.grades
        .where((grade) => grade.remark != null && grade.remark!.trim().isNotEmpty)
        .map((grade) => grade.remark!.trim())
        .cast<String?>()
        .firstOrNull;

    if (latestRemark != null && latestRemark.isNotEmpty) {
      return latestRemark;
    }

    switch (child.performanceLevel.toUpperCase()) {
      case 'GOOD':
        return 'Très bonne progression. Continuez à l’encourager.';
      case 'AVERAGE':
        return 'Des efforts sont visibles. Un accompagnement régulier aidera encore plus.';
      case 'LOW':
        return 'Un suivi attentif peut aider votre enfant à mieux progresser.';
      default:
        return 'Les informations seront plus précises après les prochaines évaluations.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final averageText = child.average == null ? '--/20' : '${_average.toStringAsFixed(1)}/20';

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 450),
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
          border: Border.all(
            color: AppColors.black,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Résumé scolaire',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Suivez rapidement les performances et la progression de votre enfant.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.darkGrey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _ProgressStatCard(
                    title: 'Moyenne',
                    value: averageText,
                    icon: Icons.auto_graph_rounded,
                    color: _averageColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ProgressStatCard(
                    title: 'Présence',
                    value: '${_attendanceRate.toStringAsFixed(0)}%',
                    icon: Icons.verified_user_outlined,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _ProgressStatCard(
                    title: 'Absences',
                    value: '${child.stats.absentCount}',
                    icon: Icons.event_busy_outlined,
                    color: child.stats.absentCount == 0
                        ? AppColors.success
                        : AppColors.primaryRed,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _PerformanceCard(
                    label: _averageLabel,
                    appreciation: _appreciation,
                    color: _averageColor,
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

class _ProgressStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ProgressStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: color,
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.black,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final String label;
  final String appreciation;
  final Color color;

  const _PerformanceCard({
    required this.label,
    required this.appreciation,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: color,
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.black,
            ),
          ),
          const Spacer(),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyBold.copyWith(
              color: color,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            appreciation,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.darkGrey,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}