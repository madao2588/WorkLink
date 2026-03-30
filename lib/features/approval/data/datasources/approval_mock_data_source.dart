import 'package:my_first_app/features/approval/domain/models/approval_model.dart';

class ApprovalMockDataSource {
  List<ApprovalModel> fetchApprovals() {
    return <ApprovalModel>[
      ApprovalModel(
        id: 'approval-1',
        title: '请假申请',
        applicant: '张三',
        startTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        reason: '处理家庭事务，申请半天事假',
      ),
      ApprovalModel(
        id: 'approval-2',
        title: '报销申请',
        applicant: '李四',
        startTime: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        reason: '客户拜访交通与餐补报销',
        status: ApprovalStatus.approved,
      ),
    ];
  }
}
