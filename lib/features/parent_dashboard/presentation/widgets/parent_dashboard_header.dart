import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ParentDashboardHeader extends StatefulWidget {
  final String parentName;
  final VoidCallback? onBack;
  final VoidCallback? onProfileTap;
  final String? parentPhotoUrl;

  const ParentDashboardHeader({
    super.key,
    required this.parentName,
    this.onBack,
    this.onProfileTap,
    this.parentPhotoUrl,
  });

  @override
  State<ParentDashboardHeader> createState() => _ParentDashboardHeaderState();
}

class _ParentDashboardHeaderState extends State<ParentDashboardHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _displayName {
    final value = widget.parentName.trim();
    return value.isEmpty ? 'Parent' : value;
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: AppSpacing.xs),

                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: widget.onProfileTap,
                      child: Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.black,
                            width: 1.6,
                          ),
                        ),
                        child: ClipOval(
                          child:
                              widget.parentPhotoUrl != null &&
                                  widget.parentPhotoUrl!.trim().isNotEmpty
                              ? Image.network(
                                  widget.parentPhotoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const _ParentAvatarFallback();
                                  },
                                )
                              : const _ParentAvatarFallback(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Espace parent',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.black,
                            fontSize: 26,
                            height: 1.05,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xs),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Bienvenue, ',
                              style: AppTextStyles.bodyBold.copyWith(
                                color: AppColors.primaryRed,
                                fontStyle: FontStyle.italic,
                                height: 1,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: AppColors.black,
                                  height: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1.3,
              width: double.infinity,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentAvatarFallback extends StatelessWidget {
  const _ParentAvatarFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primaryYellow,
      child: Icon(
        Icons.person_outline_rounded,
        color: AppColors.black,
        size: 34,
      ),
    );
  }
}
