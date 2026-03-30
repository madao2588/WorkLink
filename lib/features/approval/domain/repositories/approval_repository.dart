import 'package:my_first_app/features/approval/domain/models/approval_model.dart';

abstract class ApprovalRepository {
  List<ApprovalModel> getApprovals();
  int get pendingCount;
  int get approvedCount;
  int get rejectedCount;
  Future<void> loadApprovals();
  Future<void> submitLeave(String reason);
  Future<void> approve(String id);
  Future<void> reject(String id);
}
