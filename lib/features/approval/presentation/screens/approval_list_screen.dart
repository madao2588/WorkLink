import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/features/approval/domain/models/approval_model.dart';
import 'package:my_first_app/features/approval/presentation/providers/approval_provider.dart';

class ApprovalListScreen extends StatelessWidget {
  const ApprovalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 监听审批大脑的数据变化
    final approvalProvider = context.watch<ApprovalProvider>();
    final list = approvalProvider.approvals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的审批'),
        elevation: 0.5,
      ),
      body: list.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return _buildApprovalCard(context, item);
              },
            ),
      // 右下角发起申请按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSubmitDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // 为空时的占位界面
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('暂无申请记录', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // 每一条审批的卡片 UI
  Widget _buildApprovalCard(BuildContext context, ApprovalModel item) {
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
            Text('申请原因：${item.reason}'),
            const SizedBox(height: 4),
            Text(
              '提交时间：${DateFormat('MM-dd HH:mm').format(item.startTime)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: _buildStatusBadge(item.status),
        // 只有“待审批”状态才能点击进行操作
        onTap: item.status == ApprovalStatus.pending
            ? () => _showActionSheet(context, item.id)
            : null,
      ),
    );
  }

  // 状态标签：根据状态显示颜色
  Widget _buildStatusBadge(ApprovalStatus status) {
    Color color;
    String text;
    switch (status) {
      case ApprovalStatus.pending:
        color = Colors.orange;
        text = "审批中";
        break;
      case ApprovalStatus.approved:
        color = Colors.green;
        text = "已通过";
        break;
      case ApprovalStatus.rejected:
        color = Colors.red;
        text = "已驳回";
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

  // 底部弹出操作菜单（同意/驳回）
  void _showActionSheet(BuildContext context, String id) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('审批决策', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('同意申请'),
              onTap: () {
                context.read<ApprovalProvider>().approve(id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('驳回申请'),
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

  // 发起请假申请的弹窗
  void _showSubmitDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('发起申请'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: '请输入申请原因（如：感冒请假）',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ApprovalProvider>().submitLeave(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}
