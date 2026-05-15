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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _StatBox(label: 'Présent', value: stats.presentCount, color: AppColors.success),
                _StatBox(label: 'Absent', value: stats.absentCount, color: AppColors.error),
                _StatBox(label: 'Retard', value: stats.lateCount, color: AppColors.warning),
              ],
            ),
            const SizedBox(height: 14),
            if (attendance.isEmpty)
              const Text('Aucune présence enregistrée.')
            else
              ...attendance.take(4).map(
                    (item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event_available_outlined),
                      title: Text(item.status),
                      subtitle: Text(item.date ?? ''),
                    ),
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
              style: TextStyle(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}