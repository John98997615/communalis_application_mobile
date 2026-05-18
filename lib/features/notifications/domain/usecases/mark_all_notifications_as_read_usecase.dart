import '../repositories/notifications_repository.dart';

class MarkAllNotificationsAsReadUsecase {
  final NotificationsRepository repository;

  MarkAllNotificationsAsReadUsecase(this.repository);

  Future<void> call() {
    return repository.markAllAsRead();
  }
}