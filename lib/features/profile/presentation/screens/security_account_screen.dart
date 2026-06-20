import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../providers/profile_provider.dart';

class SecurityAccountScreen extends ConsumerStatefulWidget {
  const SecurityAccountScreen({super.key});

  @override
  ConsumerState<SecurityAccountScreen> createState() =>
      _SecurityAccountScreenState();
}

class _SecurityAccountScreenState extends ConsumerState<SecurityAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(profileProvider.notifier).changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Mot de passe modifié avec succès.'
              : ref.read(profileProvider).errorMessage ??
                  'Impossible de modifier le mot de passe.',
        ),
        backgroundColor: success ? AppColors.success : AppColors.primaryRed,
      ),
    );

    if (success) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      context.go(RouteNames.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryYellow,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.profile);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
              ),
            ),
            const Text(
              'Sécurité du compte',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.black, width: 1.2),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.primaryRed,
                      size: 54,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Modifier votre mot de passe',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Utilisez un mot de passe fort pour protéger votre compte parent.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.darkGrey,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    _PasswordField(
                      controller: _currentPasswordController,
                      label: 'Ancien mot de passe',
                      obscureText: _hideCurrentPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _hideCurrentPassword = !_hideCurrentPassword;
                        });
                      },
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'L’ancien mot de passe est obligatoire.'
                              : null,
                    ),

                    _PasswordField(
                      controller: _newPasswordController,
                      label: 'Nouveau mot de passe',
                      obscureText: _hideNewPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _hideNewPassword = !_hideNewPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Le nouveau mot de passe est obligatoire.';
                        }

                        if (value.trim().length < 8) {
                          return 'Minimum 8 caractères.';
                        }

                        return null;
                      },
                    ),

                    _PasswordField(
                      controller: _confirmPasswordController,
                      label: 'Confirmer le mot de passe',
                      obscureText: _hideConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _hideConfirmPassword = !_hideConfirmPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez confirmer le mot de passe.';
                        }

                        if (value.trim() !=
                            _newPasswordController.text.trim()) {
                          return 'Les mots de passe ne correspondent pas.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: state.isSaving ? null : _submit,
                        icon: state.isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Icon(Icons.verified_user_outlined),
                        label: Text(
                          state.isSaving
                              ? 'Modification...'
                              : 'Modifier le mot de passe',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            side: const BorderSide(
                              color: AppColors.black,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onToggleVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.primaryRed,
          ),
          suffixIcon: IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.darkGrey,
            ),
          ),
          filled: true,
          fillColor: AppColors.primaryYellow.withValues(alpha: 0.12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: const BorderSide(color: AppColors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: const BorderSide(color: AppColors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: const BorderSide(
              color: AppColors.primaryRed,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}