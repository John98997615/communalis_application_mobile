import '../entities/session_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;

  VerifyOtpUsecase(this.repository);

  Future<SessionEntity> call({
    required String email,
    required String otp,
  }) {
    return repository.verifyOtp(
      email: email,
      otp: otp,
    );
  }
}