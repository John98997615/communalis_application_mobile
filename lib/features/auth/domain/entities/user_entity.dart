import '../../../../../shared/enums/user_role.dart';

class UserEntity {
  final String id;
  final String email;
  final UserRole role;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatarUrl,
  });

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final result = '$first $last'.trim();

    return result.isEmpty ? email : result;
  }
}