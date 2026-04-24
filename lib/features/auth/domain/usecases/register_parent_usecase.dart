import '../repositories/auth_repository.dart';

class RegisterParentUsecase {
  final AuthRepository repository;

  RegisterParentUsecase(this.repository);

  Future<String> call({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? photoPath,
  }) {
    return repository.registerParent(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
      photoPath: photoPath,
    );
  }
}