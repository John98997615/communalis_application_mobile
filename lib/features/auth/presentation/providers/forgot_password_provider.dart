import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/network/api_client.dart';

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
  return ForgotPasswordNotifier(apiClient: ApiClient.instance);
});

class ForgotPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const ForgotPasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final ApiClient apiClient;

  ForgotPasswordNotifier({required this.apiClient})
      : super(const ForgotPasswordState());

  Future<bool> sendResetCode(String email) async {
    state = const ForgotPasswordState(isLoading: true);

    try {
      await apiClient.post(
        '/auth/forgot-password',
        data: {'email': email.trim()},
      );

      state = const ForgotPasswordState(
        successMessage: 'Code envoyé avec succès.',
      );

      return true;
    } catch (error) {
      state = ForgotPasswordState(
        errorMessage: error.toString(),
      );

      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const ForgotPasswordState(isLoading: true);

    try {
      await apiClient.post(
        '/auth/reset-password',
        data: {
          'email': email.trim(),
          'otp': otp.trim(),
          'newPassword': newPassword.trim(),
          'confirmPassword': confirmPassword.trim(),
        },
      );

      state = const ForgotPasswordState(
        successMessage: 'Mot de passe réinitialisé.',
      );

      return true;
    } catch (error) {
      state = ForgotPasswordState(
        errorMessage: error.toString(),
      );

      return false;
    }
  }
}