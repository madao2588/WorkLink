import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/chat/domain/models/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.peerAvatar,
  });

  final ChatMessageModel message;
  final String peerAvatar;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.isMe;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(isMe),
          if (!isMe) const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.brandBlue : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 6),
                      bottomRight: Radius.circular(isMe ? 6 : 20),
                    ),
                    border: isMe
                        ? null
                        : Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(7),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 10),
          if (isMe) _buildAvatar(isMe),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isMe) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: isMe ? AppColors.brandBlue : const Color(0xFFEAF1FF),
      child: Text(
        isMe ? '我' : peerAvatar,
        style: TextStyle(
          color: isMe ? Colors.white : AppColors.brandBlue,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
