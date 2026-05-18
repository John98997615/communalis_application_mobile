import '../repositories/notifications_repository.dart';

class MarkNotificationAsReadUsecase {
  final NotificationsRepository repository;

  MarkNotificationAsReadUsecase(this.repository);

  Future<void> call({
    required int notificationId,
  }) {
    return repository.markAsRead(
      notificationId: notificationId,
    );
  }
}