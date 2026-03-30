import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/shared/widgets/app_hero_card.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/approval/presentation/providers/approval_provider.dart';
import 'package:my_first_app/features/attendance/presentation/providers/attendance_provider.dart';
import 'package:my_first_app/features/auth/presentation/providers/user_provider.dart';
import 'package:my_first_app/features/chat/presentation/providers/chat_provider.dart';

class WorkplaceScreen extends StatelessWidget {
  const WorkplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendanceProvider attendance = context.watch<AttendanceProvider>();
    final ApprovalProvider approval = context.watch<ApprovalProvider>();
    final ChatProvider chat = context.watch<ChatProvider>();
    final String userName =
        context.watch<UserProvider>().currentUser?.name ?? '同事';
    final int onlineCount = chat.users.where((user) => user.isOnline).length;
    final DateTime now = DateTime.now();

    final List<_WorkMetric> metrics = <_WorkMetric>[
      _WorkMetric(
        label: '今日状态',
        value: attendance.status,
        hint: attendance.hasCheckedIn ? '状态已同步' : '待完成打卡',
        icon: Icons.verified_user_outlined,
        tint: AppColors.brandBlue,
      ),
      _WorkMetric(
        label: '打卡时间',
        value: _formatCheckInTime(attendance.time),
        hint: attendance.hasCheckedIn ? '已记录' : '尚未打卡',
        icon: Icons.schedule_rounded,
        tint: AppColors.warning,
      ),
      _WorkMetric(
        label: '待审批',
        value: '${approval.pendingCount}',
        hint: '需要跟进的流程',
        icon: Icons.approval_outlined,
        tint: AppColors.info,
      ),
      _WorkMetric(
        label: '未读消息',
        value: '${chat.totalMessageCount}',
        hint: '$onlineCount 位同事在线 · 优先处理未读消息',
        icon: Icons.mark_chat_unread_outlined,
        tint: AppColors.success,
      ),
    ];

    final List<_DashboardAction> actions = <_DashboardAction>[
      const _DashboardAction(
        id: 'attendance',
        title: '考勤打卡',
        subtitle: '快速记录今日到岗状态',
        icon: Icons.fingerprint_rounded,
        gradient: LinearGradient(
          colors: [Color(0xFF174AE3), Color(0xFF4E8DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      const _DashboardAction(
        id: 'approval',
        title: '审批中心',
        subtitle: '查看并处理待办申请',
        icon: Icons.fact_check_outlined,
        gradient: LinearGradient(
          colors: [Color(0xFF0E9384), Color(0xFF33C3B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      const _DashboardAction(
        id: 'log',
        title: '工作日志',
        subtitle: '沉淀进展，方便团队同步',
        icon: Icons.auto_stories_outlined,
        gradient: LinearGradient(
          colors: [Color(0xFFF28F16), Color(0xFFFFB74A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      const _DashboardAction(
        id: 'notice',
        title: '企业公告',
        subtitle: '查看团队通知与制度更新',
        icon: Icons.campaign_outlined,
        gradient: LinearGradient(
          colors: [Color(0xFF7A4CF5), Color(0xFFA47BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              sliver: SliverList.list(
                children: [
                  _buildHeroCard(
                    userName: userName,
                    dateLabel: DateFormat('MM月dd日').format(now),
                    greeting: _buildGreeting(now),
                    attendance: attendance,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle(
                    title: '今日概览',
                    subtitle: '把核心状态集中放在一个地方查看',
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: metrics.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.45,
                    ),
                    itemBuilder: (context, index) {
                      return _MetricCard(metric: metrics[index]);
                    },
                  ),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    title: '高频入口',
                    subtitle: '保留最常用的工作动作，减少跳转负担',
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: actions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      return _ActionCard(
                        action: actions[index],
                        onTap: () => _handleActionTap(
                          context,
                          actions[index].id,
                          attendance,
                        ),
                      );
                    },
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
  }) {
    return AppHeroCard(
      title: userName,
      subtitle: '$dateLabel · 今天也把重点工作推进一点',
      badgeText: greeting,
      trailing: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(34),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(45)),
        ),
        alignment: Alignment.center,
        child: Text(
          userName.characters.first.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(26),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withAlpha(32)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                attendance.hasCheckedIn
                    ? Icons.verified_rounded
                    : Icons.access_time_filled_rounded,
                color:
                    attendance.hasCheckedIn ? AppColors.success : AppColors.warning,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attendance.hasCheckedIn ? '今日已完成打卡' : '等待打卡确认',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    attendance.hasCheckedIn
                        ? '记录时间：${attendance.time}'
                        : '建议在开始工作后尽快完成打卡',
                    style: TextStyle(
                      color: Colors.white.withAlpha(210),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _buildGreeting(DateTime now) {
    final int hour = now.hour;
    if (hour < 12) {
      return '早上好';
    }
    if (hour < 18) {
      return '下午好';
    }
    return '晚上好';
  }

  String _formatCheckInTime(String value) {
    if (value == '未打卡') {
      return '--:--';
    }

    final List<String> parts = value.split(' ');
    return parts.length > 1 ? parts[1] : value;
  }

  void _handleActionTap(
    BuildContext context,
    String actionId,
    AttendanceProvider attendance,
  ) {
    switch (actionId) {
      case 'attendance':
        if (attendance.hasCheckedIn) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('今天已经完成打卡了')));
          return;
        }
        context.read<AttendanceProvider>().checkIn().then((_) {
          if (!context.mounted) {
            return;
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('打卡成功，状态已更新')));
        });
        return;
      case 'approval':
        context.pushNamed(AppRoutes.approval);
        return;
      case 'log':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('工作日志模块正在整理中')),
        );
        return;
      case 'notice':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('企业公告模块稍后补充')),
        );
        return;
    }
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: metric.tint.withAlpha(18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(metric.icon, color: metric.tint),
          ),
          const Spacer(),
          Text(
            metric.label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.hint,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: BoxDecoration(
            gradient: action.gradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(action.icon, color: Colors.white),
                ),
                const Spacer(),
                Text(
                  action.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  action.subtitle,
                  style: TextStyle(
                    color: Colors.white.withAlpha(220),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      '立即进入',
                      style: TextStyle(
                        color: Colors.white.withAlpha(230),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
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
