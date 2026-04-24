import 'user_model.dart';

class RegisterParentResponseModel {
  final String message;
  final UserModel? user;

  const RegisterParentResponseModel({
    required this.message,
    this.user,
  });

  factory RegisterParentResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? json['data']?['user'];

    return RegisterParentResponseModel(
      message: (json['message'] ??
              json['data']?['message'] ??
              'Compte parent créé avec succès.')
          .toString(),
      user: userJson is Map<String, dynamic>
          ? UserModel.fromJson(userJson)
          : null,
    );
  }
}