import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildOverviewCard extends StatelessWidget {
  final ChildProfileEntity child;

  const ChildOverviewCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.background,
              backgroundImage: child.photoUrl != null &&
                      child.photoUrl!.trim().isNotEmpty
                  ? NetworkImage(child.photoUrl!)
                  : null,
              child: child.photoUrl == null || child.photoUrl!.isEmpty
                  ? const Icon(Icons.person, size: 42)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.fullName,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    child.className ?? 'Classe non renseignée',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Matricule : ${child.matricule}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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