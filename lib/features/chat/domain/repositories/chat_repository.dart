import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/features/chat/domain/models/chat_message_model.dart';
import 'package:my_first_app/features/chat/domain/models/conversation_summary.dart';

abstract class ChatRepository {
  List<UserModel> getUsers();
  List<ConversationSummary> getConversationSummaries();
  List<ChatMessageModel> getMessages(String userId);
  int unreadCountFor(String userId);
  DateTime? latestMessageTimeFor(String userId);
  String latestPreviewFor(String userId);
  int get totalMessageCount;
  int get unreadConversationCount;
  Future<void> loadConversations();
  Future<void> loadMessages(String userId);
  Future<void> markConversationRead(String userId);
  Future<void> sendMessage(String userId, String content);
}
