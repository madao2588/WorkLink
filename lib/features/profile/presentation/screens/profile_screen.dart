import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/shared/widgets/app_dashboard_hero.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/auth/presentation/providers/user_provider.dart';
import 'package:my_first_app/features/profile/domain/models/profile_overview.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch<UserProvider>();
    final ProfileProvider profile = context.watch<ProfileProvider>();

    if (userProvider.currentUser == null) {
      return const Scaffold(body: Center(child: Text('请重新登录')));
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<ProfileProvider>().loadOverview(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                sliver: SliverList.list(
                  children: [
                    if (profile.overviewLoading && profile.overview == null)
                      const _ProfileLoadingState()
                    else if (profile.overview == null)
                      _ProfileErrorState(
                        message: profile.overviewError ?? '个人数据加载失败',
                        onRetry: () =>
                            context.read<ProfileProvider>().loadOverview(),
                      )
                    else
                      ..._buildContent(context, profile.overview!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, ProfileOverview overview) {
    final List<_ProfileMetric> metrics = <_ProfileMetric>[
      _ProfileMetric(
        label: '出勤状态',
        value: _attendanceLabel(overview.attendanceStatus),
        caption: overview.checkInTime == null
            ? '今日尚未打卡'
            : _timeLabel(overview.checkInTime!),
        accent: overview.hasCheckedIn ? AppColors.success : AppColors.warning,
      ),
      _ProfileMetric(
        label: '待审批',
        value: '${overview.pendingApprovalCount}',
        caption: '待你跟进的流程事项',
        accent: AppColors.info,
      ),
      _ProfileMetric(
        label: '消息记录',
        value: '${overview.totalMessageCount}',
        caption: '未读 ${overview.unreadMessageCount} 条',
        accent: AppColors.brandBlue,
      ),
    ];

    return <Widget>[
      _buildProfileHero(overview),
      const SizedBox(height: 20),
      _buildMetricsGrid(metrics),
      const SizedBox(height: 24),
      _buildSectionTitle(title: '个人工作台', subtitle: '把常用入口整理成更容易查找的分组'),
      const SizedBox(height: 14),
      _buildActionGroup(
        context,
        title: '个人事务',
        actions: const <_ProfileAction>[
          _ProfileAction(
            title: '我的审批',
            subtitle: '查看申请记录与审批流转',
            icon: Icons.fact_check_outlined,
            iconColor: AppColors.brandBlue,
          ),
          _ProfileAction(
            title: '工资条',
            subtitle: '查看薪资相关信息入口',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.warning,
          ),
          _ProfileAction(
            title: '我的勋章',
            subtitle: '沉淀阶段成果与荣誉记录',
            icon: Icons.workspace_premium_outlined,
            iconColor: Color(0xFF8B5CF6),
          ),
        ],
      ),
      const SizedBox(height: 18),
      _buildActionGroup(
        context,
        title: '系统设置',
        actions: const <_ProfileAction>[
          _ProfileAction(
            title: '账号与安全',
            subtitle: '登录设备、隐私和安全设置',
            icon: Icons.shield_outlined,
            iconColor: AppColors.success,
          ),
          _ProfileAction(
            title: '通用设置',
            subtitle: '通知、显示和常用偏好',
            icon: Icons.tune_rounded,
            iconColor: AppColors.textSecondary,
          ),
          _ProfileAction(
            title: '帮助与反馈',
            subtitle: '提交问题或获取使用帮助',
            icon: Icons.support_agent_rounded,
            iconColor: AppColors.info,
          ),
        ],
      ),
      const SizedBox(height: 22),
      _buildLogoutButton(context),
    ];
  }

  Widget _buildProfileHero(ProfileOverview overview) {
    return AppDashboardHero(
      title: overview.user.name,
      subtitle: overview.user.department,
      badgeText: overview.user.isOnline ? '在线办公中' : '已认证账号',
      icon: Icons.account_circle_rounded,
      stats: <AppDashboardHeroStat>[
        AppDashboardHeroStat(
          label: '出勤状态',
          value: _attendanceLabel(overview.attendanceStatus),
        ),
        AppDashboardHeroStat(
          label: '待审批',
          value: '${overview.pendingApprovalCount}',
        ),
        AppDashboardHeroStat(
          label: '未读消息',
          value: '${overview.unreadMessageCount}',
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(List<_ProfileMetric> metrics) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 420;
        if (compact) {
          return Column(
            children: metrics
                .map(
                  (_ProfileMetric metric) => Padding(
                    padding: EdgeInsets.only(
                      bottom: metric == metrics.last ? 0 : 12,
                    ),
                    child: _buildMetricCard(metric),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: metrics
              .map(
                (_ProfileMetric metric) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: metric == metrics.last ? 0 : 12,
                    ),
                    child: _buildMetricCard(metric),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildMetricCard(_ProfileMetric metric) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(7),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: metric.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.caption,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildActionGroup(
    BuildContext context, {
    required String title,
    required List<_ProfileAction> actions,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(7),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ...actions.map(
            (_ProfileAction action) => _ProfileActionTile(
              action: action,
              onTap: () => _handleActionTap(context, action.title),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          side: const BorderSide(color: Color(0xFFF0C4BF)),
          backgroundColor: const Color(0xFFFFF6F5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: const Text(
          '退出登录',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  void _handleActionTap(BuildContext context, String title) {
    switch (title) {
      case '我的审批':
        context.pushNamed(AppRoutes.approval);
        return;
      case '工资条':
        context.pushNamed(AppRoutes.salarySlips);
        return;
      case '我的勋章':
        context.pushNamed(AppRoutes.badges);
        return;
      case '账号与安全':
        context.pushNamed(AppRoutes.accountSecurity);
        return;
      case '通用设置':
        context.pushNamed(AppRoutes.generalSettings);
        return;
      case '帮助与反馈':
        context.pushNamed(AppRoutes.helpFeedback);
        return;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title 功能正在完善中')));
        return;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('退出登录'),
          content: const Text('确定要退出当前账号吗？'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                context.read<UserProvider>().logout();
                Navigator.pop(dialogContext);
              },
              child: const Text(
                '退出',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }

  String _attendanceLabel(String status) {
    switch (status) {
      case 'CHECKED_IN':
      case 'ON_TIME':
        return '已打卡';
      case 'LATE':
        return '迟到';
      case 'NOT_CHECKED_IN':
      default:
        return '待打卡';
    }
  }

  String _timeLabel(DateTime time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '签到时间 $hour:$minute';
  }
}

class _ProfileLoadingState extends StatelessWidget {
  const _ProfileLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        3,
        (int index) => Container(
          margin: EdgeInsets.only(bottom: index == 2 ? 0 : 14),
          height: index == 0 ? 220 : 96,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}

class _ProfileErrorState extends StatelessWidget {
  const _ProfileErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.cloud_off_rounded,
            size: 38,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('重新加载')),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({required this.action, required this.onTap});

  final _ProfileAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: action.iconColor.withAlpha(14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(action.icon, color: action.iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      action.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMetric {
  const _ProfileMetric({
    required this.label,
    required this.value,
    required this.caption,
    required this.accent,
  });

  final String label;
  final String value;
  final String caption;
  final Color accent;
}

class _ProfileAction {
  const _ProfileAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
}
