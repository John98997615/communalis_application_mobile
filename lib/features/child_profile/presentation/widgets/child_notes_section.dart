import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildNotesSection extends StatelessWidget {
  final List<ChildGradeEntity> grades;

  const ChildNotesSection({
    super.key,
    required this.grades,
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
              'Notes récentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (grades.isEmpty)
              const Text('Aucune note enregistrée.')
            else
              ...grades.take(5).map(
                    (grade) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.school_outlined),
                      title: Text(grade.subject),
                      subtitle: Text(grade.remark ?? grade.date ?? ''),
                      trailing: Text(
                        grade.value == null ? '--' : grade.value!.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}