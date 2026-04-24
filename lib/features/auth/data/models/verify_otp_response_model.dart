import 'user_model.dart';

class VerifyOtpResponseModel {
  final String accessToken;
  final String? refreshToken;
  final UserModel user;
  final String? message;

  const VerifyOtpResponseModel({
    required this.accessToken,
    required this.user,
    this.refreshToken,
    this.message,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final source = data is Map<String, dynamic> ? data : json;

    final userJson = source['user'];

    final token = source['token'] ??
        source['accessToken'] ??
        source['access_token'];

    if (token == null || token.toString().isEmpty) {
      throw Exception('Token manquant dans la réponse OTP.');
    }

    if (userJson is! Map<String, dynamic>) {
      throw Exception('Utilisateur manquant dans la réponse OTP.');
    }

    return VerifyOtpResponseModel(
      accessToken: token.toString(),
      refreshToken: source['refreshToken']?.toString() ??
          source['refresh_token']?.toString(),
      user: UserModel.fromJson(userJson),
      message: source['message']?.toString() ?? json['message']?.toString(),
    );
  }
}