import 'package:flutter/material.dart';

import '../../domain/entities/parent_child_summary_entity.dart';

class LatestAttendanceSection extends StatelessWidget {
  final ParentChildSummaryEntity child;

  const LatestAttendanceSection({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final attendance = child.latestAttendance;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Présences récentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (attendance.isEmpty)
              const Text('Aucune présence récente.')
            else
              ...attendance.take(3).map((presence) {
                final item = presence is Map ? presence : {};
                final status = item['statut'] ?? item['status'] ?? 'Présence';
                final date = item['date_seance'] ??
                    item['date_presence'] ??
                    item['date'] ??
                    '';

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_available_outlined),
                  title: Text(status.toString()),
                  subtitle: Text(date.toString()),
                );
              }),
          ],
        ),
      ),
    );
  }
}