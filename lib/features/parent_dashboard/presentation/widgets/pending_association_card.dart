import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class PendingAssociationCard extends StatefulWidget {
  final int pendingCount;

  const PendingAssociationCard({super.key, required this.pendingCount});

  @override
  State<PendingAssociationCard> createState() => _PendingAssociationCardState();
}

class _PendingAssociationCardState extends State<PendingAssociationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _title {
    if (widget.pendingCount <= 1) {
      return '1 demande d’association en attente';
    }

    return '${widget.pendingCount} demandes d’association en attente';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pendingCount <= 0) {
      return const SizedBox.shrink();
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 450),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, AppSpacing.lg * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.black, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  color: AppColors.primaryRed,
                  size: 30,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title,
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.primaryRed,
                      fontSize: 16,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  Text(
                    'L’administrateur validera votre demande prochainement.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                      height: 1.3,
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
