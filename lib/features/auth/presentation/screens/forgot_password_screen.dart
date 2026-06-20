import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../providers/forgot_password_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(forgotPasswordProvider.notifier)
        .sendResetCode(_emailController.text);

    if (!mounted) return;

    if (success) {
      context.go(
        '${RouteNames.resetPassword}?email=${Uri.encodeComponent(_emailController.text.trim())}',
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ref.read(forgotPasswordProvider).errorMessage ??
              'Impossible d’envoyer le code.',
        ),
        backgroundColor: AppColors.primaryRed,
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
              onPressed: () => context.go(RouteNames.login),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
              ),
            ),
            const Text(
              'Mot de passe oublié',
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
                      Icons.lock_reset_rounded,
                      color: AppColors.primaryRed,
                      size: 64,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Réinitialiser votre mot de passe',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Entrez votre email parent. Un code de vérification vous sera envoyé.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.darkGrey,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email obligatoire.';
                        }
                        if (!value.contains('@')) {
                          return 'Email invalide.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.primaryRed,
                        ),
                        filled: true,
                        fillColor:
                            AppColors.primaryYellow.withValues(alpha: 0.12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          borderSide: const BorderSide(color: AppColors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
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
                            : const Icon(Icons.send_outlined),
                        label: Text(
                          state.isLoading
                              ? 'Envoi du code...'
                              : 'Envoyer le code',
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
}