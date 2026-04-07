import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class EnterpriseAdminStatItem {
  const EnterpriseAdminStatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class EnterpriseAdminDetailRow {
  const EnterpriseAdminDetailRow({
    required this.label,
    required this.value,
    this.copyValue,
    this.onNavigate,
  });

  final String label;
  final String value;
  final String? copyValue;
  final VoidCallback? onNavigate;
}

class EnterpriseAdminTimelineEntry {
  const EnterpriseAdminTimelineEntry({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.accent = AppColors.brandBlue,
  });

  final String title;
  final String subtitle;
  final String timestamp;
  final Color accent;
}

class EnterpriseAdminDraftSubmission {
  const EnterpriseAdminDraftSubmission({
    required this.successMessage,
    required this.timelineEntry,
  });

  final String successMessage;
  final EnterpriseAdminTimelineEntry timelineEntry;
}

class EnterpriseAdminEditOption {
  const EnterpriseAdminEditOption({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
}

class EnterpriseAdminEditField {
  const EnterpriseAdminEditField({
    required this.key,
    required this.label,
    required this.initialValue,
    this.options,
    this.keyboardType = TextInputType.text,
  });

  final String key;
  final String label;
  final String initialValue;
  final List<EnterpriseAdminEditOption>? options;
  final TextInputType keyboardType;
}

class EnterpriseAdminDirectEditResult {
  const EnterpriseAdminDirectEditResult({
    required this.successMessage,
    required this.updatedRows,
    this.timelineEntry,
  });

  final String successMessage;
  final List<EnterpriseAdminDetailRow> updatedRows;
  final EnterpriseAdminTimelineEntry? timelineEntry;
}

class EnterpriseAdminDirectEditConfig {
  const EnterpriseAdminDirectEditConfig({
    required this.fields,
    required this.onSubmit,
    this.title,
    this.hint,
    this.submitLabel,
  });

  final List<EnterpriseAdminEditField> fields;
  final Future<EnterpriseAdminDirectEditResult> Function(Map<String, String> values)
      onSubmit;
  final String? title;
  final String? hint;
  final String? submitLabel;
}

class EnterpriseAdminReadOnlyIntroCard extends StatelessWidget {
  const EnterpriseAdminReadOnlyIntroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.summary,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withAlpha(14),
              borderRadius: BorderRadius.circular(16),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  summary,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EnterpriseAdminStatsRow extends StatelessWidget {
  const EnterpriseAdminStatsRow({
    super.key,
    required this.items,
  });

  final List<EnterpriseAdminStatItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 720 ? 1 : 3;
        const double spacing = 12;
        final double itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items
              .map(
                (EnterpriseAdminStatItem item) => SizedBox(
                  width: itemWidth,
                  child: _StatCard(item: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final EnterpriseAdminStatItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class EnterpriseAdminFilterBar extends StatelessWidget {
  const EnterpriseAdminFilterBar({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((String option) {
        return ChoiceChip(
          label: Text(option),
          selected: option == selectedValue,
          onSelected: (_) => onSelected(option),
        );
      }).toList(),
    );
  }
}

class EnterpriseAdminDataChip extends StatelessWidget {
  const EnterpriseAdminDataChip({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
          children: <InlineSpan>[
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class EnterpriseAdminEmptyStateCard extends StatelessWidget {
  const EnterpriseAdminEmptyStateCard({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.textHint,
          height: 1.45,
        ),
      ),
    );
  }
}

class EnterpriseAdminInteractiveCard extends StatelessWidget {
  const EnterpriseAdminInteractiveCard({
    super.key,
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}

Future<void> showEnterpriseAdminDetailSheet(
  BuildContext context, {
  required String title,
  required List<EnterpriseAdminDetailRow> rows,
  List<EnterpriseAdminTimelineEntry> timeline = const <EnterpriseAdminTimelineEntry>[],
  EnterpriseAdminDirectEditConfig? directEditConfig,
  Future<EnterpriseAdminDraftSubmission> Function(String changeType, String note)? onSubmitDraft,
}) {
  final bool useSidePanel = MediaQuery.sizeOf(context).width >= 960;

  if (useSidePanel) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'enterprise-admin-detail',
      barrierColor: Colors.black.withAlpha(80),
      pageBuilder: (
        BuildContext dialogContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return SafeArea(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 460,
                  minWidth: 380,
                ),
                child: _EnterpriseAdminDetailSurface(
                  title: title,
                  rows: rows,
                  timeline: timeline,
                  directEditConfig: directEditConfig,
                  onSubmitDraft: onSubmitDraft,
                  isSidePanel: true,
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        final Animation<Offset> offsetAnimation = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _EnterpriseAdminDetailSurface(
        title: title,
        rows: rows,
        timeline: timeline,
        directEditConfig: directEditConfig,
        onSubmitDraft: onSubmitDraft,
        isSidePanel: false,
      );
    },
  );
}

class _EnterpriseAdminDetailSurface extends StatefulWidget {
  const _EnterpriseAdminDetailSurface({
    required this.title,
    required this.rows,
    required this.timeline,
    required this.directEditConfig,
    required this.onSubmitDraft,
    required this.isSidePanel,
  });

  final String title;
  final List<EnterpriseAdminDetailRow> rows;
  final List<EnterpriseAdminTimelineEntry> timeline;
  final EnterpriseAdminDirectEditConfig? directEditConfig;
  final Future<EnterpriseAdminDraftSubmission> Function(String changeType, String note)?
      onSubmitDraft;
  final bool isSidePanel;

  @override
  State<_EnterpriseAdminDetailSurface> createState() =>
      _EnterpriseAdminDetailSurfaceState();
}

class _EnterpriseAdminDetailSurfaceState
    extends State<_EnterpriseAdminDetailSurface> {
  bool _showTimeline = false;
  bool _showDirectEditPanel = false;
  bool _showDraftPanel = false;
  bool _isSavingDirectEdit = false;
  bool _isSubmittingDraft = false;
  late final TextEditingController _noteController;
  late final Map<String, TextEditingController> _editControllers;
  late final Map<String, String> _editSelectedValues;
  late final List<EnterpriseAdminTimelineEntry> _draftTimelineEntries;
  late List<EnterpriseAdminDetailRow> _localRows;
  String _selectedDraftType = '';

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _editControllers = <String, TextEditingController>{};
    _editSelectedValues = <String, String>{};
    for (final EnterpriseAdminEditField field
        in widget.directEditConfig?.fields ?? const <EnterpriseAdminEditField>[]) {
      if (field.options == null) {
        _editControllers[field.key] = TextEditingController(
          text: field.initialValue,
        );
      } else {
        _editSelectedValues[field.key] = field.initialValue;
      }
    }
    _draftTimelineEntries = <EnterpriseAdminTimelineEntry>[];
    _localRows = <EnterpriseAdminDetailRow>[];
  }

  @override
  void dispose() {
    _noteController.dispose();
    for (final TextEditingController controller in _editControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool hasDirectEdit = widget.directEditConfig != null;
    final List<String> draftTypes = <String>[
      l10n.enterpriseAdminDraftTypeProfile,
      l10n.enterpriseAdminDraftTypeOrg,
      l10n.enterpriseAdminDraftTypeStatus,
    ];
    if (_selectedDraftType.isEmpty) {
      _selectedDraftType = draftTypes.first;
    }
    final List<EnterpriseAdminTimelineEntry> effectiveTimeline =
        <EnterpriseAdminTimelineEntry>[
          ..._draftTimelineEntries,
          ...widget.timeline,
        ];
    final List<EnterpriseAdminDetailRow> effectiveRows = _localRows.isEmpty
        ? widget.rows
        : _localRows;
    final BorderRadius borderRadius = BorderRadius.circular(
      widget.isSidePanel ? 28 : 24,
    );

    final Widget content = Material(
      color: Colors.white,
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          border: Border.all(color: AppColors.border),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.enterpriseAdminDetailPanelSubtitle,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      if (hasDirectEdit)
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showDirectEditPanel = !_showDirectEditPanel;
                              if (_showDirectEditPanel) {
                                _showTimeline = false;
                                _showDraftPanel = false;
                              }
                            });
                          },
                          icon: const Icon(Icons.edit_note_rounded),
                          label: Text(
                            _showDirectEditPanel
                                ? l10n.enterpriseAdminEditActionCollapse
                                : l10n.enterpriseAdminDetailActionDirectEdit,
                          ),
                        ),
                      if (widget.onSubmitDraft != null)
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showDraftPanel = !_showDraftPanel;
                            if (_showDraftPanel) {
                              _showTimeline = false;
                              _showDirectEditPanel = false;
                            }
                          });
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(
                          _showDraftPanel
                              ? l10n.enterpriseAdminDraftActionCollapse
                              : l10n.enterpriseAdminDetailActionRequestChange,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: effectiveTimeline.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  _showTimeline = !_showTimeline;
                                  if (_showTimeline) {
                                    _showDraftPanel = false;
                                    _showDirectEditPanel = false;
                                  }
                                });
                              },
                        icon: const Icon(Icons.history_rounded),
                        label: Text(l10n.enterpriseAdminDetailActionAudit),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.done_rounded),
                        label: Text(l10n.enterpriseAdminDetailActionClose),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      _showTimeline
                          ? l10n.enterpriseAdminTimelineHint
                          : _showDirectEditPanel
                          ? (widget.directEditConfig?.hint ??
                                l10n.enterpriseAdminEditPanelHint)
                          : _showDraftPanel
                          ? l10n.enterpriseAdminDraftPanelHint
                          : l10n.enterpriseAdminDetailPanelHint,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                  if (_showDirectEditPanel && widget.directEditConfig != null) ...<Widget>[
                    const SizedBox(height: 18),
                    Text(
                      widget.directEditConfig!.title ??
                          l10n.enterpriseAdminEditPanelTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...widget.directEditConfig!.fields.map(
                      (EnterpriseAdminEditField field) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: field.options == null
                            ? TextField(
                                controller: _editControllers[field.key],
                                keyboardType: field.keyboardType,
                                decoration: InputDecoration(labelText: field.label),
                              )
                            : DropdownButtonFormField<String>(
                                initialValue: _editSelectedValues[field.key],
                                decoration: InputDecoration(labelText: field.label),
                                items: field.options!
                                    .map(
                                      (EnterpriseAdminEditOption option) =>
                                          DropdownMenuItem<String>(
                                            value: option.value,
                                            child: Text(option.label),
                                          ),
                                    )
                                    .toList(),
                                onChanged: (String? value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() {
                                    _editSelectedValues[field.key] = value;
                                  });
                                },
                              ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _isSavingDirectEdit
                          ? null
                          : () => _submitDirectEdit(context),
                      icon: const Icon(Icons.save_outlined),
                      label: Text(
                        _isSavingDirectEdit
                            ? l10n.enterpriseAdminEditSaving
                            : (widget.directEditConfig!.submitLabel ??
                                  l10n.enterpriseAdminEditSubmit),
                      ),
                    ),
                  ],
                  if (_showDraftPanel) ...<Widget>[
                    const SizedBox(height: 18),
                    Text(
                      l10n.enterpriseAdminDraftPanelTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    EnterpriseAdminFilterBar(
                      options: draftTypes,
                      selectedValue: _selectedDraftType,
                      onSelected: (String value) {
                        setState(() {
                          _selectedDraftType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l10n.enterpriseAdminDraftCurrentSnapshot,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: effectiveRows
                                .take(3)
                                .map(
                                  (EnterpriseAdminDetailRow row) =>
                                      EnterpriseAdminDataChip(
                                        label: row.label,
                                        value: row.value,
                                      ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: l10n.enterpriseAdminDraftInputHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _isSubmittingDraft
                          ? null
                          : () => _submitDraft(context),
                      icon: const Icon(Icons.playlist_add_check_rounded),
                      label: Text(
                        _isSubmittingDraft
                            ? l10n.enterpriseAdminDraftSubmitting
                            : l10n.enterpriseAdminDraftSubmit,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  for (int index = 0; index < effectiveRows.length; index++) ...<Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 96,
                          child: Text(
                            effectiveRows[index].label,
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            effectiveRows[index].value,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              height: 1.45,
                            ),
                          ),
                        ),
                        if (effectiveRows[index].copyValue != null ||
                            effectiveRows[index].onNavigate != null) ...<Widget>[
                          const SizedBox(width: 8),
                          Wrap(
                            spacing: 4,
                            children: <Widget>[
                              if (effectiveRows[index].copyValue != null)
                                IconButton(
                                  tooltip: l10n.enterpriseAdminDetailActionCopy,
                                  onPressed: () => _copyValue(
                                    context,
                                    label: effectiveRows[index].label,
                                    value: effectiveRows[index].copyValue!,
                                  ),
                                  icon: const Icon(
                                    Icons.content_copy_outlined,
                                  ),
                                ),
                              if (effectiveRows[index].onNavigate != null)
                                IconButton(
                                  tooltip: l10n
                                      .enterpriseAdminDetailActionOpenRelated,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    effectiveRows[index].onNavigate!.call();
                                  },
                                  icon: const Icon(Icons.open_in_new_rounded),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    if (index != effectiveRows.length - 1)
                      Divider(color: AppColors.border, height: 22),
                  ],
                  if (_showTimeline) ...<Widget>[
                    const SizedBox(height: 20),
                    Text(
                      l10n.enterpriseAdminTimelineTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (effectiveTimeline.isEmpty)
                      Text(
                        l10n.enterpriseAdminTimelineEmpty,
                        style: const TextStyle(
                          color: AppColors.textHint,
                          height: 1.45,
                        ),
                      )
                    else
                      ...effectiveTimeline.map(
                        (EnterpriseAdminTimelineEntry entry) =>
                            _TimelineEntryCard(entry: entry),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.isSidePanel) {
      return content;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: content,
    );
  }

  Future<void> _submitDirectEdit(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EnterpriseAdminDirectEditConfig? config = widget.directEditConfig;
    if (config == null) {
      return;
    }

    final Map<String, String> values = <String, String>{};
    for (final EnterpriseAdminEditField field in config.fields) {
      final String value = field.options == null
          ? _editControllers[field.key]?.text.trim() ?? ''
          : (_editSelectedValues[field.key] ?? '').trim();
      if (value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.enterpriseAdminEditEmpty)),
        );
        return;
      }
      values[field.key] = value;
    }

    setState(() {
      _isSavingDirectEdit = true;
    });

    try {
      final EnterpriseAdminDirectEditResult result = await config.onSubmit(values);
      if (!context.mounted) {
        return;
      }

      setState(() {
        _localRows = List<EnterpriseAdminDetailRow>.from(result.updatedRows);
        if (result.timelineEntry != null) {
          _draftTimelineEntries.insert(0, result.timelineEntry!);
          _showTimeline = true;
        }
        _showDirectEditPanel = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.successMessage)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingDirectEdit = false;
        });
      }
    }
  }

  Future<void> _submitDraft(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String note = _noteController.text.trim();
    if (note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterpriseAdminDraftEmpty)),
      );
      return;
    }

    setState(() {
      _isSubmittingDraft = true;
    });

    try {
      final EnterpriseAdminDraftSubmission submission =
          await (widget.onSubmitDraft?.call(_selectedDraftType, note) ??
              Future<EnterpriseAdminDraftSubmission>.value(
                EnterpriseAdminDraftSubmission(
                  successMessage: l10n.enterpriseAdminDraftSubmitSuccess,
                  timelineEntry: EnterpriseAdminTimelineEntry(
                    title: l10n.enterpriseAdminDraftTimelineTitle(
                      _selectedDraftType,
                    ),
                    subtitle: l10n.enterpriseAdminDraftTimelineDetail(note),
                    timestamp: l10n.enterpriseAdminTimelineRecent,
                    accent: AppColors.warning,
                  ),
                ),
              ));

      if (!context.mounted) {
        return;
      }

      setState(() {
        _draftTimelineEntries.insert(0, submission.timelineEntry);
        _showDraftPanel = false;
        _showTimeline = true;
        _noteController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(submission.successMessage)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingDraft = false;
        });
      }
    }
  }
}

class _TimelineEntryCard extends StatelessWidget {
  const _TimelineEntryCard({required this.entry});

  final EnterpriseAdminTimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: entry.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            entry.timestamp,
            style: const TextStyle(
              color: AppColors.textHint,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _copyValue(
  BuildContext context, {
  required String label,
  required String value,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context)!;
  await Clipboard.setData(ClipboardData(text: value));
  if (!context.mounted) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.enterpriseAdminDetailCopySuccess(label))),
  );
}
