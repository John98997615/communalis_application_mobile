import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/router/route_names.dart';
import 'package:flutter/services.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../shared/widgets/communalis_button.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryRed,
            content: Text(next.errorMessage!),
          ),
        );
      }

      if (next.requiresOtp && next.pendingOtpEmail != null) {
        context.go(RouteNames.otp);
        return;
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 38),

                Text(
                  'Connexion',
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 28),
                ),

                const SizedBox(height: 28),

                Image.asset(
                  'assets/images/communalis_logo.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 34),

                _AuthAnimatedField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'votre@email.com',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    LengthLimitingTextInputFormatter(80),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre email.';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalide.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                _AuthAnimatedField(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  hint: 'Entrez votre mot de passe',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    LengthLimitingTextInputFormatter(32),
                  ],
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre mot de passe.';
                    }
                    return null;
                  },
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.go(RouteNames.forgotPassword);
                    },
                    child: Text(
                      'Mot de passe oublié?',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 42),

                CommunalisButton(
                  text: 'Se connecter',
                  icon: Icons.arrow_forward_rounded,
                  isLoading: authState.isLoading,
                  onPressed: _login,
                ),

                const SizedBox(height: 14),

                Text('Ou', style: AppTextStyles.bodyBold),

                const SizedBox(height: 14),

                _GoogleButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(
                                      alpha: 0.12,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.construction_rounded,
                                    size: 40,
                                    color: Colors.orange,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                const Text(
                                  'Connexion Google bientôt disponible',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                const Text(
                                  'Veuillez utiliser votre compte Communalis avec votre adresse email et votre mot de passe pour le moment.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    height: 1.4,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Compris'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 70),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous n’avez pas de compte? ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go(RouteNames.registerParent);
                      },
                      child: Text(
                        'Créer un compte',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthAnimatedField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const _AuthAnimatedField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
  });

  @override
  State<_AuthAnimatedField> createState() => _AuthAnimatedFieldState();
}

class _AuthAnimatedFieldState extends State<_AuthAnimatedField> {
  final _focusNode = FocusNode();

  bool get _isActive =>
      _focusNode.hasFocus || widget.controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryRed),
        ),
        const SizedBox(height: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.hint,
                prefixIcon: const SizedBox(width: 52),
                suffixIcon: widget.suffixIcon,
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(
                    color: AppColors.primaryRed,
                    width: 2,
                  ),
                ),
              ),
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              left: _isActive ? 16 : 14,
              top: _isActive ? -14 : 15,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.all(_isActive ? 6 : 0),
                decoration: BoxDecoration(
                  color: _isActive
                      ? AppColors.primaryYellow
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: _isActive ? 18 : 22,
                  color: _isActive ? AppColors.primaryRed : AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoogleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          side: const BorderSide(color: AppColors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/google_logo.png', width: 45, height: 45),
            const SizedBox(width: AppSpacing.md),
            Text('Continuer avec google', style: AppTextStyles.bodyBold),
          ],
        ),
      ),
    );
  }
}
