import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUsecase {
  final NotificationsRepository repository;

  GetNotificationsUsecase(this.repository);

  Future<List<NotificationEntity>> call() {
    return repository.getNotifications();
  }
}