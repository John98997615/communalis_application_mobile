import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/app_error_view.dart';
import '../../../../../core/widgets/app_loader.dart';
import '../providers/child_chat_provider.dart';
import '../widgets/chat_header.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_bar.dart';

class ChildChatScreen extends ConsumerStatefulWidget {
  final int childId;
  final String childName;

  const ChildChatScreen({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  ConsumerState<ChildChatScreen> createState() => _ChildChatScreenState();
}

class _ChildChatScreenState extends ConsumerState<ChildChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _lastKnownMessageCount = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final notifier = ref.read(
        childChatProvider(widget.childId).notifier,
      );

      await notifier.loadMessages();
      notifier.startAutoRefresh();

      _lastKnownMessageCount = ref
          .read(childChatProvider(widget.childId))
          .messages
          .length;

      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    ref
        .read(childChatProvider(widget.childId).notifier)
        .stopAutoRefresh();

    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text;

    if (text.trim().isEmpty) return;

    _messageController.clear();

    await ref.read(childChatProvider(widget.childId).notifier).sendMessage(
          text,
        );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = childChatProvider(widget.childId);
    final state = ref.watch(provider);

    ref.listen(provider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }

      final hasMoreMessages = next.messages.length > _lastKnownMessageCount;

      if (next.hasNewMessages && hasMoreMessages) {
        _lastKnownMessageCount = next.messages.length;
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commentaires'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(
              title: widget.childName,
              subtitle: state.isRefreshing
                  ? 'Synchronisation en cours...'
                  : 'Discussion Parent ↔ Administrateur',
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state.isLoading && state.messages.isEmpty) {
                    return const AppLoader(
                      message: 'Chargement des commentaires...',
                    );
                  }

                  if (state.errorMessage != null && state.messages.isEmpty) {
                    return AppErrorView(
                      message: state.errorMessage!,
                      onRetry: () {
                        ref.read(provider.notifier).loadMessages();
                      },
                    );
                  }

                  if (state.messages.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Aucun commentaire pour le moment. Envoyez le premier message à l’administrateur.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return ref.read(provider.notifier).loadMessages();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];

                        return MessageBubble(message: message);
                      },
                    ),
                  );
                },
              ),
            ),
            MessageInputBar(
              controller: _messageController,
              isLoading: state.isSending,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}