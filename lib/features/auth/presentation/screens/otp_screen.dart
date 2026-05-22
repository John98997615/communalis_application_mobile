import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../shared/widgets/communalis_button.dart';
import '../../../../../shared/widgets/communalis_card.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  String get _otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer le code complet à 6 chiffres.'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    final email = ref.read(authProvider).pendingOtpEmail;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email introuvable. Veuillez vous reconnecter.'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      context.go(RouteNames.login);
      return;
    }

    await ref.read(authProvider.notifier).verifyOtp(
          email: email,
          otp: _otpCode,
        );

    if (!mounted) return;

    final state = ref.read(authProvider);

    if (state.isAuthenticated) {
      context.go(RouteNames.roleRedirect);
    }
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (_otpCode.length == 6) {
      FocusScope.of(context).unfocus();
    }
  }

  void _clearOtp() {
    for (final controller in _controllers) {
      controller.clear();
    }

    _focusNodes.first.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final email = authState.pendingOtpEmail;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.primaryRed,
          ),
        );
      }

      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.success,
          ),
        );
      }

      if (next.isAuthenticated) {
        context.go(RouteNames.roleRedirect);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: authState.isLoading
                      ? null
                      : () => context.go(RouteNames.login),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.black,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Vérification OTP',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 28,
                ),
              ),

              const SizedBox(height: 54),

              Text(
                'Entrez le code de vérification',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyBold.copyWith(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                email == null || email.isEmpty
                    ? 'Un code de 6 chiffres a été envoyé à votre email'
                    : 'Un code de 6 chiffres a été envoyé à $email',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 70),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) {
                    return _OtpBox(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      enabled: !authState.isLoading,
                      onChanged: (value) => _onChanged(value, index),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Code non reçu? ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: authState.isLoading
                        ? null
                        : () {
                            _clearOtp();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Le renvoi du code sera branché plus tard.',
                                ),
                              ),
                            );
                          },
                    child: Text(
                      'Renvoyer',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 58),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CommunalisButton(
                  text: 'Vérifier le code',
                  icon: Icons.verified_outlined,
                  isLoading: authState.isLoading,
                  onPressed: _submit,
                ),
              ),

              const SizedBox(height: 24),

              TextButton(
                onPressed: authState.isLoading
                    ? null
                    : () => context.go(RouteNames.login),
                child: Text(
                  'Retour à la connexion',
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onChanged,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool get _isActive =>
      widget.focusNode.hasFocus || widget.controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      if (mounted) setState(() {});
    });

    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 46,
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _isActive ? AppColors.primaryRed : AppColors.black,
          width: _isActive ? 2 : 1,
        ),
        boxShadow: _isActive
            ? [
                BoxShadow(
                  color: AppColors.primaryRed.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: AppTextStyles.titleSmall.copyWith(
          fontWeight: FontWeight.w800,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}