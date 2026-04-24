import 'user_model.dart';

class LoginResponseModel {
  final bool requiresOtp;
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;
  final String? message;

  const LoginResponseModel({
    required this.requiresOtp,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final source = data is Map<String, dynamic> ? data : json;

    final userJson = source['user'];

    final token = source['token'] ??
        source['accessToken'] ??
        source['access_token'];

    return LoginResponseModel(
      requiresOtp: source['requiresOtp'] == true ||
          source['otpRequired'] == true ||
          source['needOtp'] == true,
      accessToken: token?.toString(),
      refreshToken: source['refreshToken']?.toString() ??
          source['refresh_token']?.toString(),
      user: userJson is Map<String, dynamic>
          ? UserModel.fromJson(userJson)
          : null,
      message: source['message']?.toString() ?? json['message']?.toString(),
    );
  }
}