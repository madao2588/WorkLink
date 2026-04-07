import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class EnterpriseAdminScreen extends StatelessWidget {
  const EnterpriseAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.watch<EnterpriseAdminProvider>();

    final List<_AdminMetric> metrics = <_AdminMetric>[
      _AdminMetric(
        label: l10n.enterpriseAdminMetricEmployees,
        value: '${provider.totalEmployees}',
        accent: AppColors.brandBlue,
      ),
      _AdminMetric(
        label: l10n.enterpriseAdminMetricDepartments,
        value: '${provider.totalDepartments}',
        accent: AppColors.info,
      ),
      _AdminMetric(
        label: l10n.enterpriseAdminMetricPositions,
        value: '${provider.totalPositions}',
        accent: AppColors.warning,
      ),
      _AdminMetric(
        label: l10n.enterpriseAdminMetricAccounts,
        value: '${provider.enabledAccounts}',
        accent: AppColors.success,
      ),
    ];

    final List<_AdminModuleCardData> modules = <_AdminModuleCardData>[
      _AdminModuleCardData(
        title: l10n.enterpriseAdminModuleEmployeesTitle,
        subtitle: l10n.enterpriseAdminModuleEmployeesSubtitle,
        permission: AdminPermission.manageEmployees,
        icon: Icons.badge_outlined,
        accent: AppColors.brandBlue,
      ),
      _AdminModuleCardData(
        title: l10n.enterpriseAdminModuleDepartmentsTitle,
        subtitle: l10n.enterpriseAdminModuleDepartmentsSubtitle,
        permission: AdminPermission.manageDepartments,
        icon: Icons.account_tree_outlined,
        accent: AppColors.info,
      ),
      _AdminModuleCardData(
        title: l10n.enterpriseAdminModulePositionsTitle,
        subtitle: l10n.enterpriseAdminModulePositionsSubtitle,
        permission: AdminPermission.managePositions,
        icon: Icons.assignment_ind_outlined,
        accent: AppColors.warning,
      ),
      _AdminModuleCardData(
        title: l10n.enterpriseAdminModuleAccountsTitle,
        subtitle: l10n.enterpriseAdminModuleAccountsSubtitle,
        permission: AdminPermission.manageAccounts,
        icon: Icons.admin_panel_settings_outlined,
        accent: AppColors.success,
      ),
      _AdminModuleCardData(
        title: l10n.enterpriseAdminModuleExportTitle,
        subtitle: l10n.enterpriseAdminModuleExportSubtitle,
        permission: AdminPermission.exportData,
        icon: Icons.file_download_outlined,
        accent: AppColors.textSecondary,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.goNamed(AppRoutes.profile);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(l10n.enterpriseAdminTitle),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              sliver: SliverList.list(
                children: <Widget>[
                  _AdminHeroCard(provider: provider),
                  const SizedBox(height: 22),
                  _OrganizationSyncBanner(provider: provider),
                  const SizedBox(height: 22),
                  _SectionTitle(
                    title: l10n.enterpriseAdminSectionOverviewTitle,
                    subtitle: l10n.enterpriseAdminSectionOverviewSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _MetricsGrid(metrics: metrics),
                  const SizedBox(height: 22),
                  _SectionTitle(
                    title: l10n.enterpriseAdminSectionModulesTitle,
                    subtitle: l10n.enterpriseAdminSectionModulesSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _AdminModulesGrid(modules: modules),
                  const SizedBox(height: 22),
                  _SectionTitle(
                    title: l10n.enterpriseAdminSectionActionsTitle,
                    subtitle: l10n.enterpriseAdminSectionActionsSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _AdminActionCenter(provider: provider),
                  const SizedBox(height: 22),
                  _SectionTitle(
                    title: l10n.enterpriseAdminSectionPreviewTitle,
                    subtitle: l10n.enterpriseAdminSectionPreviewSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _AdminPreviewDeck(provider: provider),
                  const SizedBox(height: 22),
                  _SectionTitle(
                    title: l10n.enterpriseAdminSectionPermissionsTitle,
                    subtitle: l10n.enterpriseAdminSectionPermissionsSubtitle,
                  ),
                  const SizedBox(height: 14),
                  _PermissionSummaryCard(provider: provider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminHeroCard extends StatelessWidget {
  const _AdminHeroCard({required this.provider});

  final EnterpriseAdminProvider provider;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppThemePalette.heroGradient(context),
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.heroShadow(context),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(28),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.domain_verification_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.enterpriseAdminTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.enterpriseAdminSubtitle,
                      style: TextStyle(
                        color: Colors.white.withAlpha(220),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _HeroChip(
                label: l10n.enterpriseAdminRoleChip(
                  provider.currentRoleLabel(l10n),
                ),
              ),
              _HeroChip(
                label: l10n.enterpriseAdminSessionChip(
                  provider.sessionUserName(l10n),
                ),
              ),
              _HeroChip(
                label: provider.isOrganizationLoading
                    ? l10n.enterpriseAdminDataSourceChipLoading
                    : provider.usingLiveOrganizationData
                    ? l10n.enterpriseAdminDataSourceChipLive
                    : l10n.enterpriseAdminDataSourceChipFallback,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(24),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OrganizationSyncBanner extends StatelessWidget {
  const _OrganizationSyncBanner({required this.provider});

  final EnterpriseAdminProvider provider;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (provider.isOrganizationLoading) {
      return _SyncStatusCard(
        accent: AppColors.brandBlue,
        icon: Icons.sync_rounded,
        title: l10n.enterpriseAdminDataSourceLoadingTitle,
        subtitle: l10n.enterpriseAdminDataSourceLoadingSubtitle,
      );
    }

    if (provider.usingLiveOrganizationData) {
      return _SyncStatusCard(
        accent: AppColors.success,
        icon: Icons.cloud_done_outlined,
        title: l10n.enterpriseAdminDataSourceLiveTitle,
        subtitle: l10n.enterpriseAdminDataSourceLiveSubtitle,
      );
    }

    return _SyncStatusCard(
      accent: AppColors.warning,
      icon: Icons.cloud_off_outlined,
      title: l10n.enterpriseAdminDataSourceFallbackTitle,
      subtitle: provider.organizationErrorMessage == null ||
              provider.organizationErrorMessage!.trim().isEmpty
          ? l10n.enterpriseAdminDataSourceFallbackSubtitle
          : '${l10n.enterpriseAdminDataSourceFallbackSubtitle}\n${provider.organizationErrorMessage}',
      actionLabel: l10n.enterpriseAdminRetrySync,
      onPressed: provider.reloadOrganizationData,
    );
  }
}

class _SyncStatusCard extends StatelessWidget {
  const _SyncStatusCard({
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onPressed,
  });

  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final Color titleColor = AppThemePalette.textPrimary(context);
    final Color subtitleColor = AppThemePalette.textSecondary(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accent.withAlpha(10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withAlpha(34)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withAlpha(18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor,
                    height: 1.45,
                  ),
                ),
                if (actionLabel != null && onPressed != null) ...<Widget>[
                  const SizedBox(height: 14),
                  FilledButton.tonal(
                    onPressed: () => onPressed!.call(),
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminActionCenter extends StatelessWidget {
  const _AdminActionCenter({required this.provider});

  final EnterpriseAdminProvider provider;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool canExport = provider.hasPermission(AdminPermission.exportData);
    final bool busy = provider.isExporting || provider.isOrganizationLoading;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemePalette.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: provider.isOrganizationLoading
                    ? null
                    : () => _runAction(
                        context,
                        () async {
                          await provider.reloadOrganizationData();
                          return provider.usingLiveOrganizationData
                              ? l10n.enterpriseAdminSyncCompleted
                              : provider.organizationErrorMessage ??
                                    l10n.enterpriseAdminDataSourceFallbackSubtitle;
                        },
                      ),
                icon: const Icon(Icons.sync_rounded),
                label: Text(l10n.enterpriseAdminActionSyncNow),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  AppRoutes.enterpriseAdminChangeRequests,
                ),
                icon: const Icon(Icons.history_toggle_off_rounded),
                label: Text(l10n.enterpriseAdminActionChangeCenter),
              ),
              FilledButton.tonalIcon(
                onPressed: canExport && !busy
                    ? () => _runExport(
                        context,
                        provider.exportEmployees(l10n),
                      )
                    : null,
                icon: const Icon(Icons.badge_outlined),
                label: Text(l10n.enterpriseAdminActionExportEmployees),
              ),
              FilledButton.tonalIcon(
                onPressed: canExport && !busy
                    ? () => _runExport(
                        context,
                        provider.exportDepartments(l10n),
                      )
                    : null,
                icon: const Icon(Icons.account_tree_outlined),
                label: Text(l10n.enterpriseAdminActionExportDepartments),
              ),
              FilledButton.tonalIcon(
                onPressed: canExport && !busy
                    ? () => _runExport(
                        context,
                        provider.exportPositions(l10n),
                      )
                    : null,
                icon: const Icon(Icons.assignment_ind_outlined),
                label: Text(l10n.enterpriseAdminActionExportPositions),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            canExport
                ? l10n.enterpriseAdminActionExportReady
                : l10n.enterpriseAdminActionExportUnavailable,
            style: TextStyle(
              color: canExport
                  ? AppThemePalette.textHint(context)
                  : AppColors.danger,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runExport(BuildContext context, Future<String?> future) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String? path = await future;
    if (!context.mounted) {
      return;
    }
    if (path == null || path.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.enterpriseAdminExportCancelled)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.enterpriseAdminExportSuccess(path))),
    );
  }

  Future<void> _runAction(
    BuildContext context,
    Future<String> Function() action,
  ) async {
    final String message = await action();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _AdminPreviewDeck extends StatelessWidget {
  const _AdminPreviewDeck({required this.provider});

  final EnterpriseAdminProvider provider;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 760 ? 1 : 2;
        const double spacing = 14;
        final double itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: <Widget>[
            SizedBox(
              width: itemWidth,
              child: _PreviewCard(
                title: l10n.enterpriseAdminPreviewEmployeesTitle,
                subtitle: l10n.enterpriseAdminPreviewEmployeesSubtitle,
                accent: AppColors.brandBlue,
                icon: Icons.badge_outlined,
                allowed: provider.hasPermission(AdminPermission.manageEmployees),
                lockedMessage: provider.permissionDeniedMessage(
                  AdminPermission.manageEmployees,
                  l10n,
                ),
                actionLabel: l10n.enterpriseAdminPreviewOpenAll,
                onOpenAll: () => context.pushNamed(
                  AppRoutes.enterpriseAdminEmployees,
                ),
                items: provider.employees.take(4).map((EmployeeRecord item) {
                  return _PreviewItem(
                    title: item.name,
                    subtitle: '${item.departmentName} · ${item.positionName}',
                    badge: item.status,
                    onTap: () => _showDetailSheet(
                      context,
                      title: item.name,
                      rows: <_DetailRow>[
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailEmployeeNo,
                          value: item.employeeNo,
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailDepartment,
                          value: item.departmentName,
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailPosition,
                          value: item.positionName,
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailEmail,
                          value: item.email,
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailPhone,
                          value: item.phone,
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailStatus,
                          value: item.status,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                emptyMessage: l10n.enterpriseAdminPreviewEmployeesEmpty,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _PreviewCard(
                title: l10n.enterpriseAdminPreviewDepartmentsTitle,
                subtitle: l10n.enterpriseAdminPreviewDepartmentsSubtitle,
                accent: AppColors.info,
                icon: Icons.account_tree_outlined,
                allowed: provider.hasPermission(AdminPermission.manageDepartments),
                lockedMessage: provider.permissionDeniedMessage(
                  AdminPermission.manageDepartments,
                  l10n,
                ),
                actionLabel: l10n.enterpriseAdminPreviewOpenAll,
                onOpenAll: () => context.pushNamed(
                  AppRoutes.enterpriseAdminDepartments,
                ),
                items: provider.departments.take(4).map((DepartmentRecord item) {
                  return _PreviewItem(
                    title: item.name,
                    subtitle: '${item.leader} · ${item.memberCount}',
                    badge: '${item.memberCount}',
                    onTap: () => _showDetailSheet(
                      context,
                      title: item.name,
                      rows: <_DetailRow>[
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailLeader,
                          value: item.leader.isEmpty ? '-' : item.leader,
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailMemberCount,
                          value: '${item.memberCount}',
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailDescription,
                          value: item.description.isEmpty ? '-' : item.description,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                emptyMessage: l10n.enterpriseAdminPreviewDepartmentsEmpty,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _PreviewCard(
                title: l10n.enterpriseAdminPreviewPositionsTitle,
                subtitle: l10n.enterpriseAdminPreviewPositionsSubtitle,
                accent: AppColors.warning,
                icon: Icons.assignment_ind_outlined,
                allowed: provider.hasPermission(AdminPermission.managePositions),
                lockedMessage: provider.permissionDeniedMessage(
                  AdminPermission.managePositions,
                  l10n,
                ),
                actionLabel: l10n.enterpriseAdminPreviewOpenAll,
                onOpenAll: () => context.pushNamed(
                  AppRoutes.enterpriseAdminPositions,
                ),
                items: provider.positions.take(4).map((PositionRecord item) {
                  return _PreviewItem(
                    title: item.title,
                    subtitle: '${item.departmentName} · ${item.level}',
                    badge: '${item.openQuota}',
                    onTap: () => _showDetailSheet(
                      context,
                      title: item.title,
                      rows: <_DetailRow>[
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailDepartment,
                          value: item.departmentName,
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailLevel,
                          value: item.level,
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailHeadcount,
                          value: '${item.headcount}',
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailVacancy,
                          value: '${item.openQuota}',
                        ),
                      ],
                    ),
                  );
                }).toList(),
                emptyMessage: l10n.enterpriseAdminPreviewPositionsEmpty,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _PreviewCard(
                title: l10n.enterpriseAdminPreviewAccountsTitle,
                subtitle: l10n.enterpriseAdminPreviewAccountsSubtitle,
                accent: AppColors.success,
                icon: Icons.admin_panel_settings_outlined,
                allowed: provider.hasPermission(AdminPermission.manageAccounts),
                lockedMessage: provider.permissionDeniedMessage(
                  AdminPermission.manageAccounts,
                  l10n,
                ),
                actionLabel: l10n.enterpriseAdminPreviewOpenAll,
                onOpenAll: () => context.pushNamed(
                  AppRoutes.enterpriseAdminAccounts,
                ),
                items: provider.accounts.take(4).map((AccountRecord item) {
                  return _PreviewItem(
                    title: item.name,
                    subtitle: '${item.loginId} · ${_roleLabel(item.role, l10n)}',
                    badge: item.enabled
                        ? l10n.enterpriseAdminPreviewAccountEnabled
                        : l10n.enterpriseAdminPreviewAccountDisabled,
                    onTap: () => _showDetailSheet(
                      context,
                      title: item.name,
                      rows: <_DetailRow>[
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailLoginId,
                          value: item.loginId,
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailRole,
                          value: _roleLabel(item.role, l10n),
                        ),
                        _DetailRow(
                          label: l10n.enterpriseAdminDetailStatus,
                          value: item.enabled
                              ? l10n.enterpriseAdminPreviewAccountEnabled
                              : l10n.enterpriseAdminPreviewAccountDisabled,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                emptyMessage: l10n.enterpriseAdminPreviewAccountsEmpty,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDetailSheet(
    BuildContext context, {
    required String title,
    required List<_DetailRow> rows,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                for (final _DetailRow row in rows) ...<Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 92,
                        child: Text(
                          row.label,
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          row.value,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (row != rows.last)
                    Divider(color: AppColors.border, height: 20),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _roleLabel(AccountRole role, AppLocalizations l10n) {
    switch (role) {
      case AccountRole.superAdmin:
        return l10n.enterpriseAdminRoleSuperAdmin;
      case AccountRole.hrManager:
        return l10n.enterpriseAdminRoleHrManager;
      case AccountRole.departmentManager:
        return l10n.enterpriseAdminRoleDepartmentManager;
      case AccountRole.viewer:
        return l10n.enterpriseAdminRoleViewer;
    }
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.allowed,
    required this.lockedMessage,
    required this.items,
    required this.emptyMessage,
    this.actionLabel,
    this.onOpenAll,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final bool allowed;
  final String lockedMessage;
  final List<_PreviewItem> items;
  final String emptyMessage;
  final String? actionLabel;
  final VoidCallback? onOpenAll;

  @override
  Widget build(BuildContext context) {
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
                  color: accent.withAlpha(14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (allowed && actionLabel != null && onOpenAll != null)
                TextButton(
                  onPressed: onOpenAll,
                  child: Text(actionLabel!),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (!allowed)
            _LockedPreview(message: lockedMessage)
          else if (items.isEmpty)
            Text(
              emptyMessage,
              style: TextStyle(
                color: hintColor,
                height: 1.45,
              ),
            )
          else
            ...items.map(
              (_PreviewItem item) => _PreviewLine(item: item),
            ),
        ],
      ),
    );
  }
}

class _LockedPreview extends StatelessWidget {
  const _LockedPreview({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemePalette.mutedSurface(context),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.textHint,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppThemePalette.textSecondary(context),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({required this.item});

  final _PreviewItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppThemePalette.mutedSurface(context),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: TextStyle(
                          color: AppThemePalette.textPrimary(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          color: AppThemePalette.textSecondary(context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppThemePalette.surface(context),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppThemePalette.border(context)),
                  ),
                  child: Text(
                    item.badge,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppThemePalette.textSecondary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewItem {
  const _PreviewItem({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String badge;
  final VoidCallback onTap;
}

class _DetailRow {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
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
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final List<_AdminMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 560 ? 2 : 4;
        final double spacing = 12;
        final double itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: metrics
              .map(
                (_AdminMetric metric) => SizedBox(
                  width: itemWidth,
                  child: _MetricCard(metric: metric),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _AdminMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemePalette.border(context)),
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
          const SizedBox(height: 18),
          Text(
            metric.value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppThemePalette.textPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.label,
            style: TextStyle(
              color: AppThemePalette.textSecondary(context),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminModulesGrid extends StatelessWidget {
  const _AdminModulesGrid({required this.modules});

  final List<_AdminModuleCardData> modules;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 760 ? 1 : 2;
        final double spacing = 14;
        final double itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: modules
              .map(
                (_AdminModuleCardData module) => SizedBox(
                  width: itemWidth,
                  child: _AdminModuleCard(data: module),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AdminModuleCard extends StatelessWidget {
  const _AdminModuleCard({required this.data});

  final _AdminModuleCardData data;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.watch<EnterpriseAdminProvider>();
    final bool allowed = provider.hasPermission(data.permission);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemePalette.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: data.accent.withAlpha(16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(data.icon, color: data.accent),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: allowed
                      ? AppColors.success.withAlpha(16)
                      : AppColors.danger.withAlpha(16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  allowed
                      ? l10n.enterpriseAdminStatusAvailable
                      : l10n.enterpriseAdminStatusLocked,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: allowed ? AppColors.success : AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            data.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppThemePalette.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.subtitle,
            style: TextStyle(
              color: AppThemePalette.textSecondary(context),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            allowed
                ? l10n.enterpriseAdminModuleAllowedHint
                : provider.permissionDeniedMessage(data.permission, l10n),
            style: TextStyle(
              color: allowed ? AppColors.textHint : AppColors.danger,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionSummaryCard extends StatelessWidget {
  const _PermissionSummaryCard({required this.provider});

  final EnterpriseAdminProvider provider;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<_PermissionLine> lines = <_PermissionLine>[
      _PermissionLine(
        title: l10n.enterpriseAdminPermissionLineEmployees,
        granted: provider.hasPermission(AdminPermission.manageEmployees),
      ),
      _PermissionLine(
        title: l10n.enterpriseAdminPermissionLineDepartments,
        granted: provider.hasPermission(AdminPermission.manageDepartments),
      ),
      _PermissionLine(
        title: l10n.enterpriseAdminPermissionLinePositions,
        granted: provider.hasPermission(AdminPermission.managePositions),
      ),
      _PermissionLine(
        title: l10n.enterpriseAdminPermissionLineAccounts,
        granted: provider.hasPermission(AdminPermission.manageAccounts),
      ),
      _PermissionLine(
        title: l10n.enterpriseAdminPermissionLineExport,
        granted: provider.hasPermission(AdminPermission.exportData),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemePalette.border(context)),
      ),
      child: Column(
        children: <Widget>[
          for (int index = 0; index < lines.length; index++) ...<Widget>[
            _PermissionRow(line: lines[index]),
            if (index != lines.length - 1)
              Divider(color: AppThemePalette.border(context), height: 24),
          ],
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({required this.line});

  final _PermissionLine line;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          line.granted ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
          color: line.granted ? AppColors.success : AppColors.textHint,
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            line.title,
            style: TextStyle(
              color: AppThemePalette.textPrimary(context),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminMetric {
  const _AdminMetric({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;
}

class _AdminModuleCardData {
  const _AdminModuleCardData({
    required this.title,
    required this.subtitle,
    required this.permission,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final AdminPermission permission;
  final IconData icon;
  final Color accent;
}

class _PermissionLine {
  const _PermissionLine({
    required this.title,
    required this.granted,
  });

  final String title;
  final bool granted;
}
