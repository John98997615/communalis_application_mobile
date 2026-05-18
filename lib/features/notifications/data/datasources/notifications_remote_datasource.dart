import '../../../../../app/config/api_endpoints.dart';
import '../../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationsRemoteDatasource {
  final ApiClient apiClient;

  NotificationsRemoteDatasource({
    required this.apiClient,
  });

  Future<List<NotificationModel>> getNotifications() async {
    final response = await apiClient.get(
      ApiEndpoints.parentNotifications,
    );

    final data = response.data;

    List<dynamic> rawNotifications = [];

    if (data is Map<String, dynamic>) {
      final responseData = data['data'];

      if (responseData is Map<String, dynamic> &&
          responseData['notifications'] is List) {
        rawNotifications = responseData['notifications'] as List;
      } else if (data['notifications'] is List) {
        rawNotifications = data['notifications'] as List;
      }
    }

    return rawNotifications
        .whereType<Map<String, dynamic>>()
        .map(NotificationModel.fromJson)
        .toList();
  }

  Future<void> markAsRead({
    required int notificationId,
  }) async {
    await apiClient.patch(
      ApiEndpoints.markParentNotificationAsRead(notificationId),
    );
  }

  Future<void> markAllAsRead() async {
    await apiClient.patch(
      ApiEndpoints.markAllParentNotificationsAsRead,
    );
  }
}