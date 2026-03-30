import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/features/approval/domain/models/approval_model.dart';
import 'package:my_first_app/features/approval/domain/repositories/approval_repository.dart';

class ApprovalRepositoryImpl implements ApprovalRepository {
  ApprovalRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;
  List<ApprovalModel> _approvals = <ApprovalModel>[];

  @override
  List<ApprovalModel> getApprovals() => List<ApprovalModel>.unmodifiable(_approvals);

  @override
  int get pendingCount =>
      _approvals.where((item) => item.status == ApprovalStatus.pending).length;

  @override
  int get approvedCount =>
      _approvals.where((item) => item.status == ApprovalStatus.approved).length;

  @override
  int get rejectedCount =>
      _approvals.where((item) => item.status == ApprovalStatus.rejected).length;

  @override
  Future<void> loadApprovals() async {
    final dynamic data = await _apiClient.get('/approval/instances');
    final List<dynamic> items = (data['items'] as List<dynamic>? ?? <dynamic>[]);
    _approvals = items.map((dynamic item) {
      final Map<String, dynamic> json = item as Map<String, dynamic>;
      return ApprovalModel(
        id: json['id'] as String,
        title: json['title'] as String,
        applicant: json['applicant'] as String,
        startTime: DateTime.parse(json['startTime'] as String),
        reason: json['reason'] as String,
        status: _statusFromApi(json['status'] as String?),
      );
    }).toList();
  }

  @override
  Future<void> submitLeave(String reason) async {
    await _apiClient.post(
      '/approval/instances',
      body: <String, dynamic>{
        'templateCode': 'generic_leave',
        'title': '请假申请',
        'reason': reason,
        'formData': <String, dynamic>{'reason': reason},
        'attachments': <dynamic>[],
      },
    );
    await loadApprovals();
  }

  @override
  Future<void> approve(String id) async {
    await _apiClient.post(
      '/approval/instances/$id/approve',
      body: <String, dynamic>{'comment': '已通过'},
    );
    await loadApprovals();
  }

  @override
  Future<void> reject(String id) async {
    await _apiClient.post(
      '/approval/instances/$id/reject',
      body: <String, dynamic>{'comment': '已驳回'},
    );
    await loadApprovals();
  }

  ApprovalStatus _statusFromApi(String? status) {
    switch (status) {
      case 'APPROVED':
        return ApprovalStatus.approved;
      case 'REJECTED':
        return ApprovalStatus.rejected;
      case 'PENDING':
      default:
        return ApprovalStatus.pending;
    }
  }
}
