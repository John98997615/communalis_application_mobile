import '../../../../../app/config/api_endpoints.dart';
import '../../../../../core/network/api_client.dart';
import '../models/child_profile_model.dart';

class ChildProfileRemoteDatasource {
  final ApiClient apiClient;

  ChildProfileRemoteDatasource({
    required this.apiClient,
  });

  Future<ChildProfileModel> getChildProfile({
    required int childId,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.parentChildDetail(childId),
    );

    return ChildProfileModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }
}