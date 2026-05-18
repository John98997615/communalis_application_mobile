import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/network/api_client.dart';
import '../../data/datasources/notifications_remote_datasource.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_as_read_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';
import 'notifications_state.dart';

final notificationsRemoteDatasourceProvider =
    Provider<NotificationsRemoteDatasource>((ref) {
  return NotificationsRemoteDatasource(
    apiClient: ApiClient.instance,
  );
});

final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) {
  return NotificationsRepositoryImpl(
    remoteDatasource: ref.watch(notificationsRemoteDatasourceProvider),
  );
});

final getNotificationsUsecaseProvider =
    Provider<GetNotificationsUsecase>((ref) {
  return GetNotificationsUsecase(
    ref.watch(notificationsRepositoryProvider),
  );
});

final markNotificationAsReadUsecaseProvider =
    Provider<MarkNotificationAsReadUsecase>((ref) {
  return MarkNotificationAsReadUsecase(
    ref.watch(notificationsRepositoryProvider),
  );
});

final markAllNotificationsAsReadUsecaseProvider =
    Provider<MarkAllNotificationsAsReadUsecase>((ref) {
  return MarkAllNotificationsAsReadUsecase(
    ref.watch(notificationsRepositoryProvider),
  );
});

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(
    getNotificationsUsecase: ref.watch(getNotificationsUsecaseProvider),
    markNotificationAsReadUsecase:
        ref.watch(markNotificationAsReadUsecaseProvider),
    markAllNotificationsAsReadUsecase:
        ref.watch(markAllNotificationsAsReadUsecaseProvider),
  );
});

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final GetNotificationsUsecase getNotificationsUsecase;
  final MarkNotificationAsReadUsecase markNotificationAsReadUsecase;
  final MarkAllNotificationsAsReadUsecase markAllNotificationsAsReadUsecase;

  NotificationsNotifier({
    required this.getNotificationsUsecase,
    required this.markNotificationAsReadUsecase,
    required this.markAllNotificationsAsReadUsecase,
  }) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    state = state.copyWith(
      isLoading: true,
      clearFeedback: true,
    );

    try {
      final notifications = await getNotificationsUsecase();

      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> refreshNotifications() async {
    if (state.isLoading || state.isRefreshing) return;

    state = state.copyWith(
      isRefreshing: true,
      clearFeedback: true,
    );

    try {
      final notifications = await getNotificationsUsecase();

      state = state.copyWith(
        isRefreshing: false,
        notifications: notifications,
      );
    } catch (_) {
      state = state.copyWith(
        isRefreshing: false,
      );
    }
  }

  Future<void> markAsRead(int notificationId) async {
    state = state.copyWith(
      isUpdating: true,
      clearFeedback: true,
    );

    try {
      await markNotificationAsReadUsecase(
        notificationId: notificationId,
      );

      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id != notificationId) return notification;

        return notification.copyWith(isRead: true);
      }).toList();

      state = state.copyWith(
        isUpdating: false,
        notifications: updatedNotifications,
      );
    } catch (error) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> markAllAsRead() async {
    state = state.copyWith(
      isUpdating: true,
      clearFeedback: true,
    );

    try {
      await markAllNotificationsAsReadUsecase();

      final updatedNotifications = state.notifications.map((notification) {
        return notification.copyWith(isRead: true);
      }).toList();

      state = state.copyWith(
        isUpdating: false,
        notifications: updatedNotifications,
        successMessage: 'Toutes les notifications sont marquées comme lues.',
      );
    } catch (error) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: error.toString(),
      );
    }
  }

  void clearFeedback() {
    state = state.copyWith(clearFeedback: true);
  }
}

class NotificationEntityCopy {
  static dynamic from(
    dynamic notification, {
    bool? isRead,
  }) {
    return notification.runtimeType == notification.runtimeType
        ? notification.copyWith?.call(isRead: isRead)
        : notification;
  }
}