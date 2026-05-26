import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';

class DashboardSkeleton extends StatefulWidget {
  const DashboardSkeleton({super.key});

  @override
  State<DashboardSkeleton> createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<DashboardSkeleton>
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

    _pulse = Tween<double>(
      begin: 0.35,
      end: 0.75,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _color(double value) {
    return AppColors.white.withValues(alpha: value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            Row(
              children: [
                _SkeletonBox(
                  width: 38,
                  height: 38,
                  radius: AppRadius.pill,
                  color: _color(_pulse.value),
                ),
                const SizedBox(width: AppSpacing.md),
                _SkeletonBox(
                  width: 52,
                  height: 52,
                  radius: AppRadius.pill,
                  color: _color(_pulse.value),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(
                        width: double.infinity,
                        height: 24,
                        radius: AppRadius.sm,
                        color: _color(_pulse.value),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SkeletonBox(
                        width: 120,
                        height: 16,
                        radius: AppRadius.sm,
                        color: _color(_pulse.value),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            Container(
              height: 1.3,
              color: AppColors.black.withValues(alpha: 0.75),
            ),

            const SizedBox(height: AppSpacing.xl),

            _SkeletonCard(
              height: 96,
              color: _color(_pulse.value),
            ),

            const SizedBox(height: AppSpacing.xl),

            _SkeletonBox(
              width: 150,
              height: 28,
              radius: AppRadius.sm,
              color: _color(_pulse.value),
            ),

            const SizedBox(height: AppSpacing.sm),

            _SkeletonBox(
              width: 260,
              height: 16,
              radius: AppRadius.sm,
              color: _color(_pulse.value),
            ),

            const SizedBox(height: AppSpacing.lg),

            _SkeletonChildCard(color: _color(_pulse.value)),

            const SizedBox(height: AppSpacing.lg),

            _SkeletonChildCard(color: _color(_pulse.value)),
          ],
        );
      },
    );
  }
}

class _SkeletonChildCard extends StatelessWidget {
  final Color color;

  const _SkeletonChildCard({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _SkeletonBox(
                width: 68,
                height: 68,
                radius: AppRadius.pill,
                color: color,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(
                      width: double.infinity,
                      height: 22,
                      radius: AppRadius.sm,
                      color: color,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _SkeletonBox(
                      width: 130,
                      height: 14,
                      radius: AppRadius.sm,
                      color: color,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _SkeletonBox(
                      width: 170,
                      height: 14,
                      radius: AppRadius.sm,
                      color: color,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _SkeletonBox(
                  width: double.infinity,
                  height: 42,
                  radius: AppRadius.md,
                  color: color,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SkeletonBox(
                  width: double.infinity,
                  height: 42,
                  radius: AppRadius.md,
                  color: color,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SkeletonBox(
                  width: double.infinity,
                  height: 42,
                  radius: AppRadius.md,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
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
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black, width: 1.2),
      ),
      child: Center(
        child: _SkeletonBox(
          width: 220,
          height: 22,
          radius: AppRadius.sm,
          color: color,
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color color;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}