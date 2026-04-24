import '../../domain/entities/session_entity.dart';
import '../../../../../shared/enums/user_role.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool requiresOtp;
  final String? pendingOtpEmail;
  final SessionEntity? session;
  final UserRole role;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.requiresOtp = false,
    this.pendingOtpEmail,
    this.session,
    this.role = UserRole.unknown,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? requiresOtp,
    String? pendingOtpEmail,
    SessionEntity? session,
    UserRole? role,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
    bool clearOtp = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      requiresOtp: requiresOtp ?? this.requiresOtp,
      pendingOtpEmail: clearOtp
          ? null
          : pendingOtpEmail ?? this.pendingOtpEmail,
      session: session ?? this.session,
      role: role ?? this.role,
      errorMessage: clearMessages ? null : errorMessage,
      successMessage: clearMessages ? null : successMessage,
    );
  }
}