import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../providers/forgot_password_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(forgotPasswordProvider.notifier).resetPassword(
          email: widget.email,
          otp: _otpController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Mot de passe réinitialisé avec succès.'
              : ref.read(forgotPasswordProvider).errorMessage ??
                  'Impossible de réinitialiser le mot de passe.',
        ),
        backgroundColor: success ? AppColors.success : AppColors.primaryRed,
      ),
    );

    if (success) {
      context.go(RouteNames.login);
    }
  }

  Future<void> _resendCode() async {
    final success = await ref
        .read(forgotPasswordProvider.notifier)
        .sendResetCode(widget.email);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Un nouveau code a été envoyé.'
              : ref.read(forgotPasswordProvider).errorMessage ??
                  'Impossible de renvoyer le code.',
        ),
        backgroundColor: success ? AppColors.success : AppColors.primaryRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      appBar: AppBar(
        backgroundColor: AppColors.primaryYellow,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => context.go(RouteNames.forgotPassword),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
              ),
            ),
            const Text(
              'Nouveau mot de passe',
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
                      Icons.verified_user_outlined,
                      color: AppColors.primaryRed,
                      size: 64,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Vérification du compte',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      'Entrez le code reçu par email puis choisissez un nouveau mot de passe.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.darkGrey,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Code obligatoire.';
                        }

                        if (value.trim().length != 6) {
                          return 'Le code doit contenir 6 chiffres.';
                        }

                        return null;
                      },
                      decoration: _inputDecoration(
                        label: 'Code de vérification',
                        icon: Icons.pin_outlined,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    _PasswordField(
                      controller: _newPasswordController,
                      label: 'Nouveau mot de passe',
                      obscureText: _hideNewPassword,
                      onToggle: () {
                        setState(() {
                          _hideNewPassword = !_hideNewPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nouveau mot de passe obligatoire.';
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
                      onToggle: () {
                        setState(() {
                          _hideConfirmPassword = !_hideConfirmPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Confirmation obligatoire.';
                        }

                        if (value.trim() !=
                            _newPasswordController.text.trim()) {
                          return 'Les mots de passe ne correspondent pas.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: state.isLoading ? null : _resendCode,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Renvoyer le code'),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: state.isLoading ? null : _submit,
                        icon: state.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Icon(Icons.lock_reset_rounded),
                        label: Text(
                          state.isLoading
                              ? 'Réinitialisation...'
                              : 'Réinitialiser le mot de passe',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            side: const BorderSide(color: AppColors.black),
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

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      counterText: '',
      prefixIcon: Icon(icon, color: AppColors.primaryRed),
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
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onToggle,
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
            onPressed: onToggle,
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