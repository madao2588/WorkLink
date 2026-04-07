import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/widgets/enterprise_admin_read_only_page_parts.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class EnterprisePositionListScreen extends StatefulWidget {
  const EnterprisePositionListScreen({
    super.key,
    this.initialKeyword,
  });

  final String? initialKeyword;

  @override
  State<EnterprisePositionListScreen> createState() =>
      _EnterprisePositionListScreenState();
}

class _EnterprisePositionListScreenState
    extends State<EnterprisePositionListScreen> {
  static const String _allFilter = '_all';

  late final TextEditingController _searchController;
  String _selectedLevel = _allFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialKeyword ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<EnterpriseAdminProvider>().setPositionKeyword(
        widget.initialKeyword ?? '',
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (mounted) {
      context.read<EnterpriseAdminProvider>().setPositionKeyword('');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.watch<EnterpriseAdminProvider>();
    final List<PositionRecord> positions = provider.positions;
    final List<String> levels = positions
        .map((PositionRecord item) => item.level)
        .toSet()
        .toList()
      ..sort();
    final List<PositionRecord> filteredPositions = positions.where((
      PositionRecord item,
    ) {
      if (_selectedLevel == _allFilter) {
        return true;
      }
      return item.level == _selectedLevel;
    }).toList();
    final int totalHeadcount = filteredPositions.fold<int>(
      0,
      (int sum, PositionRecord item) => sum + item.headcount,
    );
    final int totalVacancy = filteredPositions.fold<int>(
      0,
      (int sum, PositionRecord item) => sum + item.openQuota,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.enterpriseAdminPositionsPageTitle),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverList.list(
                children: <Widget>[
                  EnterpriseAdminReadOnlyIntroCard(
                    title: l10n.enterpriseAdminPositionsPageTitle,
                    subtitle: l10n.enterpriseAdminPositionsPageSubtitle,
                    accent: AppColors.warning,
                    icon: Icons.assignment_ind_outlined,
                    summary: l10n.enterpriseAdminPositionsPageSummary(
                      filteredPositions.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                  EnterpriseAdminStatsRow(
                    items: <EnterpriseAdminStatItem>[
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminMetricPositions,
                        value: '${filteredPositions.length}',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminPositionsStatsHeadcount,
                        value: '$totalHeadcount',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminPositionsStatsVacancy,
                        value: '$totalVacancy',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: provider.setPositionKeyword,
                    decoration: InputDecoration(
                      hintText: l10n.enterpriseAdminPositionsSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  EnterpriseAdminFilterBar(
                    options: <String>[
                      l10n.enterpriseAdminFilterAll,
                      ...levels,
                    ],
                    selectedValue: _selectedLevel == _allFilter
                        ? l10n.enterpriseAdminFilterAll
                        : _selectedLevel,
                    onSelected: (String value) {
                      setState(() {
                        _selectedLevel = value == l10n.enterpriseAdminFilterAll
                            ? _allFilter
                            : value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (filteredPositions.isEmpty)
                    EnterpriseAdminEmptyStateCard(
                      message: l10n.enterpriseAdminPositionsEmpty,
                    )
                  else
                    ...filteredPositions.map(
                      (PositionRecord item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PositionCard(record: item),
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

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.record});

  final PositionRecord record;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.read<EnterpriseAdminProvider>();
    return EnterpriseAdminInteractiveCard(
      onTap: () => showEnterpriseAdminDetailSheet(
        context,
        title: record.title,
        rows: _buildDetailRows(context, record),
        timeline: _buildTimeline(l10n),
        directEditConfig: EnterpriseAdminDirectEditConfig(
          title: l10n.enterpriseAdminEditPositionTitle,
          hint: l10n.enterpriseAdminEditPositionHint,
          submitLabel: l10n.enterpriseAdminEditSubmit,
          fields: <EnterpriseAdminEditField>[
            EnterpriseAdminEditField(
              key: 'title',
              label: l10n.enterpriseAdminExportHeaderPosition,
              initialValue: record.title,
            ),
            EnterpriseAdminEditField(
              key: 'level',
              label: l10n.enterpriseAdminDetailLevel,
              initialValue: record.level,
              options: const <EnterpriseAdminEditOption>[
                EnterpriseAdminEditOption(value: 'P2', label: 'P2'),
                EnterpriseAdminEditOption(value: 'P3', label: 'P3'),
                EnterpriseAdminEditOption(value: 'P4', label: 'P4'),
                EnterpriseAdminEditOption(value: 'P5', label: 'P5'),
                EnterpriseAdminEditOption(value: 'M1', label: 'M1'),
              ],
            ),
            EnterpriseAdminEditField(
              key: 'openQuota',
              label: l10n.enterpriseAdminDetailVacancy,
              initialValue: '${record.openQuota}',
              keyboardType: TextInputType.number,
            ),
          ],
          onSubmit: (Map<String, String> values) async {
            final PositionRecord updated = await provider.updatePositionRecord(
              positionId: record.id,
              title: values['title']!,
              level: values['level']!,
              openQuota: int.tryParse(values['openQuota'] ?? '') ?? record.openQuota,
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
                title: l10n.enterpriseAdminTimelinePositionUpdated,
                subtitle: l10n.enterpriseAdminTimelinePositionUpdatedDetail(
                  updated.title,
                  updated.level,
                  updated.openQuota,
                ),
                timestamp: l10n.enterpriseAdminTimelineRecent,
                accent: AppColors.warning,
              ),
            );
          },
        ),
        onSubmitDraft: (String changeType, String note) async {
          final PositionRecord currentRecord = provider.positions.firstWhere(
            (PositionRecord item) => item.id == record.id,
            orElse: () => record,
          );
          final ChangeRequestReceipt receipt = await provider.submitChangeRequest(
            entityType: 'position',
            entityId: currentRecord.id,
            entityName: currentRecord.title,
            changeType: changeType,
            note: note,
            snapshot: <String, String>{
              'department': currentRecord.departmentName,
              'level': currentRecord.level,
              'headcount': '${currentRecord.headcount}',
              'vacancy': '${currentRecord.openQuota}',
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
                        record.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${record.departmentName} · ${record.level}',
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
                    l10n.enterpriseAdminPositionsVacancy(record.openQuota),
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
                  label: l10n.enterpriseAdminDetailLevel,
                  value: record.level,
                ),
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminDetailHeadcount,
                  value: '${record.headcount}',
                ),
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminDetailVacancy,
                  value: '${record.openQuota}',
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
        title: l10n.enterpriseAdminTimelinePositionVacancy,
        subtitle: l10n.enterpriseAdminTimelinePositionVacancyDetail(
          record.openQuota,
        ),
        timestamp: l10n.enterpriseAdminTimelineRecent,
        accent: AppColors.warning,
      ),
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelinePositionHeadcount,
        subtitle: l10n.enterpriseAdminTimelinePositionHeadcountDetail(
          record.headcount,
        ),
        timestamp: l10n.enterpriseAdminTimelineToday,
        accent: AppColors.brandBlue,
      ),
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelinePositionCreated,
        subtitle: l10n.enterpriseAdminTimelinePositionCreatedDetail(
          record.departmentName,
        ),
        timestamp: l10n.enterpriseAdminTimelineEarlier,
        accent: AppColors.info,
      ),
    ];
  }

  List<EnterpriseAdminDetailRow> _buildDetailRows(
    BuildContext context,
    PositionRecord target,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return <EnterpriseAdminDetailRow>[
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminExportHeaderPosition,
        value: target.title,
        copyValue: target.title,
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailDepartment,
        value: target.departmentName,
        copyValue: target.departmentName,
        onNavigate: () => context.pushNamed(
          AppRoutes.enterpriseAdminDepartments,
          queryParameters: <String, String>{'keyword': target.departmentName},
        ),
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailLevel,
        value: target.level,
        copyValue: target.level,
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailHeadcount,
        value: '${target.headcount}',
        copyValue: '${target.headcount}',
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailVacancy,
        value: '${target.openQuota}',
        copyValue: '${target.openQuota}',
      ),
    ];
  }
}
