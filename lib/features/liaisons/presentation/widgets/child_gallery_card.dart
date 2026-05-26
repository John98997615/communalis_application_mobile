import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
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
    return AnimatedScale(
      duration: const Duration(milliseconds: 160),
      scale: isSelected ? 1.02 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 190),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.white
                  : AppColors.white.withValues(alpha: 0.84),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isSelected ? AppColors.primaryRed : AppColors.black,
                width: isSelected ? 3 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isSelected ? 0.13 : 0.05,
                  ),
                  blurRadius: isSelected ? 16 : 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                _Avatar(photoUrl: child.photoUrl),
                const SizedBox(width: 8),
                Expanded(
                  child: _ChildInfo(child: child),
                ),
                const SizedBox(width: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          key: ValueKey('selected'),
                          color: AppColors.primaryRed,
                          size: 24,
                        )
                      : const Icon(
                          Icons.radio_button_unchecked_rounded,
                          key: ValueKey('unselected'),
                          color: AppColors.black,
                          size: 24,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChildInfo extends StatelessWidget {
  final ChildGalleryItemEntity child;

  const _ChildInfo({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final matricule = child.matricule.trim().isEmpty
        ? 'N° indisponible'
        : 'N°:${child.matricule}';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          child.fullName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 12.5,
            height: 1.05,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          child.className?.trim().isNotEmpty == true
              ? child.className!
              : 'Classe NC',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.darkGrey,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          matricule,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.darkGrey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return Container(
      width: 46,
      height: 46,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(
          color: AppColors.black,
          width: 1.3,
        ),
      ),
      child: ClipOval(
        child: hasPhoto
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: AppColors.primaryYellow,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.black,
                    ),
                  );
                },
              )
            : const ColoredBox(
                color: AppColors.primaryYellow,
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.black,
                ),
              ),
      ),
    );
  }
}