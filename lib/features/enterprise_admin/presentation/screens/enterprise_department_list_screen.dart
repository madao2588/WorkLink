import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/widgets/enterprise_admin_read_only_page_parts.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class EnterpriseDepartmentListScreen extends StatefulWidget {
  const EnterpriseDepartmentListScreen({
    super.key,
    this.initialKeyword,
  });

  final String? initialKeyword;

  @override
  State<EnterpriseDepartmentListScreen> createState() =>
      _EnterpriseDepartmentListScreenState();
}

class _EnterpriseDepartmentListScreenState
    extends State<EnterpriseDepartmentListScreen> {
  static const String _allFilter = '_all';

  late final TextEditingController _searchController;
  String _selectedSizeBand = _allFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialKeyword ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<EnterpriseAdminProvider>().setDepartmentKeyword(
        widget.initialKeyword ?? '',
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (mounted) {
      context.read<EnterpriseAdminProvider>().setDepartmentKeyword('');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.watch<EnterpriseAdminProvider>();
    final List<DepartmentRecord> departments = provider.departments;
    final int totalMembers = departments.fold<int>(
      0,
      (int sum, DepartmentRecord item) => sum + item.memberCount,
    );
    final DepartmentRecord? largestDepartment = departments.isEmpty
        ? null
        : (departments.toList()
              ..sort(
                (DepartmentRecord a, DepartmentRecord b) =>
                    b.memberCount.compareTo(a.memberCount),
              ))
            .first;
    final Map<String, bool Function(DepartmentRecord)> filters =
        <String, bool Function(DepartmentRecord)>{
          l10n.enterpriseAdminFilterAll: (_) => true,
          l10n.enterpriseAdminDepartmentsFilterLarge: (
            DepartmentRecord item,
          ) => item.memberCount >= 10,
          l10n.enterpriseAdminDepartmentsFilterMedium: (
            DepartmentRecord item,
          ) => item.memberCount >= 5 && item.memberCount < 10,
          l10n.enterpriseAdminDepartmentsFilterCompact: (
            DepartmentRecord item,
          ) => item.memberCount < 5,
        };
    final String selectedLabel = _selectedSizeBand == _allFilter
        ? l10n.enterpriseAdminFilterAll
        : _selectedSizeBand;
    final List<DepartmentRecord> filteredDepartments = departments
        .where(filters[selectedLabel] ?? (_) => true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.enterpriseAdminDepartmentsPageTitle),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverList.list(
                children: <Widget>[
                  EnterpriseAdminReadOnlyIntroCard(
                    title: l10n.enterpriseAdminDepartmentsPageTitle,
                    subtitle: l10n.enterpriseAdminDepartmentsPageSubtitle,
                    accent: AppColors.info,
                    icon: Icons.account_tree_outlined,
                    summary: l10n.enterpriseAdminDepartmentsPageSummary(
                      filteredDepartments.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                  EnterpriseAdminStatsRow(
                    items: <EnterpriseAdminStatItem>[
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminMetricDepartments,
                        value: '${filteredDepartments.length}',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminDepartmentsStatsMembers,
                        value: '$totalMembers',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminDepartmentsStatsLargest,
                        value: largestDepartment == null
                            ? '-'
                            : l10n.enterpriseAdminDepartmentsMemberCount(
                                largestDepartment.memberCount,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: provider.setDepartmentKeyword,
                    decoration: InputDecoration(
                      hintText: l10n.enterpriseAdminDepartmentsSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  EnterpriseAdminFilterBar(
                    options: filters.keys.toList(),
                    selectedValue: selectedLabel,
                    onSelected: (String value) {
                      setState(() {
                        _selectedSizeBand = value == l10n.enterpriseAdminFilterAll
                            ? _allFilter
                            : value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (filteredDepartments.isEmpty)
                    EnterpriseAdminEmptyStateCard(
                      message: l10n.enterpriseAdminDepartmentsEmpty,
                    )
                  else
                    ...filteredDepartments.map(
                      (DepartmentRecord item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DepartmentCard(record: item),
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

class _DepartmentCard extends StatelessWidget {
  const _DepartmentCard({required this.record});

  final DepartmentRecord record;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.read<EnterpriseAdminProvider>();
    return EnterpriseAdminInteractiveCard(
      onTap: () => showEnterpriseAdminDetailSheet(
        context,
        title: record.name,
        rows: _buildDetailRows(context, record),
        timeline: _buildTimeline(l10n),
        directEditConfig: EnterpriseAdminDirectEditConfig(
          title: l10n.enterpriseAdminEditDepartmentTitle,
          hint: l10n.enterpriseAdminEditDepartmentHint,
          submitLabel: l10n.enterpriseAdminEditSubmit,
          fields: <EnterpriseAdminEditField>[
            EnterpriseAdminEditField(
              key: 'name',
              label: l10n.enterpriseAdminDetailDepartment,
              initialValue: record.name,
            ),
            EnterpriseAdminEditField(
              key: 'leader',
              label: l10n.enterpriseAdminDetailLeader,
              initialValue: record.leader,
            ),
            EnterpriseAdminEditField(
              key: 'description',
              label: l10n.enterpriseAdminDetailDescription,
              initialValue: record.description,
            ),
          ],
          onSubmit: (Map<String, String> values) async {
            final DepartmentRecord updated =
                await provider.updateDepartmentRecord(
              departmentId: record.id,
              name: values['name']!,
              leader: values['leader']!,
              description: values['description']!,
            );
            if (!context.mounted) {
              return EnterpriseAdminDirectEditResult(
                successMessage: l10n.enterpriseAdminEditSaveSuccess,
                updatedRows: const <EnterpriseAdminDetailRow>[],
              );
            }
            return EnterpriseAdminDirectEditResult(
              successMessage: l10n.enterpriseAdminEditSaveSuccess,
              updatedRows: _buildDetailRows(context, updated),
              timelineEntry: EnterpriseAdminTimelineEntry(
                title: l10n.enterpriseAdminTimelineDepartmentUpdated,
                subtitle: l10n.enterpriseAdminTimelineDepartmentUpdatedDetail(
                  updated.name,
                  updated.leader,
                ),
                timestamp: l10n.enterpriseAdminTimelineRecent,
                accent: AppColors.info,
              ),
            );
          },
        ),
        onSubmitDraft: (String changeType, String note) async {
          final DepartmentRecord currentRecord = provider.departments.firstWhere(
            (DepartmentRecord item) => item.id == record.id,
            orElse: () => record,
          );
          final ChangeRequestReceipt receipt = await provider.submitChangeRequest(
            entityType: 'department',
            entityId: currentRecord.id,
            entityName: currentRecord.name,
            changeType: changeType,
            note: note,
            snapshot: <String, String>{
              'leader': currentRecord.leader,
              'memberCount': '${currentRecord.memberCount}',
              'description': currentRecord.description,
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
                  child: Text(
                    record.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
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
                    l10n.enterpriseAdminDepartmentsMemberCount(record.memberCount),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              record.description,
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
                  label: l10n.enterpriseAdminDetailLeader,
                  value: record.leader,
                ),
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminDetailMemberCount,
                  value: '${record.memberCount}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<EnterpriseAdminTimelineEntry> _buildTimeline(AppLocalizations l10n) {
    return <EnterpriseAdminTimelineEntry>[
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelineDepartmentLeader,
        subtitle: l10n.enterpriseAdminTimelineDepartmentLeaderDetail(
          record.leader,
        ),
        timestamp: l10n.enterpriseAdminTimelineRecent,
        accent: AppColors.info,
      ),
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelineDepartmentSize,
        subtitle: l10n.enterpriseAdminTimelineDepartmentSizeDetail(
          record.memberCount,
        ),
        timestamp: l10n.enterpriseAdminTimelineToday,
        accent: AppColors.success,
      ),
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelineDepartmentCreated,
        subtitle: l10n.enterpriseAdminTimelineDepartmentCreatedDetail(
          record.name,
        ),
        timestamp: l10n.enterpriseAdminTimelineEarlier,
        accent: AppColors.brandBlue,
      ),
    ];
  }

  List<EnterpriseAdminDetailRow> _buildDetailRows(
    BuildContext context,
    DepartmentRecord target,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return <EnterpriseAdminDetailRow>[
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailDepartment,
        value: target.name,
        copyValue: target.name,
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailLeader,
        value: target.leader,
        copyValue: target.leader,
        onNavigate: () => context.pushNamed(
          AppRoutes.enterpriseAdminEmployees,
          queryParameters: <String, String>{'keyword': target.leader},
        ),
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailMemberCount,
        value: '${target.memberCount}',
        copyValue: '${target.memberCount}',
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailDescription,
        value: target.description,
        copyValue: target.description,
      ),
    ];
  }
}
