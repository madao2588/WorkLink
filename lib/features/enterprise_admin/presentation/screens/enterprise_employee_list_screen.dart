import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/router/app_router.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/widgets/enterprise_admin_read_only_page_parts.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class EnterpriseEmployeeListScreen extends StatefulWidget {
  const EnterpriseEmployeeListScreen({
    super.key,
    this.initialKeyword,
  });

  final String? initialKeyword;

  @override
  State<EnterpriseEmployeeListScreen> createState() =>
      _EnterpriseEmployeeListScreenState();
}

class _EnterpriseEmployeeListScreenState
    extends State<EnterpriseEmployeeListScreen> {
  static const String _allFilter = '_all';

  late final TextEditingController _searchController;
  String _selectedDepartment = _allFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialKeyword ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<EnterpriseAdminProvider>().setEmployeeKeyword(
        widget.initialKeyword ?? '',
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (mounted) {
      context.read<EnterpriseAdminProvider>().setEmployeeKeyword('');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.watch<EnterpriseAdminProvider>();
    final List<EmployeeRecord> employees = provider.employees;
    final List<String> departments = employees
        .map((EmployeeRecord item) => item.departmentName)
        .toSet()
        .toList()
      ..sort();
    final List<EmployeeRecord> filteredEmployees = employees.where((
      EmployeeRecord item,
    ) {
      if (_selectedDepartment == _allFilter) {
        return true;
      }
      return item.departmentName == _selectedDepartment;
    }).toList();
    final int positionCount = employees
        .map((EmployeeRecord item) => item.positionName)
        .toSet()
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.enterpriseAdminEmployeesPageTitle),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverList.list(
                children: <Widget>[
                  EnterpriseAdminReadOnlyIntroCard(
                    title: l10n.enterpriseAdminEmployeesPageTitle,
                    subtitle: l10n.enterpriseAdminEmployeesPageSubtitle,
                    accent: AppColors.brandBlue,
                    icon: Icons.badge_outlined,
                    summary: l10n.enterpriseAdminEmployeesPageSummary(
                      filteredEmployees.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                  EnterpriseAdminStatsRow(
                    items: <EnterpriseAdminStatItem>[
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminMetricEmployees,
                        value: '${filteredEmployees.length}',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminEmployeesStatsDepartments,
                        value: '${departments.length}',
                      ),
                      EnterpriseAdminStatItem(
                        label: l10n.enterpriseAdminEmployeesStatsPositions,
                        value: '$positionCount',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: provider.setEmployeeKeyword,
                    decoration: InputDecoration(
                      hintText: l10n.enterpriseAdminEmployeesSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  EnterpriseAdminFilterBar(
                    options: <String>[
                      l10n.enterpriseAdminFilterAll,
                      ...departments,
                    ],
                    selectedValue: _selectedDepartment == _allFilter
                        ? l10n.enterpriseAdminFilterAll
                        : _selectedDepartment,
                    onSelected: (String value) {
                      setState(() {
                        _selectedDepartment = value == l10n.enterpriseAdminFilterAll
                            ? _allFilter
                            : value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (filteredEmployees.isEmpty)
                    EnterpriseAdminEmptyStateCard(
                      message: l10n.enterpriseAdminEmployeesEmpty,
                    )
                  else
                    ...filteredEmployees.map(
                      (EmployeeRecord item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _EmployeeCard(record: item),
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

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({required this.record});

  final EmployeeRecord record;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminProvider provider =
        context.read<EnterpriseAdminProvider>();
    final List<EnterpriseAdminEditOption> departmentOptions = provider.departments
        .map(
          (DepartmentRecord item) => EnterpriseAdminEditOption(
            value: item.id,
            label: item.name,
          ),
        )
        .toList();
    return EnterpriseAdminInteractiveCard(
      onTap: () => showEnterpriseAdminDetailSheet(
        context,
        title: record.name,
        rows: _buildDetailRows(context, record),
        timeline: _buildTimeline(l10n),
        directEditConfig: EnterpriseAdminDirectEditConfig(
          title: l10n.enterpriseAdminEditEmployeeTitle,
          hint: l10n.enterpriseAdminEditEmployeeHint,
          submitLabel: l10n.enterpriseAdminEditSubmit,
          fields: <EnterpriseAdminEditField>[
            EnterpriseAdminEditField(
              key: 'departmentId',
              label: l10n.enterpriseAdminDetailDepartment,
              initialValue: record.departmentId,
              options: departmentOptions,
            ),
            EnterpriseAdminEditField(
              key: 'position',
              label: l10n.enterpriseAdminDetailPosition,
              initialValue: record.positionName,
            ),
            EnterpriseAdminEditField(
              key: 'email',
              label: l10n.enterpriseAdminDetailEmail,
              initialValue: record.email,
              keyboardType: TextInputType.emailAddress,
            ),
            EnterpriseAdminEditField(
              key: 'phone',
              label: l10n.enterpriseAdminDetailPhone,
              initialValue: record.phone,
              keyboardType: TextInputType.phone,
            ),
          ],
          onSubmit: (Map<String, String> values) async {
            final EmployeeRecord updated = await provider.updateEmployeeRecord(
              employeeId: record.id,
              departmentId: values['departmentId']!,
              position: values['position']!,
              email: values['email']!,
              phone: values['phone']!,
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
                title: l10n.enterpriseAdminTimelineEmployeeUpdated,
                subtitle: l10n.enterpriseAdminTimelineEmployeeUpdatedDetail(
                  updated.departmentName,
                  updated.positionName,
                  updated.phone,
                  updated.email,
                ),
                timestamp: l10n.enterpriseAdminTimelineRecent,
                accent: AppColors.brandBlue,
              ),
            );
          },
        ),
        onSubmitDraft: (String changeType, String note) async {
          final EmployeeRecord currentRecord = provider.employees.firstWhere(
            (EmployeeRecord item) => item.id == record.id,
            orElse: () => record,
          );
          final ChangeRequestReceipt receipt = await provider.submitChangeRequest(
            entityType: 'employee',
            entityId: currentRecord.id,
            entityName: currentRecord.name,
            changeType: changeType,
            note: note,
            snapshot: <String, String>{
              'employeeNo': currentRecord.employeeNo,
              'department': currentRecord.departmentName,
              'position': currentRecord.positionName,
              'status': currentRecord.status,
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
                        '${record.departmentName} · ${record.positionName}',
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
                    record.status,
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
                  label: l10n.enterpriseAdminDetailEmployeeNo,
                  value: record.employeeNo,
                ),
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminDetailPhone,
                  value: record.phone,
                ),
                EnterpriseAdminDataChip(
                  label: l10n.enterpriseAdminDetailEmail,
                  value: record.email,
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
        title: l10n.enterpriseAdminTimelineEmployeeStatus,
        subtitle: l10n.enterpriseAdminTimelineEmployeeStatusDetail(
          record.status,
        ),
        timestamp: l10n.enterpriseAdminTimelineRecent,
        accent: AppColors.success,
      ),
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelineEmployeeSync,
        subtitle: l10n.enterpriseAdminTimelineEmployeeSyncDetail(
          record.departmentName,
          record.positionName,
        ),
        timestamp: l10n.enterpriseAdminTimelineToday,
        accent: AppColors.brandBlue,
      ),
      EnterpriseAdminTimelineEntry(
        title: l10n.enterpriseAdminTimelineEmployeeCreated,
        subtitle: l10n.enterpriseAdminTimelineEmployeeCreatedDetail(
          record.employeeNo,
        ),
        timestamp: l10n.enterpriseAdminTimelineEarlier,
        accent: AppColors.warning,
      ),
    ];
  }

  List<EnterpriseAdminDetailRow> _buildDetailRows(
    BuildContext context,
    EmployeeRecord target,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return <EnterpriseAdminDetailRow>[
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailEmployeeNo,
        value: target.employeeNo,
        copyValue: target.employeeNo,
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
        label: l10n.enterpriseAdminDetailPosition,
        value: target.positionName,
        copyValue: target.positionName,
        onNavigate: () => context.pushNamed(
          AppRoutes.enterpriseAdminPositions,
          queryParameters: <String, String>{'keyword': target.positionName},
        ),
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailPhone,
        value: target.phone,
        copyValue: target.phone,
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailEmail,
        value: target.email,
        copyValue: target.email,
      ),
      EnterpriseAdminDetailRow(
        label: l10n.enterpriseAdminDetailStatus,
        value: target.status,
        copyValue: target.status,
      ),
    ];
  }
}
