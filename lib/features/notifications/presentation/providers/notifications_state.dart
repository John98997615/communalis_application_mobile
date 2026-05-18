import '../../domain/entities/notification_entity.dart';

class NotificationsState {
  final bool isLoading;
  final bool isRefreshing;
  final bool isUpdating;
  final List<NotificationEntity> notifications;
  final String? errorMessage;
  final String? successMessage;

  const NotificationsState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isUpdating = false,
    this.notifications = const [],
    this.errorMessage,
    this.successMessage,
  });

  int get unreadCount {
    return notifications.where((notification) => !notification.isRead).length;
  }

  NotificationsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isUpdating,
    List<NotificationEntity>? notifications,
    String? errorMessage,
    String? successMessage,
    bool clearFeedback = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isUpdating: isUpdating ?? this.isUpdating,
      notifications: notifications ?? this.notifications,
      errorMessage: clearFeedback ? null : errorMessage,
      successMessage: clearFeedback ? null : successMessage,
    );
  }
}