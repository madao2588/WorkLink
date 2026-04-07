import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/widgets/enterprise_admin_read_only_page_parts.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class EnterpriseChangeRequestListScreen extends StatefulWidget {
  const EnterpriseChangeRequestListScreen({
    super.key,
    this.initialKeyword,
  });

  final String? initialKeyword;

  @override
  State<EnterpriseChangeRequestListScreen> createState() =>
      _EnterpriseChangeRequestListScreenState();
}

class _EnterpriseChangeRequestListScreenState
    extends State<EnterpriseChangeRequestListScreen> {
  static const String _allFilter = '_all';

  late final TextEditingController _searchController;
  String _selectedEntityType = _allFilter;
  String _selectedStatus = _allFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialKeyword ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<EnterpriseAdminProvider>().reloadChangeRequests();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.watch<EnterpriseAdminProvider>();
    final List<ChangeRequestRecord> requests = provider.changeRequests;
    final String keyword = _searchController.text.trim().toLowerCase();
    final List<String> entityTypes = requests
        .map((ChangeRequestRecord item) => item.entityType)
        .toSet()
        .toList()
      ..sort();
    final List<ChangeRequestRecord> filteredRequests = requests.where((
      ChangeRequestRecord item,
    ) {
      if (_selectedEntityType != _allFilter &&
          item.entityType != _selectedEntityType) {
        return false;
      }
      if (_selectedStatus != _allFilter && item.status != _selectedStatus) {
        return false;
      }
      if (keyword.isEmpty) {
        return true;
      }
      return item.requestNo.toLowerCase().contains(keyword) ||
          item.entityName.toLowerCase().contains(keyword) ||
          item.note.toLowerCase().contains(keyword) ||
          item.requesterName.toLowerCase().contains(keyword);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.enterpriseAdminChangeRequestsPageTitle),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverList.list(
                children: <Widget>[
                  EnterpriseAdminReadOnlyIntroCard(
                    title: l10n.enterpriseAdminChangeRequestsPageTitle,
                    subtitle: l10n.enterpriseAdminChangeRequestsPageSubtitle,
                    accent: AppColors.brandBlue,
                    icon: Icons.history_toggle_off_rounded,
                    summary: l10n.enterpriseAdminChangeRequestsPageSummary(
                      filteredRequests.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                  EnterpriseAdminStatsRow(
                    items: <EnterpriseAdminStatItem>[
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminChangeRequestsMetricTotal,
                        value: '${provider.totalChangeRequests}',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminChangeRequestsMetricApplied,
                        value: '${provider.appliedChangeRequests}',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminChangeRequestsMetricDrafted,
                        value: '${provider.draftedChangeRequests}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.enterpriseAdminChangeRequestsSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  EnterpriseAdminFilterBar(
                    options: <String>[
                      l10n.enterpriseAdminFilterAll,
                      ...entityTypes.map((String value) => _entityTypeLabel(value, l10n)),
                    ],
                    selectedValue: _selectedEntityType == _allFilter
                        ? l10n.enterpriseAdminFilterAll
                        : _entityTypeLabel(_selectedEntityType, l10n),
                    onSelected: (String value) {
                      setState(() {
                        if (value == l10n.enterpriseAdminFilterAll) {
                          _selectedEntityType = _allFilter;
                          return;
                        }
                        _selectedEntityType = entityTypes.firstWhere(
                          (String item) => _entityTypeLabel(item, l10n) == value,
                          orElse: () => _allFilter,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  EnterpriseAdminFilterBar(
                    options: <String>[
                      l10n.enterpriseAdminFilterAll,
                      l10n.enterpriseAdminChangeRequestsStatusApplied,
                      l10n.enterpriseAdminChangeRequestsStatusDrafted,
                      l10n.enterpriseAdminChangeRequestsStatusRejected,
                    ],
                    selectedValue: _selectedStatus == _allFilter
                        ? l10n.enterpriseAdminFilterAll
                        : _statusLabel(_selectedStatus, l10n),
                    onSelected: (String value) {
                      setState(() {
                        if (value == l10n.enterpriseAdminFilterAll) {
                          _selectedStatus = _allFilter;
                        } else if (value ==
                            l10n.enterpriseAdminChangeRequestsStatusApplied) {
                          _selectedStatus = 'APPLIED';
                        } else if (value ==
                            l10n.enterpriseAdminChangeRequestsStatusRejected) {
                          _selectedStatus = 'REJECTED';
                        } else {
                          _selectedStatus = 'DRAFTED';
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (provider.isChangeRequestsLoading && requests.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (filteredRequests.isEmpty)
                    EnterpriseAdminEmptyStateCard(
                      message: l10n.enterpriseAdminChangeRequestsEmpty,
                    )
                  else
                    ...filteredRequests.map(
                      (ChangeRequestRecord item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ChangeRequestCard(record: item),
                      ),
                    ),
                  if (provider.changeRequestsErrorMessage != null &&
                      provider.changeRequestsErrorMessage!.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 16),
                    Text(
                      provider.changeRequestsErrorMessage!,
                      style: const TextStyle(
                        color: AppColors.danger,
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  String _statusLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'APPLIED':
        return l10n.enterpriseAdminChangeRequestsStatusApplied;
      case 'REJECTED':
        return l10n.enterpriseAdminChangeRequestsStatusRejected;
      case 'DRAFTED':
        return l10n.enterpriseAdminChangeRequestsStatusDrafted;
      default:
        return value;
    }
  }
}

class _ChangeRequestCard extends StatelessWidget {
  const _ChangeRequestCard({required this.record});

  final ChangeRequestRecord record;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String locale = Localizations.localeOf(context).toLanguageTag();
    final String submittedAt = DateFormat.yMMMd(locale).add_Hm().format(
      record.submittedAt.toLocal(),
    );
    final bool applied = record.status == 'APPLIED';
    final bool rejected = record.status == 'REJECTED';
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

    return EnterpriseAdminInteractiveCard(
      onTap: () => _openDetail(context),
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
                        record.requestNo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${record.entityName} / ${_entityTypeLabel(record.entityType, l10n)}',
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
                    color: statusColor.withAlpha(16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              record.note,
              style: const TextStyle(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminChangeRequestsRequester,
                  value: record.requesterName,
                ),
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminChangeRequestsSubmittedAt,
                  value: submittedAt,
                ),
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminDetailActionAudit,
                  value: record.changeType,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _openRelatedRecord(context),
                icon: const Icon(Icons.arrow_outward_rounded),
                label: Text(l10n.enterpriseAdminChangeRequestsOpenRecord),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    context.pushNamed(
      AppRoutes.enterpriseAdminChangeRequestDetail,
      pathParameters: <String, String>{'requestId': record.id},
    );
  }

  void _openRelatedRecord(BuildContext context) {
    final String routeName = switch (record.entityType) {
      'employee' => AppRoutes.enterpriseAdminEmployees,
      'department' => AppRoutes.enterpriseAdminDepartments,
      'position' => AppRoutes.enterpriseAdminPositions,
      'account' => AppRoutes.enterpriseAdminAccounts,
      _ => AppRoutes.enterpriseAdmin,
    };
    context.pushNamed(
      routeName,
      queryParameters: <String, String>{'keyword': record.entityName},
    );
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
}
