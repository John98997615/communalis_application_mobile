import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterParentScreen extends ConsumerStatefulWidget {
  const RegisterParentScreen({super.key});

  @override
  ConsumerState<RegisterParentScreen> createState() =>
      _RegisterParentScreenState();
}

class _RegisterParentScreenState extends ConsumerState<RegisterParentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirmation obligatoire';
    }

    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).registerParent(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
        );

    if (!mounted) return;

    final state = ref.read(authProvider);

    if (state.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Compte parent créé. Vous pouvez maintenant vous connecter.',
          ),
        ),
      );

      context.go(RouteNames.login);
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
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription Parent'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),

                const CircleAvatar(
                  radius: 42,
                  child: Icon(Icons.person_outline, size: 42),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Créer un compte parent',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                AppTextField(
                  controller: _firstNameController,
                  label: 'Prénom',
                  prefixIcon: Icons.person_outline,
                  validator: (value) => Validators.requiredField(
                    value,
                    fieldName: 'Prénom',
                  ),
                ),

                const SizedBox(height: 14),

                AppTextField(
                  controller: _lastNameController,
                  label: 'Nom',
                  prefixIcon: Icons.person_outline,
                  validator: (value) => Validators.requiredField(
                    value,
                    fieldName: 'Nom',
                  ),
                ),

                const SizedBox(height: 14),

                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(height: 14),

                AppTextField(
                  controller: _phoneController,
                  label: 'Téléphone',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),

                const SizedBox(height: 14),

                AppTextField(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                AppTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmer le mot de passe',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  validator: _confirmPasswordValidator,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: 'Créer mon compte',
                  isLoading: authState.isLoading,
                  onPressed: _submit,
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () => context.go(RouteNames.login),
                  child: const Text('J’ai déjà un compte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}