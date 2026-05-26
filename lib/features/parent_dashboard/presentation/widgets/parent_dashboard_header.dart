import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ParentDashboardHeader extends StatefulWidget {
  final String parentName;
  final VoidCallback? onBack;
  final VoidCallback? onProfileTap;

  const ParentDashboardHeader({
    super.key,
    required this.parentName,
    this.onBack,
    this.onProfileTap,
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
      duration: const Duration(milliseconds: 450),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _displayName {
    final name = widget.parentName.trim();

    if (name.isEmpty) return 'Parent';

    return name;
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),

                  GestureDetector(
                    onTap: widget.onProfileTap,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.black,
                          width: 1.4,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.black,
                        size: 28,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

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
                            fontSize: 25,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 3),
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Bienvenue,\n',
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: AppColors.primaryRed,
                                  fontStyle: FontStyle.italic,
                                  height: 1.05,
                                ),
                              ),
                              TextSpan(
                                text: _displayName,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                  height: 1.05,
                                ),
                              ),
                            ],
                          ),
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