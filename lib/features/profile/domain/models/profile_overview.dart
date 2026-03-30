import 'package:my_first_app/app/shared/models/user_model.dart';

class ProfileOverview {
  const ProfileOverview({
    required this.user,
    required this.attendanceStatus,
    required this.hasCheckedIn,
    required this.checkInTime,
    required this.pendingApprovalCount,
    required this.totalMessageCount,
    required this.unreadMessageCount,
  });

  final UserModel user;
  final String attendanceStatus;
  final bool hasCheckedIn;
  final DateTime? checkInTime;
  final int pendingApprovalCount;
  final int totalMessageCount;
  final int unreadMessageCount;
}
