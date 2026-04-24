import '../repositories/auth_repository.dart';

class RestoreSessionUsecase {
  final AuthRepository repository;

  RestoreSessionUsecase(this.repository);

  Future<bool> hasActiveSession() {
    return repository.hasActiveSession();
  }

  Future<String?> getStoredRole() {
    return repository.getStoredRole();
  }

  Future<String?> getStoredEmail() {
    return repository.getStoredEmail();
  }
}