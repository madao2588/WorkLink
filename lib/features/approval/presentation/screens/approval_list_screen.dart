import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/features/approval/domain/models/approval_model.dart';
import 'package:my_first_app/features/approval/presentation/providers/approval_provider.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class ApprovalListScreen extends StatelessWidget {
  const ApprovalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final approvalProvider = context.watch<ApprovalProvider>();
    final list = approvalProvider.approvals;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.approvalTitle),
        elevation: 0.5,
      ),
      body: list.isEmpty
          ? _buildEmptyState(l10n)
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return _buildApprovalCard(context, item, l10n);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSubmitDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(l10n.approvalEmpty, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildApprovalCard(
    BuildContext context,
    ApprovalModel item,
    AppLocalizations l10n,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(l10n.approvalReasonLabel(item.reason)),
            const SizedBox(height: 4),
            Text(
              l10n.approvalSubmittedAtLabel(
                DateFormat('MM-dd HH:mm').format(item.startTime),
              ),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: _buildStatusBadge(item.status, l10n),
        onTap: item.status == ApprovalStatus.pending
            ? () => _showActionSheet(context, item.id)
            : null,
      ),
    );
  }

  Widget _buildStatusBadge(ApprovalStatus status, AppLocalizations l10n) {
    Color color;
    String text;
    switch (status) {
      case ApprovalStatus.pending:
        color = Colors.orange;
        text = l10n.approvalStatusPending;
        break;
      case ApprovalStatus.approved:
        color = Colors.green;
        text = l10n.approvalStatusApproved;
        break;
      case ApprovalStatus.rejected:
        color = Colors.red;
        text = l10n.approvalStatusRejected;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showActionSheet(BuildContext context, String id) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                l10n.approvalDecisionTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(l10n.approvalApproveAction),
              onTap: () {
                context.read<ApprovalProvider>().approve(id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: Text(l10n.approvalRejectAction),
              onTap: () {
                context.read<ApprovalProvider>().reject(id);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.approvalSubmitDialogTitle),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.approvalSubmitDialogHint,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.approvalDialogCancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ApprovalProvider>().submitLeave(controller.text);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.approvalDialogSubmit),
          ),
        ],
      ),
    );
  }
}
