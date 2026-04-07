import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/shared/widgets/app_dashboard_hero.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';
import 'package:my_first_app/features/auth/presentation/providers/user_provider.dart';
import 'package:my_first_app/features/profile/domain/models/profile_overview.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final UserProvider userProvider = context.watch<UserProvider>();
    final ProfileProvider profile = context.watch<ProfileProvider>();
    final EnterpriseAdminProvider enterpriseAdmin =
        context.watch<EnterpriseAdminProvider>();

    if (userProvider.currentUser == null) {
      return Scaffold(body: Center(child: Text(l10n.profilePleaseRelogin)));
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
                        message:
                            profile.overviewError ?? l10n.profileOverviewLoadFailed,
                        onRetry: () =>
                            context.read<ProfileProvider>().loadOverview(),
                      )
                    else
                      ..._buildContent(
                        context,
                        profile.overview!,
                        l10n,
                        enterpriseAdmin,
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

  List<Widget> _buildContent(
    BuildContext context,
    ProfileOverview overview,
    AppLocalizations l10n,
    EnterpriseAdminProvider enterpriseAdmin,
  ) {
    final List<_ProfileMetric> metrics = <_ProfileMetric>[
      _ProfileMetric(
        label: l10n.profileMetricAttendanceLabel,
        value: _attendanceLabel(overview.attendanceStatus, l10n),
        caption: overview.checkInTime == null
            ? l10n.profileMetricAttendanceCaptionNotCheckedIn
            : _timeLabel(overview.checkInTime!, l10n),
        accent: overview.hasCheckedIn ? AppColors.success : AppColors.warning,
      ),
      _ProfileMetric(
        label: l10n.profileMetricPendingApprovalsLabel,
        value: '${overview.pendingApprovalCount}',
        caption: l10n.profileMetricPendingApprovalsCaption,
        accent: AppColors.info,
      ),
      _ProfileMetric(
        label: l10n.profileMetricMessagesLabel,
        value: '${overview.totalMessageCount}',
        caption: l10n.profileMetricMessagesCaption(
          overview.unreadMessageCount,
        ),
        accent: AppColors.brandBlue,
      ),
    ];

    return <Widget>[
      _buildProfileHero(overview, l10n),
      const SizedBox(height: 20),
      _buildMetricsGrid(metrics),
      if (_canAccessEnterpriseAdmin(enterpriseAdmin)) ...<Widget>[
        const SizedBox(height: 24),
        _buildSectionTitle(
          title: l10n.profileSectionManagementTitle,
          subtitle: l10n.profileSectionManagementSubtitle,
        ),
        const SizedBox(height: 14),
        _buildActionGroup(
          context,
          title: l10n.profileSectionManagementTitle,
          actions: <_ProfileAction>[
            _ProfileAction(
              id: 'enterprise-admin',
              title: l10n.profileActionEnterpriseAdminTitle,
              subtitle: l10n.profileActionEnterpriseAdminSubtitle(
                enterpriseAdmin.currentRoleLabel(l10n),
              ),
              icon: Icons.admin_panel_settings_outlined,
              iconColor: AppColors.info,
            ),
          ],
        ),
      ],
      const SizedBox(height: 24),
      _buildSectionTitle(
        title: l10n.profileSectionWorkspaceTitle,
        subtitle: l10n.profileSectionWorkspaceSubtitle,
      ),
      const SizedBox(height: 14),
      _buildActionGroup(
        context,
        title: l10n.profileSectionPersonalTitle,
        actions: <_ProfileAction>[
          _ProfileAction(
            id: 'my-approvals',
            title: l10n.profileActionMyApprovalsTitle,
            subtitle: l10n.profileActionMyApprovalsSubtitle,
            icon: Icons.fact_check_outlined,
            iconColor: AppColors.brandBlue,
          ),
          _ProfileAction(
            id: 'salary-slips',
            title: l10n.profileActionSalarySlipsTitle,
            subtitle: l10n.profileActionSalarySlipsSubtitle,
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.warning,
          ),
          _ProfileAction(
            id: 'badges',
            title: l10n.profileActionBadgesTitle,
            subtitle: l10n.profileActionBadgesSubtitle,
            icon: Icons.workspace_premium_outlined,
            iconColor: Color(0xFF8B5CF6),
          ),
        ],
      ),
      const SizedBox(height: 18),
      _buildActionGroup(
        context,
        title: l10n.profileSectionSettingsTitle,
        actions: <_ProfileAction>[
          _ProfileAction(
            id: 'account-security',
            title: l10n.profileActionAccountSecurityTitle,
            subtitle: l10n.profileActionAccountSecuritySubtitle,
            icon: Icons.shield_outlined,
            iconColor: AppColors.success,
          ),
          _ProfileAction(
            id: 'general-settings',
            title: l10n.profileActionGeneralSettingsTitle,
            subtitle: l10n.profileActionGeneralSettingsSubtitle,
            icon: Icons.tune_rounded,
            iconColor: AppColors.textSecondary,
          ),
          _ProfileAction(
            id: 'help-feedback',
            title: l10n.profileActionHelpFeedbackTitle,
            subtitle: l10n.profileActionHelpFeedbackSubtitle,
            icon: Icons.support_agent_rounded,
            iconColor: AppColors.info,
          ),
        ],
      ),
      const SizedBox(height: 22),
      _buildLogoutButton(context, l10n),
    ];
  }

  bool _canAccessEnterpriseAdmin(EnterpriseAdminProvider enterpriseAdmin) {
    return enterpriseAdmin.hasPermission(AdminPermission.manageEmployees) ||
        enterpriseAdmin.hasPermission(AdminPermission.manageDepartments) ||
        enterpriseAdmin.hasPermission(AdminPermission.managePositions) ||
        enterpriseAdmin.hasPermission(AdminPermission.manageAccounts) ||
        enterpriseAdmin.hasPermission(AdminPermission.exportData);
  }

  Widget _buildProfileHero(ProfileOverview overview, AppLocalizations l10n) {
    return AppDashboardHero(
      title: overview.user.name,
      subtitle: overview.user.department,
      badgeText: overview.user.isOnline
          ? l10n.profileHeroOnline
          : l10n.profileHeroVerified,
      icon: Icons.account_circle_rounded,
      stats: <AppDashboardHeroStat>[
        AppDashboardHeroStat(
          label: l10n.profileMetricAttendanceLabel,
          value: _attendanceLabel(overview.attendanceStatus, l10n),
        ),
        AppDashboardHeroStat(
          label: l10n.profileMetricPendingApprovalsLabel,
          value: '${overview.pendingApprovalCount}',
        ),
        AppDashboardHeroStat(
          label: l10n.profileHeroUnreadMessagesLabel,
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
    final Color surfaceColor = AppThemePalette.surface(context);
    final Color borderColor = AppThemePalette.border(context);
    final Color titleColor = AppThemePalette.textPrimary(context);
    final Color subtitleColor = AppThemePalette.textSecondary(context);
    final Color hintColor = AppThemePalette.textHint(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.label,
            style: TextStyle(
              fontSize: 13,
              color: subtitleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.caption,
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: hintColor,
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
      children: <Widget>[
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

  Widget _buildActionGroup(
    BuildContext context, {
    required String title,
    required List<_ProfileAction> actions,
  }) {
    final Color surfaceColor = AppThemePalette.surface(context);
    final Color borderColor = AppThemePalette.border(context);
    final Color titleColor = AppThemePalette.textPrimary(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
          ...actions.map(
            (_ProfileAction action) => _ProfileActionTile(
              action: action,
              onTap: () => _handleActionTap(context, action.id, action.title),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l10n) {
    final bool darkMode = AppThemePalette.isDark(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          side: BorderSide(
            color: darkMode ? const Color(0xFF734049) : const Color(0xFFF0C4BF),
          ),
          backgroundColor: darkMode
              ? const Color(0xFF25161B)
              : const Color(0xFFFFF6F5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Text(
          l10n.profileLogoutButton,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  void _handleActionTap(BuildContext context, String actionId, String title) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    switch (actionId) {
      case 'my-approvals':
        context.pushNamed(AppRoutes.approval);
        return;
      case 'salary-slips':
        context.pushNamed(AppRoutes.salarySlips);
        return;
      case 'badges':
        context.pushNamed(AppRoutes.badges);
        return;
      case 'account-security':
        context.pushNamed(AppRoutes.accountSecurity);
        return;
      case 'general-settings':
        context.pushNamed(AppRoutes.generalSettings);
        return;
      case 'help-feedback':
        context.pushNamed(AppRoutes.helpFeedback);
        return;
      case 'enterprise-admin':
        context.pushNamed(AppRoutes.enterpriseAdmin);
        return;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(content: Text(l10n.profileActionComingSoon(title))),
        );
        return;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.profileLogoutDialogTitle),
          content: Text(l10n.profileLogoutDialogContent),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.profileDialogCancel),
            ),
            TextButton(
              onPressed: () {
                context.read<UserProvider>().logout();
                Navigator.pop(dialogContext);
              },
              child: Text(
                l10n.profileDialogConfirmLogout,
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }

  String _attendanceLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'CHECKED_IN':
      case 'ON_TIME':
        return l10n.profileAttendanceCheckedIn;
      case 'LATE':
        return l10n.profileAttendanceLate;
      case 'NOT_CHECKED_IN':
      default:
        return l10n.profileAttendancePending;
    }
  }

  String _timeLabel(DateTime time, AppLocalizations l10n) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return l10n.profileCheckInTimeLabel('$hour:$minute');
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
            color: AppThemePalette.surface(context),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppThemePalette.border(context)),
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppThemePalette.border(context)),
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
            style: TextStyle(
              color: AppThemePalette.textSecondary(context),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: Text(l10n.profileReload)),
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
    final Color titleColor = AppThemePalette.textPrimary(context);
    final Color subtitleColor = AppThemePalette.textSecondary(context);
    final Color hintColor = AppThemePalette.textHint(context);
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chevron_right_rounded,
                color: hintColor,
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
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
}
