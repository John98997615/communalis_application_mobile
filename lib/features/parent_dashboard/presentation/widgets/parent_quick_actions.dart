import 'package:flutter/material.dart';

class ParentQuickActions extends StatelessWidget {
  const ParentQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: const [
            Expanded(
              child: _QuickAction(
                icon: Icons.bar_chart_outlined,
                label: 'Notes',
              ),
            ),
            Expanded(
              child: _QuickAction(
                icon: Icons.calendar_month_outlined,
                label: 'Présences',
              ),
            ),
            Expanded(
              child: _QuickAction(
                icon: Icons.chat_bubble_outline,
                label: 'Messages',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAction({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}