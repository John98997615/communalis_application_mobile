import '../../../../../core/storage/secure_storage_service.dart';
import '../models/session_model.dart';

class AuthLocalDatasource {
  final SecureStorageService secureStorage;

  AuthLocalDatasource({
    required this.secureStorage,
  });

  Future<void> saveSession(SessionModel session) async {
    await secureStorage.saveAccessToken(session.accessToken);

    if (session.refreshToken != null && session.refreshToken!.isNotEmpty) {
      await secureStorage.saveRefreshToken(session.refreshToken!);
    }

    await secureStorage.saveUserId(session.user.id);
    await secureStorage.saveUserEmail(session.user.email);
    await secureStorage.saveUserRole(session.user.role.value);
  }

  Future<String?> getAccessToken() {
    return secureStorage.getAccessToken();
  }

  Future<String?> getUserRole() {
    return secureStorage.getUserRole();
  }

  Future<String?> getUserEmail() {
    return secureStorage.getUserEmail();
  }

  Future<void> clearSession() {
    return secureStorage.clearSession();
  }
}