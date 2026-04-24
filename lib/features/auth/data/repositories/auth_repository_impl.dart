import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_parent_request_model.dart';
import '../models/session_model.dart';
import '../models/verify_otp_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<String> registerParent({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? photoPath,
  }) async {
    final response = await remoteDatasource.registerParent(
      RegisterParentRequestModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        photoPath: photoPath,
      ),
    );

    return response.message;
  }

  @override
  Future<SessionEntity?> login({
    required String email,
    required String password,
  }) async {
    final response = await remoteDatasource.login(
      LoginRequestModel(
        email: email,
        password: password,
      ),
    );

    if (response.requiresOtp) {
      return null;
    }

    if (response.accessToken == null || response.user == null) {
      throw Exception(
        response.message ?? 'Réponse de connexion invalide.',
      );
    }

    final session = SessionModel(
      accessToken: response.accessToken!,
      refreshToken: response.refreshToken,
      user: response.user!,
    );

    await localDatasource.saveSession(session);

    return session.toEntity();
  }

  @override
  Future<SessionEntity> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await remoteDatasource.verifyOtp(
      VerifyOtpRequestModel(
        email: email,
        otp: otp,
      ),
    );

    final session = SessionModel(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      user: response.user,
    );

    await localDatasource.saveSession(session);

    return session.toEntity();
  }

  @override
  Future<bool> hasActiveSession() async {
    final token = await localDatasource.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getStoredRole() {
    return localDatasource.getUserRole();
  }

  @override
  Future<String?> getStoredEmail() {
    return localDatasource.getUserEmail();
  }

  @override
  Future<void> logout() {
    return localDatasource.clearSession();
  }
}