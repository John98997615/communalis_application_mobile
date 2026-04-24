import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/storage/secure_storage_service.dart';
import '../../../../../shared/enums/user_role.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_parent_usecase.dart';
import '../../domain/usecases/restore_session_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ApiClient.instance,
  );
});

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  return AuthLocalDatasource(
    secureStorage: SecureStorageService.instance,
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDatasource: ref.watch(authRemoteDatasourceProvider),
    localDatasource: ref.watch(authLocalDatasourceProvider),
  );
});

final registerParentUsecaseProvider = Provider<RegisterParentUsecase>((ref) {
  return RegisterParentUsecase(
    ref.watch(authRepositoryProvider),
  );
});

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(
    ref.watch(authRepositoryProvider),
  );
});

final verifyOtpUsecaseProvider = Provider<VerifyOtpUsecase>((ref) {
  return VerifyOtpUsecase(
    ref.watch(authRepositoryProvider),
  );
});

final restoreSessionUsecaseProvider = Provider<RestoreSessionUsecase>((ref) {
  return RestoreSessionUsecase(
    ref.watch(authRepositoryProvider),
  );
});

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(
    ref.watch(authRepositoryProvider),
  );
});

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    registerParentUsecase: ref.watch(registerParentUsecaseProvider),
    loginUsecase: ref.watch(loginUsecaseProvider),
    verifyOtpUsecase: ref.watch(verifyOtpUsecaseProvider),
    restoreSessionUsecase: ref.watch(restoreSessionUsecaseProvider),
    logoutUsecase: ref.watch(logoutUsecaseProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final RegisterParentUsecase registerParentUsecase;
  final LoginUsecase loginUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final RestoreSessionUsecase restoreSessionUsecase;
  final LogoutUsecase logoutUsecase;

  AuthNotifier({
    required this.registerParentUsecase,
    required this.loginUsecase,
    required this.verifyOtpUsecase,
    required this.restoreSessionUsecase,
    required this.logoutUsecase,
  }) : super(const AuthState());

  Future<void> registerParent({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? photoPath,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearMessages: true,
    );

    try {
      final message = await registerParentUsecase(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        photoPath: photoPath,
      );

      state = state.copyWith(
        isLoading: false,
        successMessage: message,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearMessages: true,
      clearOtp: true,
    );

    try {
      final session = await loginUsecase(
        email: email,
        password: password,
      );

      if (session == null) {
        state = state.copyWith(
          isLoading: false,
          requiresOtp: true,
          pendingOtpEmail: email,
          isAuthenticated: false,
          role: UserRole.parent,
          successMessage: 'Un code OTP a été envoyé à votre email.',
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        requiresOtp: false,
        session: session,
        role: session.user.role,
        successMessage: 'Connexion réussie.',
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearMessages: true,
    );

    try {
      final session = await verifyOtpUsecase(
        email: email,
        otp: otp,
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        requiresOtp: false,
        pendingOtpEmail: null,
        session: session,
        role: session.user.role,
        successMessage: 'Vérification réussie.',
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> restoreSession() async {
    state = state.copyWith(
      isLoading: true,
      clearMessages: true,
    );

    try {
      final hasSession = await restoreSessionUsecase.hasActiveSession();
      final storedRole = await restoreSessionUsecase.getStoredRole();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: hasSession,
        role: UserRole.fromString(storedRole),
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        role: UserRole.unknown,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    await logoutUsecase();

    state = const AuthState();
  }

  void clearMessages() {
    state = state.copyWith(clearMessages: true);
  }
}