import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDatasource remoteDatasource;

  NotificationsRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final models = await remoteDatasource.getNotifications();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> markAsRead({
    required int notificationId,
  }) {
    return remoteDatasource.markAsRead(
      notificationId: notificationId,
    );
  }

  @override
  Future<void> markAllAsRead() {
    return remoteDatasource.markAllAsRead();
  }
}