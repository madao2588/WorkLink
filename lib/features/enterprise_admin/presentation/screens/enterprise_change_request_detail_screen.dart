import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/widgets/enterprise_admin_read_only_page_parts.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class EnterpriseChangeRequestDetailScreen extends StatefulWidget {
  const EnterpriseChangeRequestDetailScreen({
    super.key,
    required this.requestId,
  });

  final String requestId;

  @override
  State<EnterpriseChangeRequestDetailScreen> createState() =>
      _EnterpriseChangeRequestDetailScreenState();
}

class _EnterpriseChangeRequestDetailScreenState
    extends State<EnterpriseChangeRequestDetailScreen> {
  late Future<ChangeRequestDetailRecord> _future;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _future = _loadDetail();
  }

  Future<ChangeRequestDetailRecord> _loadDetail() {
    return context.read<EnterpriseAdminProvider>().fetchChangeRequestDetail(
      widget.requestId,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _loadDetail();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChangeRequestDetailRecord>(
      future: _future,
      builder: (
        BuildContext context,
        AsyncSnapshot<ChangeRequestDetailRecord> snapshot,
      ) {
        final AppLocalizations l10n = AppLocalizations.of(context)!;
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.enterpriseAdminChangeRequestDetailTitle),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EnterpriseAdminEmptyStateCard(
                  message: l10n.enterpriseAdminChangeRequestDetailLoadFailed,
                ),
              ),
            ),
          );
        }

        final EnterpriseAdminProvider provider =
            context.watch<EnterpriseAdminProvider>();
        final ChangeRequestDetailRecord detail = snapshot.data!;
        final bool canReview = _canReview(detail, provider);
        final String locale = Localizations.localeOf(context).toLanguageTag();
        final String submittedAt = DateFormat.yMMMd(
          locale,
        ).add_Hm().format(detail.submittedAt.toLocal());
        final bool applied = detail.status == 'APPLIED';
        final bool rejected = detail.status == 'REJECTED';
        final Color statusColor = applied
            ? AppColors.success
            : rejected
            ? AppColors.danger
            : AppColors.warning;
        final String statusLabel = applied
            ? l10n.enterpriseAdminChangeRequestsStatusApplied
            : rejected
            ? l10n.enterpriseAdminChangeRequestsStatusRejected
            : l10n.enterpriseAdminChangeRequestsStatusDrafted;
        final List<_ChangeFieldComparison> comparisons = _buildComparisons(
          detail,
          provider,
          l10n,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.enterpriseAdminChangeRequestDetailTitle),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    sliver: SliverList.list(
                      children: <Widget>[
                        EnterpriseAdminReadOnlyIntroCard(
                          title: detail.requestNo,
                          subtitle: l10n.enterpriseAdminChangeRequestDetailSubtitle(
                            _entityTypeLabel(detail.entityType, l10n),
                          ),
                          accent: statusColor,
                          icon: Icons.fact_check_outlined,
                          summary: detail.entityName,
                        ),
                        const SizedBox(height: 16),
                        EnterpriseAdminStatsRow(
                          items: <EnterpriseAdminStatItem>[
                            EnterpriseAdminStatItem(
                              label: l10n.enterpriseAdminChangeRequestsRequester,
                              value: detail.requesterName,
                            ),
                            EnterpriseAdminStatItem(
                              label: l10n.enterpriseAdminChangeRequestsSubmittedAt,
                              value: submittedAt,
                            ),
                            EnterpriseAdminStatItem(
                              label:
                                  l10n.enterpriseAdminChangeRequestDetailStatus,
                              value: statusLabel,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ActionCard(
                          detail: detail,
                          canReview: canReview,
                          isProcessing: _isProcessing,
                          onApprove: detail.status == 'DRAFTED' && canReview
                              ? () => _handleApprove(detail)
                              : null,
                          onReject: detail.status == 'DRAFTED' && canReview
                              ? () => _handleReject(detail)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title: l10n.enterpriseAdminChangeRequestDetailNoteTitle,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                detail.note,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: <Widget>[
                                  EnterpriseAdminDataChip(
                                    label: l10n.enterpriseAdminDetailActionAudit,
                                    value: detail.changeType,
                                  ),
                                  EnterpriseAdminDataChip(
                                    label: l10n
                                        .enterpriseAdminChangeRequestDetailObjectLabel,
                                    value: detail.entityName,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title:
                              l10n.enterpriseAdminChangeRequestDetailSnapshotTitle,
                          subtitle: l10n
                              .enterpriseAdminChangeRequestDetailSnapshotSubtitle,
                          child: detail.snapshot.isEmpty
                              ? Text(
                                  l10n
                                      .enterpriseAdminChangeRequestDetailSnapshotEmpty,
                                  style: const TextStyle(
                                    color: AppColors.textHint,
                                    height: 1.45,
                                  ),
                                )
                              : Column(
                                  children: detail.snapshot.entries
                                      .map(
                                        (MapEntry<String, String> entry) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: _SnapshotRow(
                                            label: _fieldLabel(entry.key, l10n),
                                            value: entry.value,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title:
                              l10n.enterpriseAdminChangeRequestDetailCompareTitle,
                          subtitle: l10n
                              .enterpriseAdminChangeRequestDetailCompareSubtitle,
                          child: comparisons.isEmpty
                              ? Text(
                                  l10n.enterpriseAdminChangeRequestDetailCompareEmpty,
                                  style: const TextStyle(
                                    color: AppColors.textHint,
                                    height: 1.45,
                                  ),
                                )
                              : Column(
                                  children: comparisons
                                      .map(
                                        (_ChangeFieldComparison item) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: _ComparisonRow(item: item),
                                        ),
                                      )
                                      .toList(),
                                ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FilledButton.tonalIcon(
                            onPressed: () => _openRelatedRecord(context, detail),
                            icon: const Icon(Icons.arrow_outward_rounded),
                            label: Text(
                              l10n.enterpriseAdminChangeRequestsOpenRecord,
                            ),
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
      },
    );
  }

  Future<void> _handleApprove(ChangeRequestDetailRecord detail) async {
    await _runDecision(
      action: () => context.read<EnterpriseAdminProvider>().approveChangeRequest(
        detail.id,
      ),
      successMessage:
          AppLocalizations.of(context)!.enterpriseAdminChangeRequestApproveSuccess,
    );
  }

  Future<void> _handleReject(ChangeRequestDetailRecord detail) async {
    await _runDecision(
      action: () => context.read<EnterpriseAdminProvider>().rejectChangeRequest(
        detail.id,
      ),
      successMessage:
          AppLocalizations.of(context)!.enterpriseAdminChangeRequestRejectSuccess,
    );
  }

  Future<void> _runDecision({
    required Future<ChangeRequestDetailRecord> Function() action,
    required String successMessage,
  }) async {
    if (_isProcessing) {
      return;
    }
    setState(() {
      _isProcessing = true;
    });
    try {
      await action();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
      await _refresh();
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.enterpriseAdminChangeRequestDetailLoadFailed,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _openRelatedRecord(
    BuildContext context,
    ChangeRequestDetailRecord detail,
  ) {
    final String routeName = switch (detail.entityType) {
      'employee' => AppRoutes.enterpriseAdminEmployees,
      'department' => AppRoutes.enterpriseAdminDepartments,
      'position' => AppRoutes.enterpriseAdminPositions,
      'account' => AppRoutes.enterpriseAdminAccounts,
      _ => AppRoutes.enterpriseAdmin,
    };
    context.pushNamed(
      routeName,
      queryParameters: <String, String>{'keyword': detail.entityName},
    );
  }

  List<_ChangeFieldComparison> _buildComparisons(
    ChangeRequestDetailRecord detail,
    EnterpriseAdminProvider provider,
    AppLocalizations l10n,
  ) {
    final Map<String, String> currentValues = _currentValues(detail, provider);
    return detail.snapshot.entries.map((MapEntry<String, String> entry) {
      final String currentValue =
          currentValues[entry.key]?.trim().isNotEmpty == true
          ? currentValues[entry.key]!
          : l10n.enterpriseAdminChangeRequestDetailCompareUnavailable;
      return _ChangeFieldComparison(
        label: _fieldLabel(entry.key, l10n),
        snapshotValue: entry.value,
        currentValue: currentValue,
        matches: entry.value.trim() == currentValue.trim(),
      );
    }).toList();
  }

  Map<String, String> _currentValues(
    ChangeRequestDetailRecord detail,
    EnterpriseAdminProvider provider,
  ) {
    switch (detail.entityType) {
      case 'employee':
        final EmployeeRecord? employee = provider.employees.cast<EmployeeRecord?>()
            .firstWhere(
              (EmployeeRecord? item) => item?.id == detail.entityId,
              orElse: () => null,
            );
        if (employee == null) {
          return const <String, String>{};
        }
        return <String, String>{
          'employeeNo': employee.employeeNo,
          'departmentId': employee.departmentId,
          'department': employee.departmentName,
          'position': employee.positionName,
          'mobile': employee.phone,
          'email': employee.email,
          'status': employee.status,
        };
      case 'department':
        final DepartmentRecord? department =
            provider.departments.cast<DepartmentRecord?>().firstWhere(
              (DepartmentRecord? item) => item?.id == detail.entityId,
              orElse: () => null,
            );
        if (department == null) {
          return const <String, String>{};
        }
        return <String, String>{
          'name': department.name,
          'leader': department.leader,
          'description': department.description,
          'memberCount': '${department.memberCount}',
        };
      case 'position':
        final PositionRecord? position =
            provider.positions.cast<PositionRecord?>().firstWhere(
              (PositionRecord? item) => item?.id == detail.entityId,
              orElse: () => null,
            );
        if (position == null) {
          return const <String, String>{};
        }
        return <String, String>{
          'title': position.title,
          'level': position.level,
          'department': position.departmentName,
          'departmentName': position.departmentName,
          'headcount': '${position.headcount}',
          'openQuota': '${position.openQuota}',
          'vacancy': '${position.openQuota}',
        };
      case 'account':
        final AccountRecord? account = provider.accounts.cast<AccountRecord?>()
            .firstWhere(
              (AccountRecord? item) =>
                  item?.id == detail.entityId ||
                  item?.boundUserIds.contains(detail.entityId) == true,
              orElse: () => null,
            );
        if (account == null) {
          return const <String, String>{};
        }
        return <String, String>{
          'name': account.name,
          'loginId': account.loginId,
          'role': account.role.name,
          'enabled': account.enabled.toString(),
        };
      default:
        return const <String, String>{};
    }
  }

  String _fieldLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'employeeNo':
        return l10n.enterpriseAdminExportHeaderEmployeeNo;
      case 'departmentId':
      case 'department':
      case 'departmentName':
        return l10n.enterpriseAdminDetailDepartment;
      case 'position':
      case 'title':
        return l10n.enterpriseAdminExportHeaderPosition;
      case 'mobile':
        return l10n.enterpriseAdminDetailPhone;
      case 'email':
        return l10n.enterpriseAdminDetailEmail;
      case 'status':
      case 'enabled':
        return l10n.enterpriseAdminChangeRequestDetailStatus;
      case 'name':
        return l10n.enterpriseAdminChangeRequestDetailObjectLabel;
      case 'leader':
        return l10n.enterpriseAdminExportHeaderLeader;
      case 'description':
        return l10n.enterpriseAdminExportHeaderDescription;
      case 'memberCount':
      case 'headcount':
        return l10n.enterpriseAdminExportHeaderHeadcount;
      case 'openQuota':
      case 'vacancy':
        return l10n.enterpriseAdminExportHeaderVacancy;
      case 'level':
        return l10n.enterpriseAdminExportHeaderLevel;
      case 'loginId':
        return l10n.loginLabelAccount;
      case 'role':
        return l10n.enterpriseAdminDetailRole;
      default:
        return key;
    }
  }

  String _entityTypeLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'employee':
        return l10n.enterpriseAdminChangeRequestsEntityEmployee;
      case 'department':
        return l10n.enterpriseAdminChangeRequestsEntityDepartment;
      case 'position':
        return l10n.enterpriseAdminChangeRequestsEntityPosition;
      case 'account':
        return l10n.enterpriseAdminChangeRequestsEntityAccount;
      default:
        return value;
    }
  }

  bool _canReview(
    ChangeRequestDetailRecord detail,
    EnterpriseAdminProvider provider,
  ) {
    switch (detail.entityType) {
      case 'employee':
        return provider.hasPermission(AdminPermission.manageEmployees);
      case 'department':
        return provider.hasPermission(AdminPermission.manageDepartments);
      case 'position':
        return provider.hasPermission(AdminPermission.managePositions);
      case 'account':
        return provider.hasPermission(AdminPermission.manageAccounts);
      default:
        return false;
    }
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.detail,
    required this.canReview,
    required this.isProcessing,
    required this.onApprove,
    required this.onReject,
  });

  final ChangeRequestDetailRecord detail;
  final bool canReview;
  final bool isProcessing;
  final Future<void> Function()? onApprove;
  final Future<void> Function()? onReject;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool actionable = detail.status == 'DRAFTED';
    return _InfoCard(
      title: l10n.enterpriseAdminSectionActionsTitle,
      subtitle: !canReview
          ? l10n.enterpriseAdminChangeRequestReviewUnavailable
          : null,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          FilledButton.icon(
            onPressed: actionable && canReview && !isProcessing
                ? () => onApprove?.call()
                : null,
            icon: const Icon(Icons.check_circle_outline_rounded),
            label: Text(
              isProcessing
                  ? l10n.enterpriseAdminChangeRequestProcessing
                  : l10n.enterpriseAdminChangeRequestApprove,
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: actionable && canReview && !isProcessing
                ? () => onReject?.call()
                : null,
            icon: const Icon(Icons.cancel_outlined),
            label: Text(l10n.enterpriseAdminChangeRequestReject),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              subtitle!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SnapshotRow extends StatelessWidget {
  const _SnapshotRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeFieldComparison {
  const _ChangeFieldComparison({
    required this.label,
    required this.snapshotValue,
    required this.currentValue,
    required this.matches,
  });

  final String label;
  final String snapshotValue;
  final String currentValue;
  final bool matches;
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.item});

  final _ChangeFieldComparison item;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color accent = item.matches ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: accent.withAlpha(16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.matches
                      ? l10n.enterpriseAdminChangeRequestDetailCompareSame
                      : l10n.enterpriseAdminChangeRequestDetailCompareDifferent,
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _ComparisonValueBlock(
                  title: l10n.enterpriseAdminChangeRequestDetailCompareSnapshot,
                  value: item.snapshotValue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ComparisonValueBlock(
                  title: l10n.enterpriseAdminChangeRequestDetailCompareCurrent,
                  value: item.currentValue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparisonValueBlock extends StatelessWidget {
  const _ComparisonValueBlock({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
