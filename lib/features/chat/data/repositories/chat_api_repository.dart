import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/features/chat/domain/models/chat_message_model.dart';
import 'package:my_first_app/features/chat/domain/models/conversation_summary.dart';
import 'package:my_first_app/features/chat/domain/repositories/chat_repository.dart';

class ChatApiRepository implements ChatRepository {
  ChatApiRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;
  List<ConversationSummary> _summaries = <ConversationSummary>[];
  final Map<String, List<ChatMessageModel>> _messagesByUserId =
      <String, List<ChatMessageModel>>{};
  final Map<String, String> _conversationIdsByUserId = <String, String>{};

  @override
  List<UserModel> getUsers() =>
      _summaries.map((ConversationSummary summary) => summary.user).toList(growable: false);

  @override
  List<ConversationSummary> getConversationSummaries() =>
      List<ConversationSummary>.unmodifiable(_summaries);

  @override
  List<ChatMessageModel> getMessages(String userId) =>
      List<ChatMessageModel>.unmodifiable(_messagesByUserId[userId] ?? const <ChatMessageModel>[]);

  @override
  int unreadCountFor(String userId) => _summaryFor(userId)?.unreadCount ?? 0;

  @override
  DateTime? latestMessageTimeFor(String userId) =>
      _summaryFor(userId)?.latestMessageTime;

  @override
  String latestPreviewFor(String userId) =>
      _summaryFor(userId)?.latestPreview ?? '新建聊天';

  @override
  int get totalMessageCount =>
      _summaries.fold<int>(0, (int sum, ConversationSummary s) => sum + s.unreadCount);

  @override
  int get unreadConversationCount =>
      _summaries.where((ConversationSummary summary) => summary.unreadCount > 0).length;

  @override
  Future<void> loadConversations() async {
    // 首刷/刷新只加载会话元信息（summary + conversationId 映射）。
    // 进入聊天详情后再按 userId 加载具体 messages。
    await _loadConversations(shouldLoadMessages: false);
  }

  @override
  Future<void> loadMessages(String userId) async {
    await _ensureConversationIdsLoaded(userId);
    final String conversationId = _requireConversationId(userId);
    final dynamic data = await _apiClient.get('/chat/conversations/$conversationId/messages');
    final List<dynamic> items = data as List<dynamic>? ?? <dynamic>[];
    _messagesByUserId[userId] = items.map((dynamic item) {
      final Map<String, dynamic> json = item as Map<String, dynamic>;
      return ChatMessageModel(
        id: json['messageId'] as String,
        senderId: json['senderId'] as String,
        content: json['content'] as String,
        timestamp: DateTime.parse(json['sentAt'] as String).toLocal(),
        isMe: json['isMe'] as bool? ?? false,
        isRead: json['isRead'] as bool? ?? true,
      );
    }).toList();
  }

  @override
  Future<void> markConversationRead(String userId) async {
    await _ensureConversationIdsLoaded(userId);
    final String conversationId = _requireConversationId(userId);
    final List<ChatMessageModel> messages = _messagesByUserId[userId] ?? const <ChatMessageModel>[];
    final String? lastMessageId = messages.isEmpty ? null : messages.last.id;
    await _apiClient.post(
      '/chat/conversations/$conversationId/read',
      body: <String, dynamic>{'lastReadMessageId': lastMessageId},
    );
    await loadConversations();
  }

  @override
  Future<void> sendMessage(String userId, String content) async {
    await _ensureConversationIdsLoaded(userId);
    final String conversationId = _requireConversationId(userId);
    await _apiClient.post(
      '/chat/conversations/$conversationId/messages',
      body: <String, dynamic>{'messageType': 'TEXT', 'content': content},
    );
    await loadMessages(userId);
    await loadConversations();
  }

  Future<void> _ensureConversationIdsLoaded(String userId) async {
    if (_conversationIdsByUserId.containsKey(userId)) {
      return;
    }
    // Deep link 场景下，只需要 conversationId 映射即可，避免重复拉全量消息。
    await _loadConversations(shouldLoadMessages: false);
  }

  Future<void> _loadConversations({required bool shouldLoadMessages}) async {
    _conversationIdsByUserId.clear();
    final dynamic data = await _apiClient.get('/chat/conversations');
    final List<dynamic> items = (data['items'] as List<dynamic>? ?? <dynamic>[]);

    _summaries = items.map((dynamic item) {
      final Map<String, dynamic> json = item as Map<String, dynamic>;
      final UserModel user = UserModel(
        id: json['userId'] as String,
        name: json['name'] as String,
        avatar: json['avatar'] as String,
        department: json['department'] as String,
        isOnline: json['isOnline'] as bool? ?? false,
      );
      final ConversationSummary summary = ConversationSummary(
        user: user,
        latestPreview: json['latestPreview'] as String? ?? '',
        latestMessageTime: _parseDateTime(json['latestMessageTime']),
        unreadCount: json['unreadCount'] as int? ?? 0,
      );
      _conversationIdsByUserId[user.id] = json['conversationId'] as String;
      return summary;
    }).toList();

    if (!shouldLoadMessages) {
      return;
    }

    for (final ConversationSummary summary in _summaries) {
      await loadMessages(summary.userId);
    }
  }

  DateTime? _parseDateTime(dynamic rawValue) {
    if (rawValue == null) {
      return null;
    }
    return DateTime.tryParse(rawValue.toString())?.toLocal();
  }

  ConversationSummary? _summaryFor(String userId) {
    for (final ConversationSummary summary in _summaries) {
      if (summary.userId == userId) {
        return summary;
      }
    }
    return null;
  }

  String _requireConversationId(String userId) {
    final String? conversationId = _conversationIdsByUserId[userId];
    if (conversationId == null) {
      throw ApiException('会话未找到');
    }
    return conversationId;
  }
}
