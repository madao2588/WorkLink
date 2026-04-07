import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/shared/widgets/app_dashboard_hero.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/approval/domain/models/approval_model.dart';
import 'package:my_first_app/features/approval/presentation/providers/approval_provider.dart';
import 'package:my_first_app/features/attendance/presentation/providers/attendance_provider.dart';
import 'package:my_first_app/features/auth/presentation/providers/user_provider.dart';
import 'package:my_first_app/features/chat/domain/models/conversation_summary.dart';
import 'package:my_first_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class WorkplaceScreen extends StatelessWidget {
  const WorkplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AttendanceProvider attendance = context.watch<AttendanceProvider>();
    final ApprovalProvider approval = context.watch<ApprovalProvider>();
    final ChatProvider chat = context.watch<ChatProvider>();
    final String userName =
        context.watch<UserProvider>().currentUser?.name ??
        l10n.workplaceFallbackUserName;
    final int onlineCount = chat.users.where((user) => user.isOnline).length;
    final DateTime now = DateTime.now();
    final String localeName = Localizations.localeOf(context).toString();

    final List<_WorkMetric> metrics = <_WorkMetric>[
      _WorkMetric(
        label: l10n.workplaceMetricStatusLabel,
        value: _buildAttendanceValue(attendance, l10n),
        hint: attendance.hasCheckedIn
            ? l10n.workplaceMetricStatusHintCheckedIn
            : l10n.workplaceMetricStatusHintPending,
        icon: Icons.verified_user_outlined,
        tint: AppColors.brandBlue,
      ),
      _WorkMetric(
        label: l10n.workplaceMetricCheckInLabel,
        value: _formatCheckInTime(attendance.time, l10n),
        hint: attendance.hasCheckedIn
            ? l10n.workplaceMetricCheckInHintRecorded
            : l10n.workplaceMetricCheckInHintNotYet,
        icon: Icons.schedule_rounded,
        tint: AppColors.warning,
      ),
      _WorkMetric(
        label: l10n.workplaceMetricPendingApprovalsLabel,
        value: '${approval.pendingCount}',
        hint: l10n.workplaceMetricPendingApprovalsHint,
        icon: Icons.approval_outlined,
        tint: AppColors.info,
      ),
      _WorkMetric(
        label: l10n.workplaceMetricUnreadMessagesLabel,
        value: '${chat.totalMessageCount}',
        hint: l10n.workplaceMetricUnreadMessagesHint(onlineCount),
        icon: Icons.mark_chat_unread_outlined,
        tint: AppColors.success,
      ),
    ];

    final List<_PriorityItem> priorities = <_PriorityItem>[
      _PriorityItem(
        id: 'attendance',
        title: l10n.workplacePriorityAttendanceTitle,
        priorityLabel: attendance.hasCheckedIn
            ? l10n.workplacePriorityLevelSteady
            : l10n.workplacePriorityLevelCritical,
        summary: attendance.hasCheckedIn
            ? l10n.workplacePriorityAttendanceDoneSummary
            : l10n.workplacePriorityAttendancePendingSummary,
        detail: attendance.hasCheckedIn
            ? l10n.workplacePriorityAttendanceDoneDetail(
                _formatCheckInTime(attendance.time, l10n),
              )
            : l10n.workplacePriorityAttendancePendingDetail,
        icon: Icons.fingerprint_rounded,
        accent: attendance.hasCheckedIn ? AppColors.success : AppColors.warning,
      ),
      _PriorityItem(
        id: 'approval',
        title: l10n.workplacePriorityApprovalsTitle,
        priorityLabel: approval.pendingCount == 0
            ? l10n.workplacePriorityLevelSteady
            : l10n.workplacePriorityLevelHigh,
        summary: approval.pendingCount == 0
            ? l10n.workplacePriorityApprovalsNoneSummary
            : l10n.workplacePriorityApprovalsPendingSummary(
                approval.pendingCount,
              ),
        detail: approval.pendingCount == 0
            ? l10n.workplacePriorityApprovalsNoneDetail
            : l10n.workplacePriorityApprovalsPendingDetail(
                approval.approvedCount,
                approval.rejectedCount,
              ),
        icon: Icons.fact_check_outlined,
        accent: AppColors.info,
      ),
      _PriorityItem(
        id: 'messages',
        title: l10n.workplacePriorityMessagesTitle,
        priorityLabel: chat.unreadConversationCount == 0
            ? l10n.workplacePriorityLevelSteady
            : l10n.workplacePriorityLevelHigh,
        summary: chat.unreadConversationCount == 0
            ? l10n.workplacePriorityMessagesClearSummary
            : l10n.workplacePriorityMessagesUnreadSummary(
                chat.unreadConversationCount,
              ),
        detail: chat.unreadConversationCount == 0
            ? l10n.workplacePriorityMessagesClearDetail(onlineCount)
            : l10n.workplacePriorityMessagesUnreadDetail(onlineCount),
        icon: Icons.mark_email_unread_outlined,
        accent: AppColors.success,
      ),
    ];

    final List<_DashboardAction> actions = <_DashboardAction>[
      _DashboardAction(
        id: 'attendance',
        title: l10n.workplaceActionAttendanceTitle,
        subtitle: l10n.workplaceActionAttendanceSubtitle,
        icon: Icons.fingerprint_rounded,
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF174AE3), Color(0xFF4E8DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _DashboardAction(
        id: 'approval',
        title: l10n.workplaceActionApprovalTitle,
        subtitle: l10n.workplaceActionApprovalSubtitle,
        icon: Icons.fact_check_outlined,
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF0E9384), Color(0xFF33C3B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _DashboardAction(
        id: 'log',
        title: l10n.workplaceActionLogTitle,
        subtitle: l10n.workplaceActionLogSubtitle,
        icon: Icons.auto_stories_outlined,
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFF28F16), Color(0xFFFFB74A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _DashboardAction(
        id: 'notice',
        title: l10n.workplaceActionNoticeTitle,
        subtitle: l10n.workplaceActionNoticeSubtitle,
        icon: Icons.campaign_outlined,
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF7A4CF5), Color(0xFFA47BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    final List<_PulseItem> pulseItems = <_PulseItem>[
      _buildPulseItem(
        label: l10n.workplacePulseAttendanceLabel,
        isLoading: attendance.isLoading,
        errorMessage: attendance.errorMessage,
        l10n: l10n,
      ),
      _buildPulseItem(
        label: l10n.workplacePulseApprovalsLabel,
        isLoading: approval.isLoading,
        errorMessage: approval.errorMessage,
        l10n: l10n,
      ),
      _buildPulseItem(
        label: l10n.workplacePulseMessagesLabel,
        isLoading: chat.isLoading,
        errorMessage: chat.errorMessage,
        l10n: l10n,
      ),
    ];

    final List<_AnnouncementItem> announcements = _buildAnnouncements(
      now,
      localeName,
      l10n,
    );
    final _PriorityItem recommendedItem = _buildRecommendedItem(
      priorities,
      attendance,
      approval,
      chat,
    );
    final List<_TimelineItem> timelineItems = _buildTimelineItems(
      attendance: attendance,
      approval: approval,
      chat: chat,
      now: now,
      localeName: localeName,
      l10n: l10n,
    );
    final List<_QueueRowData> queueRows = <_QueueRowData>[
      _QueueRowData(
        id: 'attendance',
        title: l10n.workplacePriorityAttendanceTitle,
        count: attendance.hasCheckedIn ? 0 : 1,
        detail: attendance.hasCheckedIn
            ? l10n.workplacePriorityAttendanceDoneDetail(
                _formatCheckInTime(attendance.time, l10n),
              )
            : l10n.workplacePriorityAttendancePendingDetail,
        accent: attendance.hasCheckedIn ? AppColors.success : AppColors.warning,
      ),
      _QueueRowData(
        id: 'approval',
        title: l10n.workplacePriorityApprovalsTitle,
        count: approval.pendingCount,
        detail: approval.pendingCount == 0
            ? l10n.workplacePriorityApprovalsNoneDetail
            : l10n.workplacePriorityApprovalsPendingDetail(
                approval.approvedCount,
                approval.rejectedCount,
              ),
        accent: approval.pendingCount == 0 ? AppColors.success : AppColors.info,
      ),
      _QueueRowData(
        id: 'messages',
        title: l10n.workplacePriorityMessagesTitle,
        count: chat.unreadConversationCount,
        detail: chat.unreadConversationCount == 0
            ? l10n.workplacePriorityMessagesClearDetail(onlineCount)
            : l10n.workplacePriorityMessagesUnreadDetail(onlineCount),
        accent: chat.unreadConversationCount == 0
            ? AppColors.success
            : AppColors.brandBlue,
      ),
    ];

    return Scaffold(
      backgroundColor: AppThemePalette.pageBackground(context),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              sliver: SliverList.list(
                children: <Widget>[
                  _buildHeroCard(
                    userName: userName,
                    dateLabel: DateFormat.MMMd(localeName).format(now),
                    greeting: _buildGreeting(now, l10n),
                    attendance: attendance,
                    approval: approval,
                    chat: chat,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    context,
                    title: l10n.workplaceSectionCommandTitle,
                    subtitle: l10n.workplaceSectionCommandSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _CommandDeck(
                    recommendedItem: recommendedItem,
                    queueRows: queueRows,
                    onTap: (String actionId) =>
                        _handleActionTap(context, actionId, attendance, l10n),
                  ),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    context,
                    title: l10n.workplaceSectionFocusTitle,
                    subtitle: l10n.workplaceSectionFocusSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _PriorityBoard(
                    items: priorities,
                    onTap: (String actionId) =>
                        _handleActionTap(context, actionId, attendance, l10n),
                  ),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    context,
                    title: l10n.workplaceSectionOverviewTitle,
                    subtitle: l10n.workplaceSectionOverviewSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _MetricsBoard(metrics: metrics),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    context,
                    title: l10n.workplaceSectionActionsTitle,
                    subtitle: l10n.workplaceSectionActionsSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _ActionsBoard(
                    actions: actions,
                    onTap: (String actionId) =>
                        _handleActionTap(context, actionId, attendance, l10n),
                  ),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    context,
                    title: l10n.workplaceSectionPulseTitle,
                    subtitle: l10n.workplaceSectionPulseSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _PulseCard(items: pulseItems),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    context,
                    title: l10n.workplaceSectionUpdatesTitle,
                    subtitle: l10n.workplaceSectionUpdatesSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _InfoColumnsBoard(
                    leftChild: _AnnouncementPanel(
                      items: announcements,
                      onTap: (String actionId) =>
                          _handleActionTap(context, actionId, attendance, l10n),
                    ),
                    rightChild: _TimelinePanel(items: timelineItems),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard({
    required String userName,
    required String dateLabel,
    required String greeting,
    required AttendanceProvider attendance,
    required ApprovalProvider approval,
    required ChatProvider chat,
    required AppLocalizations l10n,
  }) {
    return AppDashboardHero(
      title: userName,
      subtitle: l10n.workplaceHeroSubtitle(dateLabel),
      badgeText: greeting,
      icon: Icons.dashboard_customize_rounded,
      stats: <AppDashboardHeroStat>[
        AppDashboardHeroStat(
          label: l10n.workplaceMetricStatusLabel,
          value: _buildAttendanceValue(attendance, l10n),
        ),
        AppDashboardHeroStat(
          label: l10n.workplaceMetricPendingApprovalsLabel,
          value: '${approval.pendingCount}',
        ),
        AppDashboardHeroStat(
          label: l10n.workplaceMetricUnreadMessagesLabel,
          value: '${chat.totalMessageCount}',
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppThemePalette.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppThemePalette.textSecondary(context),
          ),
        ),
      ],
    );
  }

  String _buildGreeting(DateTime now, AppLocalizations l10n) {
    final int hour = now.hour;
    if (hour < 12) {
      return l10n.workplaceGreetingMorning;
    }
    if (hour < 18) {
      return l10n.workplaceGreetingAfternoon;
    }
    return l10n.workplaceGreetingEvening;
  }

  String _buildAttendanceValue(
    AttendanceProvider attendance,
    AppLocalizations l10n,
  ) {
    switch (attendance.status) {
      case '迟到':
        return l10n.workplaceHeroStatLate;
      case '缺卡':
        return l10n.workplaceHeroStatMissing;
      case '已打卡':
        return l10n.workplaceHeroStatCheckedIn;
      default:
        return l10n.workplaceHeroStatPendingCheckIn;
    }
  }

  String _formatCheckInTime(String value, AppLocalizations l10n) {
    if (value == l10n.workplaceNotCheckedInValue || value == '未打卡') {
      return '--:--';
    }

    final List<String> parts = value.split(' ');
    return parts.length > 1 ? parts[1] : value;
  }

  _PulseItem _buildPulseItem({
    required String label,
    required bool isLoading,
    required String? errorMessage,
    required AppLocalizations l10n,
  }) {
    if (errorMessage != null && errorMessage.isNotEmpty) {
      return _PulseItem(
        label: label,
        state: l10n.workplacePulseStateError,
        detail: errorMessage,
        color: AppColors.danger,
      );
    }
    if (isLoading) {
      return _PulseItem(
        label: label,
        state: l10n.workplacePulseStateLoading,
        detail: l10n.workplacePulseDetailLoading,
        color: AppColors.warning,
      );
    }
    return _PulseItem(
      label: label,
      state: l10n.workplacePulseStateHealthy,
      detail: l10n.workplacePulseDetailHealthy,
      color: AppColors.success,
    );
  }

  List<_AnnouncementItem> _buildAnnouncements(
    DateTime now,
    String localeName,
    AppLocalizations l10n,
  ) {
    return <_AnnouncementItem>[
      _AnnouncementItem(
        id: 'approval',
        tag: l10n.workplaceAnnouncementTagPolicy,
        title: l10n.workplaceAnnouncementApprovalPolicyTitle,
        detail: l10n.workplaceAnnouncementApprovalPolicyDetail,
        dateLabel: DateFormat.MMMd(localeName).format(now),
        color: AppColors.info,
      ),
      _AnnouncementItem(
        id: 'attendance',
        tag: l10n.workplaceAnnouncementTagReminder,
        title: l10n.workplaceAnnouncementAttendanceTitle,
        detail: l10n.workplaceAnnouncementAttendanceDetail,
        dateLabel: DateFormat.MMMd(
          localeName,
        ).format(now.subtract(const Duration(days: 1))),
        color: AppColors.warning,
      ),
      _AnnouncementItem(
        id: 'messages',
        tag: l10n.workplaceAnnouncementTagCollaboration,
        title: l10n.workplaceAnnouncementCollaborationTitle,
        detail: l10n.workplaceAnnouncementCollaborationDetail,
        dateLabel: DateFormat.MMMd(
          localeName,
        ).format(now.subtract(const Duration(days: 2))),
        color: AppColors.success,
      ),
    ];
  }

  List<_TimelineItem> _buildTimelineItems({
    required AttendanceProvider attendance,
    required ApprovalProvider approval,
    required ChatProvider chat,
    required DateTime now,
    required String localeName,
    required AppLocalizations l10n,
  }) {
    final List<_TimelineItem> items = <_TimelineItem>[];
    final DateTime? checkInTime = _parseCheckInTime(attendance.time);

    if (checkInTime != null) {
      items.add(
        _TimelineItem(
          title: l10n.workplaceTimelineAttendanceDoneTitle,
          detail: l10n.workplaceTimelineAttendanceDoneDetail(
            DateFormat.Hm(localeName).format(checkInTime),
          ),
          label: l10n.workplaceTimelineTagAttendance,
          time: checkInTime,
          color: AppColors.warning,
          icon: Icons.fingerprint_rounded,
        ),
      );
    } else {
      items.add(
        _TimelineItem(
          title: l10n.workplaceTimelineAttendancePendingTitle,
          detail: l10n.workplaceTimelineAttendancePendingDetail,
          label: l10n.workplaceTimelineTagAttention,
          time: DateTime(now.year, now.month, now.day, 9),
          color: AppColors.danger,
          icon: Icons.notification_important_outlined,
        ),
      );
    }

    final List<ApprovalModel> approvals =
        List<ApprovalModel>.from(approval.approvals)..sort(
          (ApprovalModel left, ApprovalModel right) =>
              right.startTime.compareTo(left.startTime),
        );
    for (final ApprovalModel approvalItem in approvals.take(2)) {
      items.add(
        _TimelineItem(
          title: l10n.workplaceTimelineApprovalTitle(approvalItem.applicant),
          detail: _buildApprovalTimelineDetail(approvalItem, l10n),
          label: _buildApprovalTimelineLabel(approvalItem.status, l10n),
          time: approvalItem.startTime,
          color: _buildApprovalTimelineColor(approvalItem.status),
          icon: Icons.approval_outlined,
        ),
      );
    }

    final List<ConversationSummary> summaries =
        List<ConversationSummary>.from(
          chat.conversationSummaries.where(
            (ConversationSummary summary) => summary.latestMessageTime != null,
          ),
        )..sort(
          (ConversationSummary left, ConversationSummary right) =>
              right.latestMessageTime!.compareTo(left.latestMessageTime!),
        );
    for (final ConversationSummary summary in summaries.take(2)) {
      items.add(
        _TimelineItem(
          title: l10n.workplaceTimelineMessageTitle(summary.name),
          detail: summary.unreadCount > 0
              ? l10n.workplaceTimelineMessageUnreadDetail(
                  summary.latestPreview,
                  summary.unreadCount,
                )
              : l10n.workplaceTimelineMessageReadDetail(summary.latestPreview),
          label: summary.unreadCount > 0
              ? l10n.workplaceTimelineTagUnread
              : l10n.workplaceTimelineTagUpdated,
          time: summary.latestMessageTime!,
          color: summary.unreadCount > 0
              ? AppColors.success
              : AppColors.brandBlue,
          icon: Icons.chat_bubble_outline_rounded,
        ),
      );
    }

    items.sort(
      (_TimelineItem left, _TimelineItem right) =>
          right.time.compareTo(left.time),
    );
    return items.take(5).toList();
  }

  _PriorityItem _buildRecommendedItem(
    List<_PriorityItem> priorities,
    AttendanceProvider attendance,
    ApprovalProvider approval,
    ChatProvider chat,
  ) {
    if (!attendance.hasCheckedIn) {
      return priorities.firstWhere((item) => item.id == 'attendance');
    }
    if (approval.pendingCount > 0) {
      return priorities.firstWhere((item) => item.id == 'approval');
    }
    if (chat.unreadConversationCount > 0) {
      return priorities.firstWhere((item) => item.id == 'messages');
    }
    return priorities.firstWhere((item) => item.id == 'messages');
  }

  DateTime? _parseCheckInTime(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty || !trimmed.contains('-') || !trimmed.contains(':')) {
      return null;
    }
    try {
      return DateTime.parse(trimmed.replaceFirst(' ', 'T'));
    } catch (_) {
      return null;
    }
  }

  String _buildApprovalTimelineDetail(
    ApprovalModel approval,
    AppLocalizations l10n,
  ) {
    switch (approval.status) {
      case ApprovalStatus.pending:
        return l10n.workplaceTimelineApprovalPendingDetail(approval.title);
      case ApprovalStatus.approved:
        return l10n.workplaceTimelineApprovalApprovedDetail(approval.title);
      case ApprovalStatus.rejected:
        return l10n.workplaceTimelineApprovalRejectedDetail(approval.title);
    }
  }

  String _buildApprovalTimelineLabel(
    ApprovalStatus status,
    AppLocalizations l10n,
  ) {
    switch (status) {
      case ApprovalStatus.pending:
        return l10n.workplaceTimelineTagPending;
      case ApprovalStatus.approved:
        return l10n.workplaceTimelineTagApproved;
      case ApprovalStatus.rejected:
        return l10n.workplaceTimelineTagRejected;
    }
  }

  Color _buildApprovalTimelineColor(ApprovalStatus status) {
    switch (status) {
      case ApprovalStatus.pending:
        return AppColors.info;
      case ApprovalStatus.approved:
        return AppColors.success;
      case ApprovalStatus.rejected:
        return AppColors.danger;
    }
  }

  void _handleActionTap(
    BuildContext context,
    String actionId,
    AttendanceProvider attendance,
    AppLocalizations l10n,
  ) {
    switch (actionId) {
      case 'attendance':
        if (attendance.hasCheckedIn) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.workplaceSnackBarAlreadyCheckedIn)),
          );
          return;
        }
        context.read<AttendanceProvider>().checkIn().then((_) {
          if (!context.mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.workplaceSnackBarCheckInSuccess)),
          );
        });
        return;
      case 'approval':
        context.pushNamed(AppRoutes.approval);
        return;
      case 'messages':
        context.goNamed(AppRoutes.messages);
        return;
      case 'log':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.workplaceSnackBarLogReady)));
        return;
      case 'notice':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.workplaceSnackBarNoticeReady)),
        );
        return;
    }
  }
}

class _InfoColumnsBoard extends StatelessWidget {
  const _InfoColumnsBoard({required this.leftChild, required this.rightChild});

  final Widget leftChild;
  final Widget rightChild;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool singleColumn = constraints.maxWidth < 900;
        final double itemWidth = singleColumn
            ? constraints.maxWidth
            : (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: <Widget>[
            SizedBox(width: itemWidth, child: leftChild),
            SizedBox(width: itemWidth, child: rightChild),
          ],
        );
      },
    );
  }
}

class _CommandDeck extends StatelessWidget {
  const _CommandDeck({
    required this.recommendedItem,
    required this.queueRows,
    required this.onTap,
  });

  final _PriorityItem recommendedItem;
  final List<_QueueRowData> queueRows;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 940) {
          return Column(
            children: <Widget>[
              _RecommendedActionCard(
                item: recommendedItem,
                onTap: () => onTap(recommendedItem.id),
              ),
              const SizedBox(height: 14),
              _QueueSummaryCard(rows: queueRows, onTap: onTap),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 8,
              child: _RecommendedActionCard(
                item: recommendedItem,
                onTap: () => onTap(recommendedItem.id),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 5,
              child: _QueueSummaryCard(rows: queueRows, onTap: onTap),
            ),
          ],
        );
      },
    );
  }
}

class _PriorityBoard extends StatelessWidget {
  const _PriorityBoard({required this.items, required this.onTap});

  final List<_PriorityItem> items;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double itemWidth = constraints.maxWidth < 760
            ? constraints.maxWidth
            : (constraints.maxWidth - 14) / 2;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: <Widget>[
            for (final _PriorityItem item in items)
              SizedBox(
                width: itemWidth,
                child: _PriorityCard(item: item, onTap: () => onTap(item.id)),
              ),
          ],
        );
      },
    );
  }
}

class _MetricsBoard extends StatelessWidget {
  const _MetricsBoard({required this.metrics});

  final List<_WorkMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 520 ? 1 : 2;
        final double itemWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            for (final _WorkMetric metric in metrics)
              SizedBox(
                width: itemWidth,
                child: _MetricCard(metric: metric),
              ),
          ],
        );
      },
    );
  }
}

class _ActionsBoard extends StatelessWidget {
  const _ActionsBoard({required this.actions, required this.onTap});

  final List<_DashboardAction> actions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 560 ? 1 : 2;
        final double itemWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - 14) / 2;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: <Widget>[
            for (final _DashboardAction action in actions)
              SizedBox(
                width: itemWidth,
                child: _ActionCard(
                  action: action,
                  onTap: () => onTap(action.id),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PriorityCard extends StatelessWidget {
  const _PriorityCard({required this.item, required this.onTap});

  final _PriorityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color surfaceColor = AppThemePalette.surface(context);
    final Color borderColor = AppThemePalette.border(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: borderColor),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppThemePalette.shadow(context),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: item.accent.withAlpha(16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(item.icon, color: item.accent),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: item.accent.withAlpha(16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.priorityLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: item.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_outward_rounded,
                    color: item.accent,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppThemePalette.textPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.summary,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppThemePalette.textPrimary(context),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.detail,
                style: TextStyle(
                  fontSize: 13,
                  color: AppThemePalette.textSecondary(context),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Text(
                    l10n.workplaceActionEnterNow,
                    style: TextStyle(
                      color: item.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendedActionCard extends StatelessWidget {
  const _RecommendedActionCard({required this.item, required this.onTap});

  final _PriorityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool darkMode = AppThemePalette.isDark(context);
    final Color overlaySurface = darkMode
        ? const Color(0xFF10233F).withAlpha(180)
        : Colors.white.withAlpha(28);
    final Color overlaySurfaceSoft = darkMode
        ? const Color(0xFF0E1E36).withAlpha(160)
        : Colors.white.withAlpha(20);
    final Color primaryTextColor = darkMode
        ? const Color(0xFFF4F7FC)
        : Colors.white;
    final Color secondaryTextColor = darkMode
        ? const Color(0xFFD2DCF0)
        : Colors.white.withAlpha(215);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                item.accent.withAlpha(230),
                darkMode ? const Color(0xFF18345F) : AppColors.textPrimary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: item.accent.withAlpha(45),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: overlaySurface,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.workplaceCommandRecommendedLabel,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: overlaySurfaceSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.priorityLabel,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Icon(item.icon, color: primaryTextColor, size: 30),
              const SizedBox(height: 18),
              Text(
                item.title,
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.summary,
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.detail,
                style: TextStyle(
                  color: secondaryTextColor,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: <Widget>[
                  Text(
                    l10n.workplaceActionEnterNow,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: primaryTextColor,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QueueSummaryCard extends StatelessWidget {
  const _QueueSummaryCard({required this.rows, required this.onTap});

  final List<_QueueRowData> rows;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppThemePalette.border(context)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.workplaceCommandQueueLabel,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppThemePalette.textPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.workplaceCommandQueueSubtitle,
            style: TextStyle(
              color: AppThemePalette.textSecondary(context),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          for (int index = 0; index < rows.length; index++) ...<Widget>[
            _QueueSummaryRow(
              row: rows[index],
              onTap: () => onTap(rows[index].id),
            ),
            if (index != rows.length - 1)
              Divider(color: AppThemePalette.border(context), height: 22),
          ],
        ],
      ),
    );
  }
}

class _QueueSummaryRow extends StatelessWidget {
  const _QueueSummaryRow({required this.row, required this.onTap});

  final _QueueRowData row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: row.accent.withAlpha(16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${row.count}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: row.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      row.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppThemePalette.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      row.detail,
                      style: TextStyle(
                        color: AppThemePalette.textSecondary(context),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: row.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulseCard extends StatelessWidget {
  const _PulseCard({required this.items});

  final List<_PulseItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppThemePalette.border(context)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          for (int index = 0; index < items.length; index++) ...<Widget>[
            _PulseRow(item: items[index]),
            if (index != items.length - 1)
              Divider(color: AppThemePalette.border(context), height: 24),
          ],
        ],
      ),
    );
  }
}

class _AnnouncementPanel extends StatelessWidget {
  const _AnnouncementPanel({required this.items, required this.onTap});

  final List<_AnnouncementItem> items;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppThemePalette.border(context)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.workplaceSectionAnnouncementsTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppThemePalette.textPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.workplaceSectionAnnouncementsSubtitle,
            style: TextStyle(
              color: AppThemePalette.textSecondary(context),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          for (int index = 0; index < items.length; index++) ...<Widget>[
            _AnnouncementRow(
              item: items[index],
              onTap: () => onTap(items[index].id),
            ),
            if (index != items.length - 1)
              Divider(color: AppThemePalette.border(context), height: 24),
          ],
        ],
      ),
    );
  }
}

class _AnnouncementRow extends StatelessWidget {
  const _AnnouncementRow({required this.item, required this.onTap});

  final _AnnouncementItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.color.withAlpha(18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.campaign_outlined, color: item.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item.color.withAlpha(16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            item.tag,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: item.color,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.dateLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppThemePalette.textHint(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppThemePalette.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.detail,
                      style: TextStyle(
                        color: AppThemePalette.textSecondary(context),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.workplaceAnnouncementAction,
                      style: TextStyle(
                        color: item.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelinePanel extends StatelessWidget {
  const _TimelinePanel({required this.items});

  final List<_TimelineItem> items;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppThemePalette.border(context)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.workplaceSectionAnnouncementsTimelineTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppThemePalette.textPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.workplaceSectionAnnouncementsTimelineSubtitle,
            style: TextStyle(
              color: AppThemePalette.textSecondary(context),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          if (items.isEmpty)
            _TimelineEmptyState(message: l10n.workplaceTimelineEmptyState)
          else
            for (int index = 0; index < items.length; index++) ...<Widget>[
              _TimelineRow(
                item: items[index],
                showConnector: index != items.length - 1,
              ),
              if (index != items.length - 1) const SizedBox(height: 14),
            ],
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item, required this.showConnector});

  final _TimelineItem item;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String localeName = Localizations.localeOf(context).toString();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.color.withAlpha(18),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.color, size: 18),
            ),
            if (showConnector)
              Container(
                width: 2,
                height: 48,
                margin: const EdgeInsets.symmetric(vertical: 6),
                color: AppThemePalette.border(context),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppThemePalette.textPrimary(context),
                        ),
                      ),
                    ),
                    Text(
                      _formatTimelineTime(item.time, localeName, l10n),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppThemePalette.textHint(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.detail,
                  style: TextStyle(
                    color: AppThemePalette.textSecondary(context),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: item.color.withAlpha(16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: item.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimelineTime(
    DateTime value,
    String localeName,
    AppLocalizations l10n,
  ) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime itemDay = DateTime(value.year, value.month, value.day);
    if (itemDay == today) {
      return l10n.workplaceTimelineTimeToday(
        DateFormat.Hm(localeName).format(value),
      );
    }
    return DateFormat.MMMd(localeName).format(value);
  }
}

class _TimelineEmptyState extends StatelessWidget {
  const _TimelineEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.mutedSurface(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: AppThemePalette.textSecondary(context),
          height: 1.5,
        ),
      ),
    );
  }
}

class _PulseRow extends StatelessWidget {
  const _PulseRow({required this.item});

  final _PulseItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppThemePalette.textPrimary(context),
                      ),
                    ),
                  ),
                  Text(
                    item.state,
                    style: TextStyle(
                      color: item.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.detail,
                style: TextStyle(
                  color: AppThemePalette.textSecondary(context),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _WorkMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemePalette.border(context)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: metric.tint.withAlpha(18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(metric.icon, color: metric.tint),
          ),
          const SizedBox(height: 28),
          Text(
            metric.label,
            style: TextStyle(
              fontSize: 13,
              color: AppThemePalette.textSecondary(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.value,
            style: TextStyle(
              fontSize: 20,
              color: AppThemePalette.textPrimary(context),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.hint,
            style: TextStyle(
              fontSize: 12,
              color: AppThemePalette.textHint(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action, required this.onTap});

  final _DashboardAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool darkMode = AppThemePalette.isDark(context);
    final Color overlaySurface = darkMode
        ? const Color(0xFF10233F).withAlpha(176)
        : Colors.white.withAlpha(30);
    final Color primaryTextColor = darkMode
        ? const Color(0xFFF4F7FC)
        : Colors.white;
    final Color secondaryTextColor = darkMode
        ? const Color(0xFFD2DCF0)
        : Colors.white.withAlpha(220);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 224),
          child: Ink(
            decoration: BoxDecoration(
              gradient: action.gradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFF11254D).withAlpha(24),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: overlaySurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(action.icon, color: primaryTextColor),
                  ),
                  const SizedBox(height: 42),
                  Text(
                    action.title,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.subtitle,
                    style: TextStyle(
                      color: secondaryTextColor,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      Text(
                        l10n.workplaceActionEnterNow,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: primaryTextColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkMetric {
  const _WorkMetric({
    required this.label,
    required this.value,
    required this.hint,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final String hint;
  final IconData icon;
  final Color tint;
}

class _PriorityItem {
  const _PriorityItem({
    required this.id,
    required this.title,
    required this.priorityLabel,
    required this.summary,
    required this.detail,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String title;
  final String priorityLabel;
  final String summary;
  final String detail;
  final IconData icon;
  final Color accent;
}

class _DashboardAction {
  const _DashboardAction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
}

class _AnnouncementItem {
  const _AnnouncementItem({
    required this.id,
    required this.tag,
    required this.title,
    required this.detail,
    required this.dateLabel,
    required this.color,
  });

  final String id;
  final String tag;
  final String title;
  final String detail;
  final String dateLabel;
  final Color color;
}

class _TimelineItem {
  const _TimelineItem({
    required this.title,
    required this.detail,
    required this.label,
    required this.time,
    required this.color,
    required this.icon,
  });

  final String title;
  final String detail;
  final String label;
  final DateTime time;
  final Color color;
  final IconData icon;
}

class _QueueRowData {
  const _QueueRowData({
    required this.id,
    required this.title,
    required this.count,
    required this.detail,
    required this.accent,
  });

  final String id;
  final String title;
  final int count;
  final String detail;
  final Color accent;
}

class _PulseItem {
  const _PulseItem({
    required this.label,
    required this.state,
    required this.detail,
    required this.color,
  });

  final String label;
  final String state;
  final String detail;
  final Color color;
}
