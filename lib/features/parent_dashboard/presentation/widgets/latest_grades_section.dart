import 'package:flutter/material.dart';

import '../../domain/entities/parent_child_summary_entity.dart';

class LatestGradesSection extends StatelessWidget {
  final ParentChildSummaryEntity child;

  const LatestGradesSection({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final grades = child.latestGrades;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dernières notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (grades.isEmpty)
              const Text('Aucune note récente.')
            else
              ...grades.take(3).map((grade) {
                final item = grade is Map ? grade : {};
                final subject = item['matiere'] ?? item['subject'] ?? 'Matière';
                final value = item['valeur'] ?? item['note'] ?? '--';

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.school_outlined),
                  title: Text(subject.toString()),
                  trailing: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}