import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildCommentsPreview extends StatelessWidget {
  final List<ChildCommentEntity> comments;

  const ChildCommentsPreview({
    super.key,
    required this.comments,
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
              'Commentaires récents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (comments.isEmpty)
              const Text('Aucun commentaire pour le moment.')
            else
              ...comments.take(3).map(
                    (comment) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.message,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${comment.authorRole ?? 'Auteur'} • ${comment.date ?? ''}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}