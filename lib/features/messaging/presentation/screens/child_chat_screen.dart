import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
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
      final notifier = ref.read(childChatProvider(widget.childId).notifier);

      await notifier.loadMessages();
      notifier.startAutoRefresh();

      _lastKnownMessageCount =
          ref.read(childChatProvider(widget.childId)).messages.length;

      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    ref.read(childChatProvider(widget.childId).notifier).stopAutoRefresh();

    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    _messageController.clear();

    await ref.read(childChatProvider(widget.childId).notifier).sendMessage(text);

    _scrollToBottom();
  }

  Future<void> _refreshMessages() {
    return ref.read(childChatProvider(widget.childId).notifier).loadMessages();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 180), () {
        if (!_scrollController.hasClients) return;

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      });
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
            backgroundColor: AppColors.primaryRed,
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
      backgroundColor: AppColors.primaryYellow,
      appBar: AppBar(
        backgroundColor: AppColors.primaryYellow,
        elevation: 0,
        title: const Text('Messagerie'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(
              title: widget.childName,
              subtitle: state.isRefreshing
                  ? 'Synchronisation en cours...'
                  : 'Discussion Parent ↔ Administration',
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state.isLoading && state.messages.isEmpty) {
                    return const _ChatSkeleton();
                  }

                  if (state.errorMessage != null && state.messages.isEmpty) {
                    return _ChatStateCard(
                      icon: Icons.wifi_off_rounded,
                      title: 'Impossible de charger la discussion',
                      message:
                          'Veuillez vérifier votre connexion puis réessayer.',
                      actionLabel: 'Réessayer',
                      onAction: _refreshMessages,
                    );
                  }

                  if (state.messages.isEmpty) {
                    return const _ChatStateCard(
                      icon: Icons.forum_outlined,
                      title: 'Aucun message pour le moment',
                      message:
                          'Envoyez votre premier message à l’administration concernant votre enfant.',
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primaryRed,
                    onRefresh: _refreshMessages,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.xl,
                      ),
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

class _ChatStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _ChatStateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: AppColors.black,
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppColors.primaryRed,
                size: 52,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.darkGrey,
                  height: 1.35,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      actionLabel!,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        side: const BorderSide(
                          color: AppColors.black,
                          width: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatSkeleton extends StatelessWidget {
  const _ChatSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        _SkeletonBubble(isMe: false),
        _SkeletonBubble(isMe: true),
        _SkeletonBubble(isMe: false),
        _SkeletonBubble(isMe: true),
      ],
    );
  }
}

class _SkeletonBubble extends StatelessWidget {
  final bool isMe;

  const _SkeletonBubble({
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.62,
        height: 58,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.70),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.black.withValues(alpha: 0.18),
          ),
        ),
      ),
    );
  }
}