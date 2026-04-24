import '../../../../../app/config/api_endpoints.dart';
import '../../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_parent_request_model.dart';
import '../models/register_parent_response_model.dart';
import '../models/verify_otp_request_model.dart';
import '../models/verify_otp_response_model.dart';

class AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasource({
    required this.apiClient,
  });

  Future<RegisterParentResponseModel> registerParent(
    RegisterParentRequestModel request,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.authRegisterParent,
      data: request.toJson(),
    );

    return RegisterParentResponseModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await apiClient.post(
      ApiEndpoints.authLogin,
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  Future<VerifyOtpResponseModel> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.authVerifyOtp,
      data: request.toJson(),
    );

    return VerifyOtpResponseModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }
}