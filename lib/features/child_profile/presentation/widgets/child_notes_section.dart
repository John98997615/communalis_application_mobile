import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildNotesSection extends StatelessWidget {
  final List<ChildGradeEntity> grades;

  const ChildNotesSection({
    super.key,
    required this.grades,
  });

  @override
  Widget build(BuildContext context) {
    final latestGrades = grades.take(5).toList();

    return Container(
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
            'Notes récentes',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Consultez les dernières évaluations et appréciations enregistrées.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.darkGrey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (latestGrades.isEmpty)
            const _EmptyGrades()
          else
            ...latestGrades.map(
              (grade) => _GradeTile(grade: grade),
            ),
        ],
      ),
    );
  }
}

class _GradeTile extends StatelessWidget {
  final ChildGradeEntity grade;

  const _GradeTile({
    required this.grade,
  });

  double get _value => grade.value ?? 0;

  Color get _gradeColor {
    if (grade.value == null) return AppColors.grey;
    if (_value >= 14) return AppColors.success;
    if (_value >= 10) return AppColors.warning;
    return AppColors.primaryRed;
  }

  String get _gradeText {
    if (grade.value == null) return '--/20';
    return '${_value.toStringAsFixed(1)}/20';
  }

  String get _dateText {
    final raw = grade.date?.trim();

    if (raw == null || raw.isEmpty) {
      return 'Date non renseignée';
    }

    final parsed = DateTime.tryParse(raw);

    if (parsed == null) {
      return raw;
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final year = parsed.year.toString();

    return '$day/$month/$year';
  }

  String get _remarkText {
    final remark = grade.remark?.trim();

    if (remark == null || remark.isEmpty) {
      return 'Aucune appréciation pour le moment.';
    }

    return remark;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: _gradeColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: _gradeColor.withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: _gradeColor.withValues(alpha: 0.14),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _gradeColor,
                  width: 1.1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _gradeText,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: _gradeColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grade.subject.trim().isEmpty
                        ? 'Matière non renseignée'
                        : grade.subject,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _remarkText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.darkGrey,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _dateText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w700,
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

class _EmptyGrades extends StatelessWidget {
  const _EmptyGrades();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primaryYellow.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.black,
          width: 1.1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.school_outlined,
            color: AppColors.primaryRed,
            size: 38,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aucune note enregistrée',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Les notes et appréciations apparaîtront ici dès qu’elles seront ajoutées.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.darkGrey,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}