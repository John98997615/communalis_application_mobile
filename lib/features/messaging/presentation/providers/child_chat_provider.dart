import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/network/api_client.dart';
import '../../data/datasources/messaging_remote_datasource.dart';
import '../../data/repositories/messaging_repository_impl.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../../domain/usecases/get_child_messages_usecase.dart';
import '../../domain/usecases/send_child_message_usecase.dart';
import 'child_chat_state.dart';

final messagingRemoteDatasourceProvider =
    Provider<MessagingRemoteDatasource>((ref) {
  return MessagingRemoteDatasource(
    apiClient: ApiClient.instance,
  );
});

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepositoryImpl(
    remoteDatasource: ref.watch(messagingRemoteDatasourceProvider),
  );
});

final getChildMessagesUsecaseProvider =
    Provider<GetChildMessagesUsecase>((ref) {
  return GetChildMessagesUsecase(
    ref.watch(messagingRepositoryProvider),
  );
});

final sendChildMessageUsecaseProvider =
    Provider<SendChildMessageUsecase>((ref) {
  return SendChildMessageUsecase(
    ref.watch(messagingRepositoryProvider),
  );
});

final childChatProvider =
    StateNotifierProvider.family<ChildChatNotifier, ChildChatState, int>(
  (ref, childId) {
    final notifier = ChildChatNotifier(
      childId: childId,
      getChildMessagesUsecase: ref.watch(getChildMessagesUsecaseProvider),
      sendChildMessageUsecase: ref.watch(sendChildMessageUsecaseProvider),
    );

    ref.onDispose(notifier.dispose);

    return notifier;
  },
);

class ChildChatNotifier extends StateNotifier<ChildChatState> {
  final int childId;
  final GetChildMessagesUsecase getChildMessagesUsecase;
  final SendChildMessageUsecase sendChildMessageUsecase;

  Timer? _autoRefreshTimer;
  bool _isAutoRefreshRunning = false;

  ChildChatNotifier({
    required this.childId,
    required this.getChildMessagesUsecase,
    required this.sendChildMessageUsecase,
  }) : super(const ChildChatState());

  Future<void> loadMessages() async {
    state = state.copyWith(
      isLoading: true,
      hasNewMessages: false,
      clearFeedback: true,
    );

    try {
      final messages = await getChildMessagesUsecase(
        childId: childId,
      );

      state = state.copyWith(
        isLoading: false,
        messages: messages,
        hasNewMessages: messages.isNotEmpty,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> refreshMessagesSilently() async {
    if (state.isLoading || state.isSending || state.isRefreshing) return;

    state = state.copyWith(
      isRefreshing: true,
      hasNewMessages: false,
      clearFeedback: true,
    );

    try {
      final freshMessages = await getChildMessagesUsecase(
        childId: childId,
      );

      final mergedMessages = _mergeMessages(
        currentMessages: state.messages,
        freshMessages: freshMessages,
      );

      final hasNewMessages =
          mergedMessages.length > state.messages.length;

      state = state.copyWith(
        isRefreshing: false,
        messages: hasNewMessages ? mergedMessages : state.messages,
        hasNewMessages: hasNewMessages,
      );
    } catch (_) {
      // Refresh silencieux : on évite d’afficher une erreur toutes les 5 secondes.
      state = state.copyWith(
        isRefreshing: false,
      );
    }
  }

  Future<void> sendMessage(String message) async {
    final text = message.trim();

    if (text.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Veuillez écrire un message.',
      );
      return;
    }

    state = state.copyWith(
      isSending: true,
      hasNewMessages: false,
      clearFeedback: true,
    );

    try {
      final sentMessage = await sendChildMessageUsecase(
        childId: childId,
        message: text,
      );

      final updatedMessages = _mergeMessages(
        currentMessages: state.messages,
        freshMessages: [
          sentMessage,
        ],
      );

      state = state.copyWith(
        isSending: false,
        messages: updatedMessages,
        hasNewMessages: true,
        successMessage: 'Message envoyé.',
      );
    } catch (error) {
      state = state.copyWith(
        isSending: false,
        errorMessage: error.toString(),
      );
    }
  }

  void startAutoRefresh({
    Duration interval = const Duration(seconds: 5),
  }) {
    if (_isAutoRefreshRunning) return;

    _isAutoRefreshRunning = true;

    _autoRefreshTimer?.cancel();

    _autoRefreshTimer = Timer.periodic(interval, (_) {
      refreshMessagesSilently();
    });
  }

  void stopAutoRefresh() {
    _isAutoRefreshRunning = false;
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  List<MessageEntity> _mergeMessages({
    required List<MessageEntity> currentMessages,
    required List<MessageEntity> freshMessages,
  }) {
    final Map<int, MessageEntity> byId = {
      for (final message in currentMessages) message.id: message,
    };

    for (final message in freshMessages) {
      byId[message.id] = message;
    }

    final merged = byId.values.toList();

    merged.sort((a, b) {
      final aDate = DateTime.tryParse(a.createdAt ?? '');
      final bDate = DateTime.tryParse(b.createdAt ?? '');

      if (aDate == null || bDate == null) {
        return a.id.compareTo(b.id);
      }

      return aDate.compareTo(bDate);
    });

    return merged;
  }

  void clearFeedback() {
    state = state.copyWith(clearFeedback: true);
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}