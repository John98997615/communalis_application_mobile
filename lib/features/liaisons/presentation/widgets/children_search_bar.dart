import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ChildrenSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const ChildrenSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      inputFormatters: [
        LengthLimitingTextInputFormatter(60),
      ],
      style: AppTextStyles.bodyBold.copyWith(
        color: AppColors.black,
      ),
      decoration: InputDecoration(
        hintText: 'Rechercher par nom ou matricule...',
        hintStyle: AppTextStyles.body.copyWith(
          color: AppColors.darkGrey,
        ),
        filled: true,
        fillColor: AppColors.primaryYellow.withValues(alpha: 0.18),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.black,
        ),
        suffixIcon: IconButton(
          onPressed: onClear,
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.black,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.black,
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primaryRed,
            width: 2,
          ),
        ),
      ),
    );
  }
}