import 'package:flutter/material.dart';

import '../../domain/entities/parent_child_summary_entity.dart';

class ParentProgressCard extends StatelessWidget {
  final ParentChildSummaryEntity child;

  const ParentProgressCard({
    super.key,
    required this.child,
  });

  Color get _color {
    switch (child.performanceLevel.toUpperCase()) {
      case 'GOOD':
        return Colors.green;
      case 'AVERAGE':
        return Colors.orange;
      case 'LOW':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  String get _label {
    switch (child.performanceLevel.toUpperCase()) {
      case 'GOOD':
        return 'Bonne progression';
      case 'AVERAGE':
        return 'Progression moyenne';
      case 'LOW':
        return 'À surveiller';
      default:
        return 'Non évalué';
    }
  }

  @override
  Widget build(BuildContext context) {
    final averageText = child.average == null
        ? '--'
        : child.average!.toStringAsFixed(1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: _color.withValues(alpha: 0.12),
              child: Text(
                averageText,
                style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _label,
                    style: TextStyle(
                      color: _color,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    child.average == null
                        ? 'Aucune note disponible pour le moment.'
                        : 'Moyenne récente basée sur les dernières notes.',
                    style: const TextStyle(
                      color: Colors.black54,
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