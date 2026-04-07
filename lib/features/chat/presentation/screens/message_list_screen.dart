import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/shared/widgets/app_dashboard_hero.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/chat/domain/models/conversation_summary.dart';
import 'package:my_first_app/features/chat/presentation/providers/chat_provider.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';
  _MessageFilter _filter = _MessageFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final ChatProvider chatProvider = context.read<ChatProvider>();
      // 登录/会话恢复时已由 provider 侧触发首刷；此处只在为空时兜底刷新。
      if (chatProvider.conversationSummaries.isEmpty &&
          !chatProvider.isLoading) {
        unawaited(chatProvider.refresh());
      }
    });
    _searchController.addListener(() {
      setState(() {
        _keyword = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = context.watch<ChatProvider>();
    final Color surfaceColor = AppThemePalette.surface(context);
    final Color borderColor = AppThemePalette.border(context);
    final Color titleColor = AppThemePalette.textPrimary(context);
    final Color subtitleColor = AppThemePalette.textSecondary(context);
    final List<ConversationSummary> allSummaries =
        chatProvider.conversationSummaries;
    final List<ConversationSummary> onlineSummaries = allSummaries
        .where((summary) => summary.isOnline)
        .toList();
    final List<ConversationSummary> filteredSummaries = allSummaries
        .where(_matchesKeyword)
        .where(_matchesFilter)
        .toList();

    return Scaffold(
      backgroundColor: AppThemePalette.pageBackground(context),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              sliver: SliverList.list(
                children: [
                  _buildHeroCard(
                    totalMessages: chatProvider.totalMessageCount,
                    unreadConversations: chatProvider.unreadConversationCount,
                    onlineCount: onlineSummaries.length,
                  ),
                  if (chatProvider.isLoading) ...const <Widget>[
                    SizedBox(height: 16),
                    Center(child: CircularProgressIndicator()),
                  ],
                  if (chatProvider.errorMessage != null) ...<Widget>[
                    const SizedBox(height: 16),
                    Text(
                      chatProvider.errorMessage!,
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _buildSearchBox(surfaceColor),
                  const SizedBox(height: 14),
                  _buildFilterPanel(chatProvider, surfaceColor, borderColor),
                  const SizedBox(height: 14),
                  _buildInboxSummary(
                    conversationCount: filteredSummaries.length,
                    unreadCount: chatProvider.unreadConversationCount,
                    backgroundColor: AppThemePalette.subtleSurface(context),
                    borderColor: AppThemePalette.strongBorder(context),
                    subtitleColor: subtitleColor,
                    titleColor: titleColor,
                  ),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    title: '在线协作',
                    subtitle: '适合优先联系当前在线的同事，推进会更及时',
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: onlineSummaries.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final ConversationSummary summary =
                            onlineSummaries[index];
                        return _OnlineCollaboratorCard(
                          summary: summary,
                          onTap: () => _openChat(context, summary),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    title: '最近消息',
                    subtitle: _filter == _MessageFilter.all
                        ? '按最近会话时间排序'
                        : '当前已按筛选条件收窄结果',
                  ),
                  const SizedBox(height: 14),
                  if (filteredSummaries.isEmpty)
                    _buildEmptyState()
                  else
                    ...filteredSummaries.map((summary) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ConversationCard(
                          summary: summary,
                          onTap: () => _openChat(context, summary),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard({
    required int totalMessages,
    required int unreadConversations,
    required int onlineCount,
  }) {
    return AppDashboardHero(
      title: '让会话更清晰',
      subtitle: '把未读消息、在线同事和最近会话集中到一个更容易扫读的入口里。',
      badgeText: '消息中心',
      icon: Icons.forum_rounded,
      stats: <AppDashboardHeroStat>[
        AppDashboardHeroStat(label: '未读会话', value: '$unreadConversations'),
        AppDashboardHeroStat(label: '在线同事', value: '$onlineCount'),
        AppDashboardHeroStat(label: '未读消息', value: '$totalMessages'),
      ],
    );
  }

  Widget _buildSearchBox(Color surfaceColor) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索消息内容、同事或部门',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _keyword.isEmpty
              ? null
              : IconButton(
                  onPressed: _searchController.clear,
                  icon: const Icon(Icons.close_rounded),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPanel(
    ChatProvider chatProvider,
    Color surfaceColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _buildFilterChip(
            label: '全部',
            filter: _MessageFilter.all,
            count: chatProvider.conversationSummaries.length,
          ),
          _buildFilterChip(
            label: '未读',
            filter: _MessageFilter.unread,
            count: chatProvider.unreadConversationCount,
          ),
          _buildFilterChip(
            label: '在线',
            filter: _MessageFilter.online,
            count: chatProvider.conversationSummaries
                .where((summary) => summary.isOnline)
                .length,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required _MessageFilter filter,
    required int count,
  }) {
    final bool selected = _filter == filter;
    final Color surfaceColor = AppThemePalette.surface(context);
    final Color borderColor = AppThemePalette.border(context);
    final Color labelColor = AppThemePalette.textSecondary(context);

    return ChoiceChip(
      selected: selected,
      label: Text('$label $count'),
      onSelected: (_) => setState(() => _filter = filter),
      selectedColor: AppColors.brandBlue.withAlpha(16),
      labelStyle: TextStyle(
        color: selected ? AppColors.brandBlue : labelColor,
        fontWeight: FontWeight.w700,
      ),
      side: BorderSide(
        color: selected ? AppColors.brandBlue : borderColor,
      ),
      backgroundColor: surfaceColor,
    );
  }

  Widget _buildInboxSummary({
    required int conversationCount,
    required int unreadCount,
    required Color backgroundColor,
    required Color borderColor,
    required Color subtitleColor,
    required Color titleColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.brandBlue.withAlpha(14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.inbox_outlined, color: AppColors.brandBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              unreadCount > 0
                  ? '当前有 $unreadCount 个未读会话，建议优先处理。'
                  : '所有消息都已处理完，现在可以安心推进别的工作。',
              style: TextStyle(
                color: subtitleColor,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$conversationCount 条',
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required String subtitle}) {
    final Color titleColor = AppThemePalette.textPrimary(context);
    final Color subtitleColor = AppThemePalette.textSecondary(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: subtitleColor),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final Color surfaceColor = AppThemePalette.surface(context);
    final Color borderColor = AppThemePalette.border(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.mark_chat_read_outlined,
            size: 40,
            color: AppThemePalette.textHint(context),
          ),
          const SizedBox(height: 12),
          Text(
            '没有匹配到会话',
            style: TextStyle(
              color: AppThemePalette.textPrimary(context),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '可以试试切换筛选，或者搜索不同关键词。',
            style: TextStyle(color: AppThemePalette.textSecondary(context)),
          ),
        ],
      ),
    );
  }

  bool _matchesKeyword(ConversationSummary summary) {
    if (_keyword.isEmpty) {
      return true;
    }

    final String preview = summary.latestPreview.toLowerCase();
    return summary.name.toLowerCase().contains(_keyword) ||
        summary.department.toLowerCase().contains(_keyword) ||
        preview.contains(_keyword);
  }

  bool _matchesFilter(ConversationSummary summary) {
    switch (_filter) {
      case _MessageFilter.all:
        return true;
      case _MessageFilter.unread:
        return summary.hasUnread;
      case _MessageFilter.online:
        return summary.isOnline;
    }
  }

  void _openChat(BuildContext context, ConversationSummary summary) {
    context.pushNamed(
      AppRoutes.chatDetail,
      pathParameters: {'userId': summary.userId},
    );
  }
}

class _OnlineCollaboratorCard extends StatelessWidget {
  const _OnlineCollaboratorCard({required this.summary, required this.onTap});

  final ConversationSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color surfaceColor = AppThemePalette.surface(context);
    final Color borderColor = AppThemePalette.border(context);
    final Color subtitleColor = AppThemePalette.textSecondary(context);
    final Color hintColor = AppThemePalette.textHint(context);
    final Color avatarBackground = AppThemePalette.isDark(context)
        ? const Color(0xFF22314A)
        : const Color(0xFFEAF1FF);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: 196,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: summary.hasUnread
                  ? <Color>[AppThemePalette.subtleSurface(context), surfaceColor]
                  : <Color>[surfaceColor, AppThemePalette.mutedSurface(context)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: summary.hasUnread
                  ? AppColors.brandBlue.withAlpha(34)
                  : borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: AppThemePalette.shadow(context),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: avatarBackground,
                    child: Text(
                      summary.avatar,
                      style: const TextStyle(
                        color: AppColors.brandBlue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: surfaceColor, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppThemePalette.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary.department,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary.hasUnread ? '有新的消息待查看' : '适合发起即时沟通',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: summary.hasUnread
                            ? AppColors.brandBlue
                            : hintColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (summary.hasUnread)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${summary.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withAlpha(16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '在线',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({required this.summary, required this.onTap});

  final ConversationSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = summary.hasUnread;
    final Color surfaceColor = AppThemePalette.surface(context);
    final Color borderColor = AppThemePalette.border(context);
    final Color subtitleColor = AppThemePalette.textSecondary(context);
    final Color hintColor = AppThemePalette.textHint(context);
    final Color titleColor = AppThemePalette.textPrimary(context);
    final Color avatarBackground = AppThemePalette.isDark(context)
        ? const Color(0xFF22314A)
        : const Color(0xFFEAF1FF);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: hasUnread ? AppThemePalette.subtleSurface(context) : surfaceColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: hasUnread
                  ? AppColors.brandBlue.withAlpha(55)
                  : borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: AppThemePalette.shadow(context),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 58,
                decoration: BoxDecoration(
                  color: hasUnread
                      ? AppColors.brandBlue
                      : borderColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 12),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: avatarBackground,
                    child: Text(
                      summary.avatar,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandBlue,
                      ),
                    ),
                  ),
                  if (summary.isOnline)
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: surfaceColor, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            summary.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: titleColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _formatMessageTime(summary.latestMessageTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: hintColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: summary.isOnline
                                ? AppColors.success.withAlpha(16)
                                : AppThemePalette.mutedSurface(context),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            summary.isOnline ? '在线' : summary.department,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: summary.isOnline
                                  ? AppColors.success
                                  : subtitleColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            summary.isOnline ? summary.department : '最近保持同步',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: hintColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      summary.latestPreview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: hasUnread
                            ? titleColor
                            : subtitleColor,
                        fontWeight: hasUnread
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hasUnread)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        summary.unreadCount > 99
                            ? '99+'
                            : '${summary.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.done_all_rounded,
                      size: 18,
                      color: hintColor,
                    ),
                  const SizedBox(height: 16),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: hintColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMessageTime(DateTime? time) {
    if (time == null) {
      return '--:--';
    }

    final DateTime now = DateTime.now();
    if (DateUtils.isSameDay(now, time)) {
      return DateFormat('HH:mm').format(time);
    }

    if (DateUtils.isSameDay(now.subtract(const Duration(days: 1)), time)) {
      return '昨天';
    }

    return DateFormat('MM/dd').format(time);
  }
}

enum _MessageFilter { all, unread, online }
