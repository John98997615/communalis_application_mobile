import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isFromParent;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryRed : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? AppRadius.lg : AppRadius.sm),
            topRight: Radius.circular(isMe ? AppRadius.sm : AppRadius.lg),
            bottomLeft: const Radius.circular(AppRadius.lg),
            bottomRight: const Radius.circular(AppRadius.lg),
          ),
          border: Border.all(
            color: isMe ? AppColors.primaryRed : AppColors.black,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.message.trim().isEmpty
                  ? 'Message indisponible'
                  : message.message,
              style: AppTextStyles.body.copyWith(
                color: isMe ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            if (message.createdAt != null &&
                message.createdAt!.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.createdAt!,
                    style: AppTextStyles.caption.copyWith(
                      color: isMe
                          ? AppColors.white.withValues(alpha: 0.82)
                          : AppColors.darkGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      Icons.done_all_rounded,
                      size: 14,
                      color: AppColors.white.withValues(alpha: 0.82),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}