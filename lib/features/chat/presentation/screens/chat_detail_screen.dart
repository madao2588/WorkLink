import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/chat/domain/models/chat_message_model.dart';
import 'package:my_first_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:my_first_app/features/chat/presentation/widgets/chat_bubble.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.userId,
    required this.name,
    required this.avatar,
    required this.isOnline,
    required this.department,
  });

  final String userId;
  final String name;
  final String avatar;
  final bool isOnline;
  final String department;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showSuggestions = true;

  final List<String> _quickReplies = const <String>[
    '收到，我马上处理',
    '好的，稍后给你结果',
    '可以，我再确认一下细节',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      final ChatProvider chatProvider = context.read<ChatProvider>();
      await chatProvider.ensureMessagesLoaded(widget.userId);
      await chatProvider.markConversationRead(widget.userId);
      _jumpToBottom();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChatProvider provider = context.watch<ChatProvider>();
    final List<ChatMessageModel> messages = provider.getMessages(widget.userId);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.name),
            const SizedBox(height: 2),
            Text(
              widget.isOnline ? '在线 · ${widget.department}' : widget.department,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildTopStatus(provider.errorMessage),
          Expanded(
            child: Container(
              color: const Color(0xFFF6F8FC),
              child: messages.isEmpty && provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 12, bottom: 16),
                      children: _buildTimeline(messages),
                    ),
            ),
          ),
          if (_showSuggestions && _controller.text.trim().isEmpty)
            _buildQuickReplies(),
          _buildComposer(provider.isLoading),
        ],
      ),
    );
  }

  Widget _buildTopStatus(String? errorMessage) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.isOnline
                  ? AppColors.success.withAlpha(14)
                  : AppColors.textHint.withAlpha(16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              widget.isOnline ? Icons.wifi_tethering : Icons.schedule_rounded,
              color: widget.isOnline
                  ? AppColors.success
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage ??
                  (widget.isOnline
                      ? '${widget.name} 当前在线，适合快速推进沟通'
                      : '${widget.name} 当前离线，消息会在对方上线后看到'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTimeline(List<ChatMessageModel> messages) {
    final List<Widget> items = <Widget>[];
    DateTime? previousDay;

    for (final ChatMessageModel message in messages) {
      final DateTime currentDay = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      if (previousDay == null || previousDay != currentDay) {
        items.add(_buildDateBadge(message.timestamp));
        previousDay = currentDay;
      }

      items.add(
        ChatBubble(
          message: message,
          peerAvatar: widget.avatar,
        ),
      );
    }

    return items;
  }

  Widget _buildDateBadge(DateTime time) {
    final DateTime now = DateTime.now();
    String label;
    if (DateUtils.isSameDay(now, time)) {
      label = 'Today';
    } else if (DateUtils.isSameDay(
      now.subtract(const Duration(days: 1)),
      time,
    )) {
      label = 'Yesterday';
    } else {
      label = DateFormat('MM/dd').format(time);
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      color: const Color(0xFFF6F8FC),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _quickReplies.map((String reply) {
          return ActionChip(
            label: Text(reply),
            onPressed: () {
              _controller.text = reply;
              setState(() {
                _showSuggestions = false;
              });
            },
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.border),
            labelStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildComposer(bool isSending) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Attachment support will come next')),
                );
              },
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF2F4F7),
              ),
              icon: const Icon(
                Icons.add_rounded,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                onChanged: (String value) {
                  setState(() {
                    _showSuggestions = value.trim().isEmpty;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: isSending ? null : _handleSend,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(68, 52),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSend() async {
    final String text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }

    await context.read<ChatProvider>().sendMessage(widget.userId, text);
    _controller.clear();
    setState(() {
      _showSuggestions = true;
    });
    _jumpToBottom();
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }
}
