import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';

enum CommunalisButtonVariant {
  primary,
  secondary,
  outline,
}

class CommunalisButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final CommunalisButtonVariant variant;

  const CommunalisButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = CommunalisButtonVariant.primary,
  });

  Color get _backgroundColor {
    switch (variant) {
      case CommunalisButtonVariant.primary:
        return AppColors.primaryRed;
      case CommunalisButtonVariant.secondary:
        return AppColors.primaryYellow;
      case CommunalisButtonVariant.outline:
        return AppColors.white;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case CommunalisButtonVariant.primary:
        return AppColors.white;
      case CommunalisButtonVariant.secondary:
      case CommunalisButtonVariant.outline:
        return AppColors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _foregroundColor,
                ),
              )
            : Icon(icon ?? Icons.arrow_forward, color: _foregroundColor),
        label: Text(
          isLoading ? 'Chargement...' : text,
          style: AppTextStyles.button.copyWith(color: _foregroundColor),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}