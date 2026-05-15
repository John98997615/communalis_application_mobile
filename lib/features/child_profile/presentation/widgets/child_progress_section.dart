import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildProgressSection extends StatelessWidget {
  final ChildProfileEntity child;

  const ChildProgressSection({
    super.key,
    required this.child,
  });

  Color get _color {
    switch (child.performanceLevel.toUpperCase()) {
      case 'GOOD':
        return AppColors.success;
      case 'AVERAGE':
        return AppColors.warning;
      case 'LOW':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  String get _label {
    switch (child.performanceLevel.toUpperCase()) {
      case 'GOOD':
        return 'Bonne progression';
      case 'AVERAGE':
        return 'Progression moyenne';
      case 'LOW':
        return 'Progression à surveiller';
      default:
        return 'Pas encore évalué';
    }
  }

  @override
  Widget build(BuildContext context) {
    final average = child.average == null ? '--' : child.average!.toStringAsFixed(1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  average,
                  style: TextStyle(
                    color: _color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _label,
                    style: TextStyle(
                      color: _color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Progression calculée à partir des dernières notes disponibles.',
                    style: TextStyle(color: AppColors.textSecondary),
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