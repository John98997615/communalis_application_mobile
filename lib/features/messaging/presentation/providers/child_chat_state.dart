import '../../domain/entities/message_entity.dart';

class ChildChatState {
  final bool isLoading;
  final bool isRefreshing;
  final bool isSending;
  final bool hasNewMessages;
  final List<MessageEntity> messages;
  final String? errorMessage;
  final String? successMessage;

  const ChildChatState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isSending = false,
    this.hasNewMessages = false,
    this.messages = const [],
    this.errorMessage,
    this.successMessage,
  });

  ChildChatState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isSending,
    bool? hasNewMessages,
    List<MessageEntity>? messages,
    String? errorMessage,
    String? successMessage,
    bool clearFeedback = false,
  }) {
    return ChildChatState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSending: isSending ?? this.isSending,
      hasNewMessages: hasNewMessages ?? this.hasNewMessages,
      messages: messages ?? this.messages,
      errorMessage: clearFeedback ? null : errorMessage,
      successMessage: clearFeedback ? null : successMessage,
    );
  }
}