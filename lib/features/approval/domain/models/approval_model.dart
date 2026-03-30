enum ApprovalStatus { pending, approved, rejected }

class ApprovalModel {
  final String id;
  final String title;
  final String applicant;
  final DateTime startTime;
  final String reason;
  ApprovalStatus status;

  ApprovalModel({
    required this.id,
    required this.title,
    required this.applicant,
    required this.startTime,
    required this.reason,
    this.status = ApprovalStatus.pending,
  });
}