import 'package:flutter/material.dart';

import 'package:communalis_application_mobile/app/theme/app_colors.dart';
import '../../domain/entities/child_gallery_item_entity.dart';

class ChildGalleryCard extends StatelessWidget {
  final ChildGalleryItemEntity child;
  final bool isSelected;
  final VoidCallback onTap;

  const ChildGalleryCard({
    super.key,
    required this.child,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Avatar(photoUrl: child.photoUrl),
                const SizedBox(height: 12),
                Text(
                  child.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  child.className ?? 'Classe non renseignée',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  child.matricule.isEmpty
                      ? 'Matricule indisponible'
                      : child.matricule,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        key: ValueKey('selected'),
                      )
                    : const Icon(
                        Icons.radio_button_unchecked,
                        color: AppColors.textSecondary,
                        key: ValueKey('unselected'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;

  const _Avatar({
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.trim().isNotEmpty) {
      return CircleAvatar(
        radius: 36,
        backgroundColor: AppColors.background,
        child: ClipOval(
          child: Image.network(
            photoUrl!,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: ((context, error, stackTrace) => const Icon(
              Icons.person,
              size: 36,
            )),
          ),
        ),
      );
    }

    return const CircleAvatar(
      radius: 36,
      backgroundColor: AppColors.background,
      child: Icon(
        Icons.person,
        size: 36,
        color: AppColors.textSecondary,
      ),
    );
  }
}