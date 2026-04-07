import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/widgets/enterprise_admin_read_only_page_parts.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class EnterpriseAccountListScreen extends StatefulWidget {
  const EnterpriseAccountListScreen({
    super.key,
    this.initialKeyword,
  });

  final String? initialKeyword;

  @override
  State<EnterpriseAccountListScreen> createState() =>
      _EnterpriseAccountListScreenState();
}

class _EnterpriseAccountListScreenState
    extends State<EnterpriseAccountListScreen> {
  static const String _allFilter = '_all';

  late final TextEditingController _searchController;
  String _selectedRole = _allFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialKeyword ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<EnterpriseAdminProvider>().setAccountKeyword(
        widget.initialKeyword ?? '',
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (mounted) {
      context.read<EnterpriseAdminProvider>().setAccountKeyword('');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.watch<EnterpriseAdminProvider>();
    final List<AccountRecord> accounts = provider.accounts;
    final Map<String, AccountRole?> roleFilters = <String, AccountRole?>{
      l10n.enterpriseAdminFilterAll: null,
      l10n.enterpriseAdminRoleSuperAdmin: AccountRole.superAdmin,
      l10n.enterpriseAdminRoleHrManager: AccountRole.hrManager,
      l10n.enterpriseAdminRoleDepartmentManager: AccountRole.departmentManager,
      l10n.enterpriseAdminRoleViewer: AccountRole.viewer,
    };
    final String selectedLabel = _selectedRole == _allFilter
        ? l10n.enterpriseAdminFilterAll
        : _selectedRole;
    final List<AccountRecord> filteredAccounts = accounts.where((
      AccountRecord item,
    ) {
      final AccountRole? role = roleFilters[selectedLabel];
      if (role == null) {
        return true;
      }
      return item.role == role;
    }).toList();
    final int enabledCount = filteredAccounts
        .where((AccountRecord item) => item.enabled)
        .length;
    final int disabledCount = filteredAccounts.length - enabledCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.enterpriseAdminAccountsPageTitle),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverList.list(
                children: <Widget>[
                  EnterpriseAdminReadOnlyIntroCard(
                    title: l10n.enterpriseAdminAccountsPageTitle,
                    subtitle: l10n.enterpriseAdminAccountsPageSubtitle,
                    accent: AppColors.success,
                    icon: Icons.admin_panel_settings_outlined,
                    summary: l10n.enterpriseAdminAccountsPageSummary(
                      filteredAccounts.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                  EnterpriseAdminStatsRow(
                    items: <EnterpriseAdminStatItem>[
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminMetricAccounts,
                        value: '${filteredAccounts.length}',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminAccountsStatsEnabled,
                        value: '$enabledCount',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminAccountsStatsDisabled,
                        value: '$disabledCount',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: provider.setAccountKeyword,
                    decoration: InputDecoration(
                      hintText: l10n.enterpriseAdminAccountsSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  EnterpriseAdminFilterBar(
                    options: roleFilters.keys.toList(),
                    selectedValue: selectedLabel,
                    onSelected: (String value) {
                      setState(() {
                        _selectedRole = value == l10n.enterpriseAdminFilterAll
                            ? _allFilter
                            : value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (filteredAccounts.isEmpty)
                    EnterpriseAdminEmptyStateCard(
                      message: l10n.enterpriseAdminAccountsEmpty,
                    )
                  else
                    ...filteredAccounts.map(
                      (AccountRecord item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _AccountCard(record: item),
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
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.record});

  final AccountRecord record;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.read<EnterpriseAdminProvider>();
    final String status = record.enabled
        ? l10n.enterpriseAdminPreviewAccountEnabled
        : l10n.enterpriseAdminPreviewAccountDisabled;
    return EnterpriseAdminInteractiveCard(
      onTap: () => showEnterpriseAdminDetailSheet(
        context,
        title: record.name,
        rows: _buildDetailRows(l10n, status),
        timeline: _buildTimeline(l10n, status),
        directEditConfig: EnterpriseAdminDirectEditConfig(
          title: l10n.enterpriseAdminEditAccountTitle,
          hint: l10n.enterpriseAdminEditAccountHint,
          submitLabel: l10n.enterpriseAdminEditSubmit,
          fields: <EnterpriseAdminEditField>[
            EnterpriseAdminEditField(
              key: 'role',
              label: l10n.enterpriseAdminDetailRole,
              initialValue: _roleKey(record.role),
              options: <EnterpriseAdminEditOption>[
                EnterpriseAdminEditOption(
                  value: 'superAdmin',
                  label: l10n.enterpriseAdminRoleSuperAdmin,
                ),
                EnterpriseAdminEditOption(
                  value: 'hrManager',
                  label: l10n.enterpriseAdminRoleHrManager,
                ),
                EnterpriseAdminEditOption(
                  value: 'departmentManager',
                  label: l10n.enterpriseAdminRoleDepartmentManager,
                ),
                EnterpriseAdminEditOption(
                  value: 'viewer',
                  label: l10n.enterpriseAdminRoleViewer,
                ),
              ],
            ),
            EnterpriseAdminEditField(
              key: 'enabled',
              label: l10n.enterpriseAdminDetailStatus,
              initialValue: record.enabled ? 'enabled' : 'disabled',
              options: <EnterpriseAdminEditOption>[
                EnterpriseAdminEditOption(
                  value: 'enabled',
                  label: l10n.enterpriseAdminPreviewAccountEnabled,
                ),
                EnterpriseAdminEditOption(
                  value: 'disabled',
                  label: l10n.enterpriseAdminPreviewAccountDisabled,
                ),
              ],
            ),
          ],
          onSubmit: (Map<String, String> values) async {
            final String? targetUserId = record.boundUserIds.isEmpty
                ? null
                : record.boundUserIds.first;
            if (targetUserId == null || targetUserId.isEmpty) {
              return EnterpriseAdminDirectEditResult(
                successMessage: l10n.enterpriseAdminEditSaveSuccess,
                updatedRows: _buildDetailRows(l10n, status),
              );
            }
            final AccountRecord updated = await provider.updateAccountRecord(
              userId: targetUserId,
              role: _roleFromKey(values['role']!),
              enabled: values['enabled'] == 'enabled',
            );
            if (!context.mounted) {
              return EnterpriseAdminDirectEditResult(
                successMessage: l10n.enterpriseAdminEditSaveSuccess,
                updatedRows: const <EnterpriseAdminDetailRow>[],
              );
            }
            final String updatedStatus = updated.enabled
                ? l10n.enterpriseAdminPreviewAccountEnabled
                : l10n.enterpriseAdminPreviewAccountDisabled;
            return EnterpriseAdminDirectEditResult(
              successMessage: l10n.enterpriseAdminEditSaveSuccess,
              updatedRows: _buildDetailRows(l10n, updatedStatus, target: updated),
              timelineEntry: EnterpriseAdminTimelineEntry(
                title: l10n.enterpriseAdminTimelineAccountUpdated,
                subtitle: l10n.enterpriseAdminTimelineAccountUpdatedDetail(
                  _roleLabel(updated.role, l10n),
                  updatedStatus,
                ),
                timestamp: l10n.enterpriseAdminTimelineRecent,
                accent: updated.enabled ? AppColors.success : AppColors.warning,
              ),
            );
          },
        ),
        onSubmitDraft: (String changeType, String note) async {
          final AccountRecord currentRecord = provider.accounts.firstWhere(
            (AccountRecord item) => item.id == record.id,
            orElse: () => record,
          );
          final String currentStatus = currentRecord.enabled
              ? l10n.enterpriseAdminPreviewAccountEnabled
              : l10n.enterpriseAdminPreviewAccountDisabled;
          final ChangeRequestReceipt receipt = await provider.submitChangeRequest(
            entityType: 'account',
            entityId: currentRecord.id,
            entityName: currentRecord.name,
            changeType: changeType,
            note: note,
            snapshot: <String, String>{
              'loginId': currentRecord.loginId,
              'role': _roleLabel(currentRecord.role, l10n),
              'status': currentStatus,
            },
          );
          return EnterpriseAdminDraftSubmission(
            successMessage: l10n.enterpriseAdminDraftSubmitSuccessWithRequest(
              receipt.requestNo,
            ),
            timelineEntry: EnterpriseAdminTimelineEntry(
              title: l10n.enterpriseAdminDraftTimelineTitle(changeType),
              subtitle: l10n.enterpriseAdminDraftTimelineDetailWithRequest(
                note,
                receipt.requestNo,
              ),
              timestamp: l10n.enterpriseAdminTimelineRecent,
              accent: AppColors.warning,
            ),
          );
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        record.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${record.loginId} · ${_roleLabel(record.role, l10n)}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminDetailLoginId,
                  value: record.loginId,
                ),
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminDetailRole,
                  value: _roleLabel(record.role, l10n),
                ),
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminDetailStatus,
                  value: status,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<EnterpriseAdminTimelineEntry> _buildTimeline(
    AppLocalizations l10n,
    String status,
  ) {
    return <EnterpriseAdminTimelineEntry>[
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelineAccountStatus,
        subtitle: l10n.enterpriseAdminTimelineAccountStatusDetail(status),
        timestamp: l10n.enterpriseAdminTimelineRecent,
        accent: record.enabled ? AppColors.success : AppColors.warning,
      ),
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelineAccountRole,
        subtitle: l10n.enterpriseAdminTimelineAccountRoleDetail(
          _roleLabel(record.role, l10n),
        ),
        timestamp: l10n.enterpriseAdminTimelineToday,
        accent: AppColors.brandBlue,
      ),
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelineAccountCreated,
        subtitle: l10n.enterpriseAdminTimelineAccountCreatedDetail(
          record.loginId,
        ),
        timestamp: l10n.enterpriseAdminTimelineEarlier,
        accent: AppColors.info,
      ),
    ];
  }

  List<EnterpriseAdminDetailRow> _buildDetailRows(
    AppLocalizations l10n,
    String status, {
    AccountRecord? target,
  }) {
    final AccountRecord current = target ?? record;
    return <EnterpriseAdminDetailRow>[
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailLoginId,
        value: current.loginId,
        copyValue: current.loginId,
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailRole,
        value: _roleLabel(current.role, l10n),
        copyValue: _roleLabel(current.role, l10n),
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailStatus,
        value: status,
        copyValue: status,
      ),
    ];
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

  String _roleKey(AccountRole role) {
    switch (role) {
      case AccountRole.superAdmin:
        return 'superAdmin';
      case AccountRole.hrManager:
        return 'hrManager';
      case AccountRole.departmentManager:
        return 'departmentManager';
      case AccountRole.viewer:
        return 'viewer';
    }
  }

  AccountRole _roleFromKey(String value) {
    switch (value) {
      case 'superAdmin':
        return AccountRole.superAdmin;
      case 'hrManager':
        return AccountRole.hrManager;
      case 'departmentManager':
        return AccountRole.departmentManager;
      case 'viewer':
      default:
        return AccountRole.viewer;
    }
  }
}
