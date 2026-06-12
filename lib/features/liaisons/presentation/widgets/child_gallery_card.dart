import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
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

  String get _shortMatricule {
    final value = child.matricule.trim();

    if (value.isEmpty) return 'N° indispo.';

    return '#${value.replaceAll('STD', '').replaceAll('std', '').trim()}';
  }

  String get _statusLabel {
    switch (child.liaisonStatus) {
      case 'EN_ATTENTE':
        return 'Demande en attente';
      case 'APPROUVEE':
        return 'Déjà lié à votre compte';
      case 'REFUSEE':
        return 'Demande refusée';
      default:
        return 'Disponible';
    }
  }

  String get _childClassLabel {
    final value = child.className?.trim();

    if (value == null || value.isEmpty || value.toUpperCase() == 'NC') {
      return 'Classe non renseignée';
    }

    return value;
  }

  Color get _statusColor {
    switch (child.liaisonStatus) {
      case 'EN_ATTENTE':
        return AppColors.warning;
      case 'APPROUVEE':
        return AppColors.success;
      case 'REFUSEE':
        return AppColors.primaryRed;
      default:
        return AppColors.black;
    }
  }

  IconData get _statusIcon {
    switch (child.liaisonStatus) {
      case 'EN_ATTENTE':
        return Icons.hourglass_top_rounded;
      case 'APPROUVEE':
        return Icons.verified_rounded;
      case 'REFUSEE':
        return Icons.cancel_rounded;
      default:
        return Icons.add_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSelect = child.canRequestLiaison;

    return Opacity(
      opacity: canSelect ? 1 : 0.82,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: isSelected ? AppColors.primaryRed : AppColors.black,
                width: isSelected ? 2 : 1.2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    _Avatar(photoUrl: child.photoUrl),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        child.fullName.isEmpty ? 'Enfant' : child.fullName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.black,
                          fontSize: 13.5,
                          height: 1.05,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _SelectIcon(isSelected: isSelected, canSelect: canSelect),
                  ],
                ),

                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _childClassLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _MiniPill(text: _shortMatricule, color: AppColors.black),
                  ],
                ),

                const SizedBox(height: AppSpacing.xs),

                Align(
                  alignment: Alignment.centerLeft,
                  child: _StatusBadge(
                    label: _statusLabel,
                    color: _statusColor,
                    icon: _statusIcon,
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

class _SelectIcon extends StatelessWidget {
  final bool isSelected;
  final bool canSelect;

  const _SelectIcon({required this.isSelected, required this.canSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryRed
            : canSelect
            ? AppColors.primaryYellow.withValues(alpha: 0.40)
            : AppColors.lightGrey,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Icon(
        canSelect
            ? (isSelected ? Icons.check_rounded : Icons.add_rounded)
            : Icons.lock_outline_rounded,
        color: isSelected ? AppColors.white : AppColors.black,
        size: 18,
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String text;
  final Color color;

  const _MiniPill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 70),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 135),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;

  const _Avatar({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return Container(
      width: 46,
      height: 46,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(color: AppColors.black, width: 1.2),
      ),
      child: ClipOval(
        child: hasPhoto
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const _AvatarFallback();
                },
              )
            : const _AvatarFallback(),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primaryYellow,
      child: Icon(Icons.person_rounded, color: AppColors.black, size: 26),
    );
  }
}
