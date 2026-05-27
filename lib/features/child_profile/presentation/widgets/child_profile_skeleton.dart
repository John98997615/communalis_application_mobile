import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';

class ChildProfileSkeleton extends StatefulWidget {
  const ChildProfileSkeleton({super.key});

  @override
  State<ChildProfileSkeleton> createState() => _ChildProfileSkeletonState();
}

class _ChildProfileSkeletonState extends State<ChildProfileSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _color() => AppColors.white.withValues(alpha: _pulse.value);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _SkeletonCard(
              height: 170,
              color: _color(),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SkeletonCard(
              height: 260,
              color: _color(),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SkeletonCard(
              height: 230,
              color: _color(),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SkeletonCard(
              height: 230,
              color: _color(),
            ),
          ],
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double height;
  final Color color;

  const _SkeletonCard({
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.black,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 160, height: 22, color: color),
          const SizedBox(height: AppSpacing.md),
          _SkeletonBox(width: double.infinity, height: 14, color: color),
          const SizedBox(height: AppSpacing.sm),
          _SkeletonBox(width: 220, height: 14, color: color),
          const Spacer(),
          _SkeletonBox(width: double.infinity, height: 46, color: color),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}