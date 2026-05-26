import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';

class SelectedChildrenFooter extends StatelessWidget {
  final int selectedCount;
  final bool isLoading;
  final VoidCallback? onSubmit;

  const SelectedChildrenFooter({
    super.key,
    required this.selectedCount,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedCount > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          top: BorderSide(color: AppColors.lightGrey),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onSubmit,
          icon: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Icon(
                  hasSelection
                      ? Icons.send_rounded
                      : Icons.touch_app_outlined,
                ),
          label: Text(
            hasSelection
                ? 'Envoyer la demande ($selectedCount)'
                : 'Sélectionnez un enfant',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
                hasSelection ? AppColors.primaryRed : AppColors.lightGrey,
            foregroundColor: hasSelection ? AppColors.white : AppColors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ),
      ),
    );
  }
}