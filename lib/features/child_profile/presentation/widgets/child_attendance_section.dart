import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildAttendanceSection extends StatelessWidget {
  final List<ChildAttendanceEntity> attendance;

  const ChildAttendanceSection({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final latestAttendance = attendance.take(5).toList();

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
            'Présences récentes',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.black,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            'Suivez les dernières présences, absences et retards enregistrés.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.darkGrey,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          if (latestAttendance.isEmpty)
            const _EmptyAttendance()
          else
            ...latestAttendance.map(
              (item) => _AttendanceTimelineItem(attendance: item),
            ),
        ],
      ),
    );
  }
}

class _AttendanceTimelineItem extends StatelessWidget {
  final ChildAttendanceEntity attendance;

  const _AttendanceTimelineItem({
    required this.attendance,
  });

  String get _statusLabel {
    switch (attendance.status.toUpperCase()) {
      case 'PRESENT':
      case 'PRÉSENT':
        return 'Présent';
      case 'ABSENT':
        return 'Absent';
      case 'RETARD':
      case 'LATE':
        return 'Retard';
      default:
        return 'Statut non renseigné';
    }
  }

  Color get _statusColor {
    switch (attendance.status.toUpperCase()) {
      case 'PRESENT':
      case 'PRÉSENT':
        return AppColors.success;
      case 'ABSENT':
        return AppColors.primaryRed;
      case 'RETARD':
      case 'LATE':
        return AppColors.warning;
      default:
        return AppColors.grey;
    }
  }

  IconData get _statusIcon {
    switch (attendance.status.toUpperCase()) {
      case 'PRESENT':
      case 'PRÉSENT':
        return Icons.check_circle_outline_rounded;
      case 'ABSENT':
        return Icons.cancel_outlined;
      case 'RETARD':
      case 'LATE':
        return Icons.schedule_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String get _dateText {
    final raw = attendance.date?.trim();

    if (raw == null || raw.isEmpty) {
      return 'Date indisponible';
    }

    final parsed = DateTime.tryParse(raw);

    if (parsed == null) {
      return raw;
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final year = parsed.year.toString();

    final hasTime = parsed.hour != 0 || parsed.minute != 0;

    if (!hasTime) {
      return '$day/$month/$year';
    }

    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');

    return '$day/$month/$year à $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _statusColor,
                    width: 1.1,
                  ),
                ),
                child: Icon(
                  _statusIcon,
                  color: _statusColor,
                  size: 22,
                ),
              ),
              Container(
                width: 2,
                height: 34,
                color: AppColors.lightGrey,
              ),
            ],
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: _statusColor.withValues(alpha: 0.45),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _dateText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      _statusLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: _statusColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAttendance extends StatelessWidget {
  const _EmptyAttendance();

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
            Icons.event_available_outlined,
            color: AppColors.primaryRed,
            size: 38,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aucune présence enregistrée',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Les informations de présence apparaîtront ici dès qu’elles seront ajoutées.',
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