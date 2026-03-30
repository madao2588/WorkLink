class ChatMessageModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  bool isRead; // 注意：这个不是 final，因为已读状态会改变

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.isRead = false,
  });
}