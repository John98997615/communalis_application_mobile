import '../../../../../shared/enums/user_role.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final UserRole role;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['_id'] ?? json['userId'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: UserRole.fromString(json['role']?.toString()),
      firstName: json['firstName']?.toString() ??
          json['firstname']?.toString() ??
          json['prenom']?.toString(),
      lastName: json['lastName']?.toString() ??
          json['lastname']?.toString() ??
          json['nom']?.toString(),
      phone: json['phone']?.toString() ??
          json['telephone']?.toString() ??
          json['numero']?.toString(),
      avatarUrl: json['avatarUrl']?.toString() ??
          json['avatar']?.toString() ??
          json['photo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.value,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      role: role,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }
}