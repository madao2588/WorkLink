import 'dart:async';

import 'package:flutter/material.dart';

import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/features/chat/domain/models/chat_message_model.dart';
import 'package:my_first_app/features/chat/domain/models/conversation_summary.dart';
import 'package:my_first_app/features/chat/domain/repositories/chat_repository.dart';

class ChatProvider with ChangeNotifier {
  ChatProvider({required ChatRepository repository}) : _repository = repository;

  final ChatRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _repository.getUsers();
  List<ConversationSummary> get conversationSummaries =>
      _repository.getConversationSummaries();
  int get totalMessageCount => _repository.totalMessageCount;
  int get unreadConversationCount => _repository.unreadConversationCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void handleSessionChanged(bool authenticated) {
    if (authenticated) {
      unawaited(refresh());
      return;
    }
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.loadConversations();
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ChatMessageModel> getMessages(String userId) {
    return _repository.getMessages(userId);
  }

  Future<void> ensureMessagesLoaded(String userId) async {
    try {
      await _repository.loadMessages(userId);
      notifyListeners();
    } on ApiException catch (error) {
      _errorMessage = error.message;
      notifyListeners();
    }
  }

  int unreadCountFor(String userId) => _repository.unreadCountFor(userId);

  DateTime? latestMessageTimeFor(String userId) =>
      _repository.latestMessageTimeFor(userId);

  String latestPreviewFor(String userId) => _repository.latestPreviewFor(userId);

  Future<void> markConversationRead(String userId) async {
    await _repository.markConversationRead(userId);
    notifyListeners();
  }

  Future<void> sendMessage(String userId, String content) async {
    await _repository.sendMessage(userId, content);
    notifyListeners();
  }
}
