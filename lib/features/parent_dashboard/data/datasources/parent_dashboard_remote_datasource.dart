import '../../../../../app/config/api_endpoints.dart';
import '../../../../../core/network/api_client.dart';
import '../models/parent_dashboard_model.dart';

class ParentDashboardRemoteDatasource {
  final ApiClient apiClient;

  ParentDashboardRemoteDatasource({
    required this.apiClient,
  });

  Future<ParentDashboardModel> getDashboard() async {
    final response = await apiClient.get(
      ApiEndpoints.parentDashboard,
    );

    return ParentDashboardModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }
}