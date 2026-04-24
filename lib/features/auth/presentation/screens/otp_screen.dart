import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = ref.read(authProvider).pendingOtpEmail;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email introuvable. Veuillez vous reconnecter.'),
          backgroundColor: Colors.red,
        ),
      );
      context.go(RouteNames.login);
      return;
    }

    await ref.read(authProvider.notifier).verifyOtp(
          email: email,
          otp: _otpController.text,
        );

    if (!mounted) return;

    final state = ref.read(authProvider);

    if (state.isAuthenticated) {
      context.go(RouteNames.roleRedirect);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification OTP'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 35),

                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 72,
                ),

                const SizedBox(height: 18),

                const Text(
                  'Code de vérification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  authState.pendingOtpEmail == null
                      ? 'Entrez le code reçu par email.'
                      : 'Code envoyé à ${authState.pendingOtpEmail}',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                AppTextField(
                  controller: _otpController,
                  label: 'Code OTP',
                  prefixIcon: Icons.pin_outlined,
                  keyboardType: TextInputType.number,
                  validator: Validators.otp,
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: 'Vérifier le code',
                  isLoading: authState.isLoading,
                  onPressed: _submit,
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () => context.go(RouteNames.login),
                  child: const Text('Retour à la connexion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}