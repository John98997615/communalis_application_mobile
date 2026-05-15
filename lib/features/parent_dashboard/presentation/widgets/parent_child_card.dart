import 'package:flutter/material.dart';

import '../../domain/entities/parent_child_summary_entity.dart';
import 'parent_progress_card.dart';

class ParentChildCard extends StatelessWidget {
  final ParentChildSummaryEntity child;
  final VoidCallback? onTap;

  const ParentChildCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundImage: child.photoUrl != null &&
                            child.photoUrl!.isNotEmpty
                        ? NetworkImage(child.photoUrl!)
                        : null,
                    child: child.photoUrl == null || child.photoUrl!.isEmpty
                        ? const Icon(Icons.person, size: 34)
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
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          child.className ?? 'Classe non renseignée',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Matricule : ${child.matricule}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 16),
              ParentProgressCard(child: child),
            ],
          ),
        ),
      ),
    );
  }
}