import '../entities/session_entity.dart';

abstract class AuthRepository {
  Future<String> registerParent({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? photoPath,
  });

  Future<SessionEntity?> login({
    required String email,
    required String password,
  });

  Future<SessionEntity> verifyOtp({
    required String email,
    required String otp,
  });

  Future<bool> hasActiveSession();

  Future<String?> getStoredRole();

  Future<String?> getStoredEmail();

  Future<void> logout();
}