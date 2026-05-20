import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildAttendanceSection extends StatelessWidget {
  final ChildProfileStatsEntity stats;
  final List<ChildAttendanceEntity> attendance;

  const ChildAttendanceSection({
    super.key,
    required this.stats,
    required this.attendance,
  });

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatAttendanceDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return 'Date non disponible';
    }

    final parsedDate = DateTime.tryParse(rawDate);

    if (parsedDate == null) {
      return rawDate;
    }

    final localDate = parsedDate.toLocal();

    final day = _twoDigits(localDate.day);
    final month = _twoDigits(localDate.month);
    final year = localDate.year.toString();

    final hasRealTime =
        localDate.hour != 0 || localDate.minute != 0 || localDate.second != 0;

    if (!hasRealTime) {
      return '$day/$month/$year';
    }

    final hour = _twoDigits(localDate.hour);
    final minute = _twoDigits(localDate.minute);

    return '$day/$month/$year à $hour:$minute';
  }

  Color _statusColor(String status) {
    final normalized = status.toUpperCase();

    if (normalized.contains('ABSENT')) return AppColors.error;
    if (normalized.contains('RETARD')) return AppColors.warning;

    return AppColors.success;
  }

  IconData _statusIcon(String status) {
    final normalized = status.toUpperCase();

    if (normalized.contains('ABSENT')) return Icons.cancel_outlined;
    if (normalized.contains('RETARD')) return Icons.schedule_outlined;

    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Présences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _StatBox(
                  label: 'Présent',
                  value: stats.presentCount,
                  color: AppColors.success,
                ),
                _StatBox(
                  label: 'Absent',
                  value: stats.absentCount,
                  color: AppColors.error,
                ),
                _StatBox(
                  label: 'Retard',
                  value: stats.lateCount,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (attendance.isEmpty)
              const Text('Aucune présence enregistrée.')
            else
              ...attendance.take(4).map(
                (item) {
                  final color = _statusColor(item.status);

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _statusIcon(item.status),
                      color: color,
                    ),
                    title: Text(
                      item.status,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      _formatAttendanceDate(item.date),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}